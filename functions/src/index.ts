import { onDocumentCreated, onDocumentDeleted, onDocumentUpdated } from 'firebase-functions/v2/firestore'
import { HttpsError, onCall } from 'firebase-functions/v2/https'
import * as admin from 'firebase-admin'
import { FieldValue, Timestamp } from 'firebase-admin/firestore'

admin.initializeApp()

const db = admin.firestore()

// 2nd gen throttles CPU once a handler returns, so every write below is awaited.

async function updateBadgeCount(uid: string, badgeCount: number) {
    try {
        await db.collection('accounts').doc(uid).update({ badge_count: badgeCount })
        console.log('Badge count updated')
    } catch (error) {
        console.error('Error updating badge count', error)
    }
}

async function updateMessagesCount(uid: string, messagesCount: number) {
    try {
        await db.collection('accounts').doc(uid).update({ messages_count: messagesCount })
        console.log('Messages count updated')
    } catch (error) {
        console.error('Error updating messages count', error)
    }
}

async function updateChat(chatId: string, message: string, sender: string) {
    try {
        await db.collection('chats').doc(chatId).update({
            last_message: message,
            last_message_sender: sender,
            is_new: true,
            last_updated: new Date()
        })
        console.log('Chat updated')
    } catch (error) {
        console.error('Error updating chat', error)
    }
}

async function send(message: admin.messaging.Message) {
    try {
        await admin.messaging().send(message)
        console.log('Push notification sent')
    } catch (error) {
        console.error('Error sending push notification', error)
    }
}

const sound = {
    android: { notification: { sound: 'default' } },
    apns: { payload: { aps: { sound: 'default' } } }
}

function sendNotification(body: string, data: { [key: string]: string }, _badgeCount: number, token: string) {
    return send({ notification: { body }, data, token, ...sound })
}

function sendNotificationWithTitle(title: string, body: string, data: { [key: string]: string }, _badgeCount: number, token: string) {
    return send({ notification: { body, title }, data, token, ...sound })
}

function sendNotificationToTopic(title: string, body: string, data: { [key: string]: string }, topic: string) {
    return send({ notification: { body, title }, data, topic, ...sound })
}

export const onNotificationCreated = onDocumentCreated(
    'accounts/{account_id}/notifications/{notificationId}',
    async (event) => {
        const snapshot = event.data
        if (!snapshot) return
        const uid = event.params.account_id
        const data = snapshot.data()
        const type = data.notification_type as string
        const notificationData = data.notification_data as { username: string, event_name: string, event_status: string, start_reminder: string }
        const username = notificationData.username

        const accountData = (await db.collection('accounts').doc(uid).get()).data()
        if (!accountData) return
        const token = accountData.token
        let badgeCount = accountData.badge_count
        const settings = accountData.notification_settings as { follow_request: boolean, follow_start: boolean, follow_accepted: boolean, invite_to_event: boolean, event_going: boolean, event_comment: boolean, alert_received: boolean }
        badgeCount++

        const customData = { type: 'other' }

        let message: string | undefined
        if (type === 'follow_request' && settings.follow_request === true) {
            message = username + ' requested to follow you.'
        } else if (type === 'follow_start' && settings.follow_start === true) {
            message = username + ' started following you.'
        } else if (type === 'follow_accepted' && settings.follow_accepted === true) {
            message = username + ' accepted your follow request.'
        } else if (type === 'invite_to_event' && settings.invite_to_event === true) {
            message = username + ' invited you to an event.'
        } else if (type === 'event_going' && settings.event_going === true) {
            message = username + ' is coming to your event.'
        } else if (type === 'event_comment' && settings.event_comment === true) {
            message = username + ' commented on your event.'
        } else if (type === 'review_submitted') {
            message = username + ' rated your venue.'
        } else if (type === 'event_created') {
            message = username + ' has posted a new event.'
        } else if (type === 'event_alert' && settings.alert_received === true) {
            if (notificationData.start_reminder === 'false') {
                message = notificationData.event_name + ' is now ' + notificationData.event_status + '!'
            }
        } else if (type === 'event_assigned') {
            message = 'You have been invited to claim an event.'
            console.log('Event Assigned Notification Created')
        }

        if (message) {
            await sendNotification(message, customData, badgeCount, token)
        }
        await updateBadgeCount(uid, badgeCount)
    }
)

export const sendNotificationToTopicHttp = onCall(async (request) => {
    const { title, body, attachment, topic } = request.data
    await sendNotificationToTopic(title, body, attachment as { [key: string]: string }, topic)
})

export const onDirectMessageCreate = onDocumentCreated(
    'chats/{chatId}/messages/{messageId}',
    async (event) => {
        const snapshot = event.data
        if (!snapshot) return
        const chatId = event.params.chatId
        const data = snapshot.data()
        const messageType = data.message_type as string
        const name = data.sender_name as string
        const sender = data.sender as string
        const uid = data.recipient as string

        const accountData = (await db.collection('accounts').doc(uid).get()).data()
        if (!accountData) return
        const token = accountData.token
        const badgeCount = accountData.badge_count
        let messagesCount = accountData.messages_count ?? 0
        const settings = accountData.notification_settings as { message: boolean }
        messagesCount++
        const totalCount = badgeCount + messagesCount

        const customData = { type: 'chat', id: chatId }

        if (settings.message === true) {
            let message: string | undefined
            if (messageType === 'text') {
                message = (data.message_data as { message: string }).message
            } else if (messageType === 'account') {
                message = 'Shared an account.'
            } else if (messageType === 'event') {
                message = 'Shared an event.'
            }
            if (message) {
                await sendNotificationWithTitle(name, message, customData, totalCount, token)
                await updateChat(chatId, message, sender)
            }
        }
        await updateMessagesCount(uid, messagesCount)
    }
)

export const updateReviewCount = onDocumentCreated(
    'accounts/{accountId}/reviews/{reviewId}',
    async (event) => {
        const reviewData = event.data?.data()
        if (!reviewData) return
        const rating = reviewData.rating as number
        const accountId = event.params.accountId

        const accountData = (await db.collection('accounts').doc(accountId).get()).data()
        let reviews = accountData?.number_of_reviews as number ?? 0
        const accountRating = accountData?.rating as number ?? 1
        const newRating = (accountRating * reviews + rating) / (reviews + 1)
        reviews++
        await updateVenueRating(accountId, newRating, reviews)
    }
)

async function updateVenueRating(uid: string, rating: number, reviews: number) {
    try {
        await db.collection('accounts').doc(uid).set({
            number_of_reviews: reviews,
            rating: rating
        }, { merge: true })
        console.log('Venue rating updated')
    } catch (error) {
        console.error('Error updating venue rating', error)
    }
}

export const onEventStatusChanged = onDocumentUpdated('events/{eventId}', async (event) => {
    const newData = event.data?.after.data()
    const oldData = event.data?.before.data()
    if (!newData || !oldData || newData.event_status === oldData.event_status) {
        return
    }

    const attending = (newData.attending ?? []) as Array<string>
    const date = Timestamp.fromDate(new Date())

    await Promise.all(attending.map(async (uid) => {
        try {
            await db.collection('accounts').doc(uid).collection('notifications').doc().set({
                date: date,
                sender: newData.created_by,
                notification_type: 'event_alert',
                notification_data: {
                    event_id: event.params.eventId,
                    event_name: newData.event_name,
                    event_flyer_url: newData.event_flyer_url,
                    event_status: newData.event_status,
                    start_reminder: 'false'
                }
            })
            console.log('Alert Sent')
        } catch (error) {
            console.error('Error sending alert', error)
        }
    }))
})

export const updateTopicPostCount = onDocumentCreated(
    'events/{eventId}/topics/{topicId}/messages/{messageId}',
    async (event) => {
        const { eventId, topicId } = event.params
        const topicRef = db.collection('events').doc(eventId).collection('topics').doc(topicId)

        const topicData = (await topicRef.get()).data()
        const posts = (topicData?.number_of_posts as number ?? 0) + 1
        const newPosts = (topicData?.new_posts as number ?? 0) + 1
        await topicRef.set({ number_of_posts: posts, new_posts: newPosts }, { merge: true })
        await db.collection('events').doc(eventId).set({ has_new_posts: true }, { merge: true })
    }
)

export const sendNotificationToEventAttendees = onCall(async (request) => {
    const eventId = request.data.eventId
    const notification = request.data.notification
    notification.date = Timestamp.fromDate(new Date())

    const eventData = (await db.collection('events').doc(eventId).get()).data()
    const attendees = (eventData?.attending ?? []) as Array<string>
    await Promise.all(attendees.map((uid) =>
        db.collection('accounts').doc(uid).collection('notifications').doc().set(notification)
    ))
})

function getPathStorageFromUrl(url: string) {
    const baseUrl = 'https://firebasestorage.googleapis.com:443/v0/b/slydeapp-dc745.appspot.com/o/'
    let imagePath: string = url.replace(baseUrl, '')
    const indexOfEndPath = imagePath.indexOf('?')
    imagePath = imagePath.substring(0, indexOfEndPath)
    imagePath = imagePath.replace('%2F', '/')
    return imagePath
}

async function deleteFileFromStorage(filePath: string) {
    try {
        await admin.storage().bucket().file(filePath).delete()
        console.log('File Deleted')
    } catch (error) {
        console.log('Error Deleteing File ' + error)
    }
}

export const onEventDelete = onDocumentDeleted('events/{eventId}', async (event) => {
    const eventId = event.params.eventId

    try {
        await db.collection('prod_search_index').doc(eventId).delete()
    } catch (error) {
        console.error('Error deleting document from search index:', error)
    }

    await deleteCollection(`events/${eventId}/topics`, 10)
    await deleteCollection(`events/${eventId}/comments`, 10)

    const imageUrl = event.data?.data()?.event_flyer_url
    if (imageUrl) {
        await deleteFileFromStorage(getPathStorageFromUrl(imageUrl))
    }
})

async function removeFromEventArrays(field: 'attending' | 'interested' | 'invited', accountId: string) {
    const querySnapshot = await db.collection('events').where(field, 'array-contains', accountId).get()
    await Promise.all(querySnapshot.docs.map(async (doc) => {
        try {
            await doc.ref.update({ [field]: FieldValue.arrayRemove(accountId) })
            console.log(`Removed from ${field} event`)
        } catch (error) {
            console.error(`Error removing from ${field} event`, error)
        }
    }))
}

export const onAccountDelete = onDocumentDeleted('accounts/{accountId}', async (event) => {
    const accountId = event.params.accountId

    try {
        await db.collection('prod_search_index').doc(accountId).delete()
    } catch (error) {
        console.error('Error deleting document from search index:', error)
    }

    await deleteCollection(`accounts/${accountId}/notifications`, 10)
    await deleteCollection(`accounts/${accountId}/nfp_invited`, 10)
    await deleteCollection(`accounts/${accountId}/reviews`, 10)

    await removeFromEventArrays('attending', accountId)
    await removeFromEventArrays('interested', accountId)
    await removeFromEventArrays('invited', accountId)

    const imageUrl = event.data?.data()?.profile_image_url
    if (imageUrl) {
        await deleteFileFromStorage(getPathStorageFromUrl(imageUrl))
    }
})

export const onChatDelete = onDocumentDeleted('chats/{chatId}', async (event) => {
    await deleteCollection(`chats/${event.params.chatId}/messages`, 10)
})

async function deleteCollection(collectionPath: string, batchSize: number): Promise<void> {
    let numDeleted = 0
    do {
        numDeleted = await deleteQueryBatch(collectionPath, batchSize)
    } while (numDeleted > 0)
}

async function deleteQueryBatch(collectionPath: string, batchSize: number): Promise<number> {
    const snapshot = await db.collection(collectionPath).limit(batchSize).get()
    if (snapshot.empty) {
        return 0
    }

    const batch = db.batch()
    snapshot.docs.forEach((doc) => batch.delete(doc.ref))
    await batch.commit()
    console.log(`Deleted ${snapshot.size} documents from ${collectionPath}`)
    return snapshot.size
}

export const listAllUsers = onCall(async () => {
    try {
        const users: admin.auth.UserRecord[] = []
        let pageToken: string | undefined
        do {
            const result = await admin.auth().listUsers(1000, pageToken)
            users.push(...result.users)
            pageToken = result.pageToken
        } while (pageToken)

        const usersData = users.map((userRecord) => ({
            uid: userRecord.uid,
            email: userRecord.email,
            displayName: userRecord.displayName,
            disabled: userRecord.disabled,
            creationTime: userRecord.metadata.creationTime,
            lastSignInTime: userRecord.metadata.lastSignInTime,
        }))
        return { users: usersData, count: usersData.length }
    } catch (error: any) {
        console.log(error)
        throw new HttpsError('unknown', error.message, error)
    }
})

export const getUser = onCall(async (request) => {
    const uid = request.data.uid
    if (!uid) {
        throw new HttpsError('invalid-argument', 'UID is required')
    }
    try {
        const userRecord = await admin.auth().getUser(uid)
        return { uid: userRecord.uid, email: userRecord.email }
    } catch (error: any) {
        if (error.code === 'auth/user-not-found') {
            return { uid: null }
        }
        throw new HttpsError('internal', error.message)
    }
})

export const updateUser = onCall(async (request) => {
    const { uid, info } = request.data
    try {
        await admin.auth().updateUser(uid, info)
        console.log(`Successfully updated user: ${uid}`)
    } catch (error: any) {
        console.error('Error updating user:', error)
        throw new HttpsError('internal', `Failed to update user: ${error.message}`)
    }
})

export const deleteUser = onCall(async (request) => {
    const uid = request.data.uid
    try {
        await admin.auth().deleteUser(uid)
        console.log(`Successfully deleted user: ${uid}`)
    } catch (error: any) {
        console.error('Error deleting user:', error)
        throw new HttpsError('internal', `Failed to delete user: ${error.message}`)
    }
})

export const updateGroupOfUsers = onCall(async (request) => {
    const users = request.data.users as Array<{ [key: string]: string }>

    for (const user of users) {
        const uid = user['uid']
        const info = { displayName: user['displayName'], photoURL: user['photoURL'] }
        try {
            await admin.auth().updateUser(uid, info)
            console.log(`Successfully updated user: ${uid}`)
        } catch (error) {
            // Keep going so one bad user doesn't block the rest.
            console.error(`Error updating user ${uid}:`, error)
        }
    }
})
