import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin'

admin.initializeApp()

const db = admin.firestore()

function updateBadgeCount(uid: string, badgeCount: number) {
    admin.firestore().collection('accounts').doc(uid).update({
        badge_count: badgeCount   
    })
    .then(() => console.log('Badge count updated'))
    .catch(() => 'Error updating badge count')
}

function updateMessagesCount(uid: string, messagesCount: number) {
    admin.firestore().collection('accounts').doc(uid).update({
        messages_count: messagesCount   
    })
    .then(() => console.log('Messages count updated'))
    .catch(() => 'Error updating messages count')
}

function updateChat(chatId: string, message: string, sender: string) {
    admin.firestore().collection('chats').doc(chatId).update({
        last_message: message,
        last_message_sender: sender,
        is_new: true,
        last_updated: new Date()
    })
    .then(() => console.log('Chat updated'))
    .catch(() => 'Error updating chat')
}

// exports.onAlertCreated = functions.firestore
//     .document('accounts/{account_id}/alerts/{alert_id}')
//     .onCreate(async (snapshot, context) => {
//     const uid = context.params.account_id
//     const data = snapshot.data()
//     const status = data.event_status as string
//     const eventName = data.event_name as string
//     const reminder = data.start_reminder as boolean

//     const customData = {
//         type: "other"
//     }

//     return db.collection('accounts').doc(uid).get().then((snap) => {
//         if (reminder === false) {
//             const accountData = snap.data()!
//             const token = accountData.token
//             let badgeCount = accountData.badge_count
//             const settings = accountData.notification_settings as {alert_received:boolean}
//             badgeCount++
//             updateBadgeCount(uid, badgeCount)
//             if (settings.alert_received === true) {
//                 const message = eventName + ' is now ' + status + "!"
//                 sendNotification(message, customData, badgeCount, token)
//             }   
//         } 
//     })
//     .then(() => console.log('Alert Push Notification Sent'))
//     .catch(() => 'Error sending alert push notification')
// })

exports.onNotificationCreated = functions.firestore
    .document('accounts/{account_id}/notifications/{notificationId}')
    .onCreate(async (snapshot, context) => {
    const uid = context.params.account_id
    const data = snapshot.data()
    const type = data.notification_type as string
    const notificationData = data.notification_data as {username:string, event_name:string, event_status:string, start_reminder:string}
    const username = notificationData.username

    return db.collection('accounts').doc(uid).get().then((snap) => {
        const accountData = snap.data()!
        const token = accountData.token
        let badgeCount = accountData.badge_count
        const settings = accountData.notification_settings as {follow_request:boolean, follow_start:boolean, follow_accepted:boolean, invite_to_event:boolean, event_going:boolean, event_comment:boolean, alert_received:boolean}
        badgeCount++

        const customData = {
            type: "other"
        }

        if (type === 'follow_request' && settings.follow_request === true) {                
            const message = username + ' requested to follow you.'
            sendNotification(message, customData, badgeCount, token)   
        }
        else if (type === 'follow_start' && settings.follow_start === true) {
            const message = username + ' started following you.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'follow_accepted' && settings.follow_accepted === true) {
            const message = username + ' accepted your follow request.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'invite_to_event' && settings.invite_to_event === true) {
            const message = username + ' invited you to an event.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'event_going' && settings.event_going === true) {
            const message = username + ' is coming to your event.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'event_comment' && settings.event_comment === true) {
            const message = username + ' commented on your event.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'review_submitted') {
            const message = username + ' rated your venue.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'event_created') {
            const message = username + ' has posted a new event.'
            sendNotification(message, customData, badgeCount, token)
        }
        else if (type === 'event_alert' && settings.alert_received === true) {
            const eventName = notificationData.event_name
            const status = notificationData.event_status
            const message = eventName + ' is now ' + status + "!"
            const reminder = notificationData.start_reminder
            if (reminder === 'false') {
                sendNotification(message, customData, badgeCount, token)
            }
        }
        else if(type === 'event_assigned') {
            const message = 'You have been invited to claim an event.'
            console.log('Event Assigned Notification Created')
            sendNotification(message, customData, badgeCount, token)
        }
        updateBadgeCount(uid, badgeCount)
    })
    .then(() => console.log('Called send notification'))
    .catch(() => 'Error calling send notification')
})

function sendNotification(body: string, data: { [key: string]: any }, badgeCount: number, token: string) {        
    const message = {
        notification: {
             body: body,
        },
        data: data,
        token: token,
        android: {
            notification: {
              sound: "default", // Use the default notification sound on Android
            },
        },
        apns: {
            payload: {
              aps: {
                sound: "default", // Use the default notification sound on iOS
              },
            },
        }
    }
    admin.messaging().send(message)
    .then(() => console.log('Push notification sent'))
    .catch(() => 'Error sending push notification')
}

function sendNotificationWithTitle(title: string, body: string, data: { [key: string]: any }, badgeCount: number, token: string) {        
    const message = {  
           notification: {
             body: body,
             title: title
        },
        data: data,
        token: token,
        android: {
            notification: {
              sound: "default", // Use the default notification sound on Android
            },
        },
        apns: {
            payload: {
              aps: {
                sound: "default", // Use the default notification sound on iOS
              },
            },
        }
     }
    admin.messaging().send(message)
    .then()
    .catch()
}

function sendNotificationToTopic(title: string, body: string, data: { [key: string]: any }, topic: string) {        
    const message = {  
           notification: {
             body: body,
             title: title
        },
        data: data,
        topic: topic,
        android: {
            notification: {
              sound: "default", // Use the default notification sound on Android
            },
        },
        apns: {
            payload: {
              aps: {
                sound: "default", // Use the default notification sound on iOS
              },
            },
        }
     }
    admin.messaging().send(message)
    .then(() => console.log('Push notification sent to ' + topic))
    .catch(() => 'Error sending push notification')
}

exports.sendNotificationToTopicHttp = functions.https
    .onCall((data, _context) => {
        const title = data.title
        const body = data.body
        const attachment = data.attachment as { [key: string]: any }
        const topic = data.topic

        sendNotificationToTopic(title, body, attachment, topic)
})

exports.onDirectMessageCreate = functions.firestore
.document('chats/{chatId}/messages/{messageId}')
.onCreate(async (snapshot, context) => {
    const chatId = context.params.chatId
    const data = snapshot.data()
    const messageType = data.message_type as string
    const name = data.sender_name as string
    const sender = data.sender as string
    const uid = data.recipient as string

    return db.collection('accounts').doc(uid).get().then((snap) => {
        const accountData = snap.data()!
        const token = accountData.token
        //const name = accountData.username
        const badgeCount = accountData.badge_count
        let messagesCount = accountData?.messages_count ?? 0
        const settings = accountData.notification_settings as {message:boolean}
        messagesCount++
        const totalCount = badgeCount + messagesCount

        const customData = {
            type: "chat",
            id: chatId
        }
        
        if (settings.message === true) {
            if (messageType === 'text') {
                const messageData = data.message_data as {message:string}
                const message = messageData.message
                sendNotificationWithTitle(name, message, customData, totalCount, token)
                updateChat(chatId, message, sender)
            }
            else if (messageType === 'account') {
                const message = 'Shared an account.'
                sendNotificationWithTitle(name, message, customData, totalCount, token)
                updateChat(chatId, message, sender)
            }
            else if (messageType === 'event') {
                const message =  'Shared an event.'
                sendNotificationWithTitle(name, message, customData, totalCount, token)
                updateChat(chatId, message, sender)
            }
        }  
        updateMessagesCount(uid, messagesCount)  
})
    .then(() => console.log('Message Notification Sent'))
    .catch(() => 'Error sending message push notification')
})

exports.updateReviewCount = functions.firestore
.document('accounts/{accountId}/reviews/{reviewId}')
.onCreate(async (snapshot, context) => {
    const reviewData = snapshot.data()
    const rating = reviewData!.rating as number
    const accountId = context.params.accountId

    return db.collection('accounts').doc(accountId).get().then((snap) => {
        const accountData = snap.data()
        let reviews = accountData?.number_of_reviews as number ?? 0
        const accountRating = accountData?.rating as number ?? 1
        const value1 = (accountRating * reviews)
        const value2 = value1 + rating
        const value3 = reviews + 1
        const newRating = value2 / value3
        reviews++
        updateVenueRating(accountId, newRating, reviews)
    }).catch()
})

function updateVenueRating(uid: string, rating: number, reviews: number) {
    db.collection('accounts').doc(uid).set({
        number_of_reviews: reviews,
        rating: rating 
    }, {merge: true})
    .then(() => console.log('Vanue rating updated'))
    .catch(() => 'Error updating venue rating')
}

exports.onEventStatusChanged = functions.firestore
    .document('events/{eventId}')
    .onUpdate(async (change, context) => {
        const newData = change.after.data()!
        const oldData = change.before.data()!

        if (newData.event_status === oldData.event_status) {
            return null
        } 

        const attending = newData.attending as Array<string>
        const date = admin.firestore.Timestamp.fromDate(new Date())

        attending.forEach(uid => {
            db.collection('accounts').doc(uid).collection('notifications').doc().set({  
                date: date,
                sender: newData.created_by,
                notification_type: 'event_alert',
                notification_data: {
                    event_id: context.params.eventId,
                    event_name: newData.event_name,
                    event_flyer_url: newData.event_flyer_url,
                    event_status: newData.event_status,
                    start_reminder: 'false'
                }
            })
            .then(() => console.log('Alert Sent'))
            .catch(() => 'Error sending alert')
        })

        return null
    })

exports.updateTopicPostCount = functions.firestore
.document('events/{eventId}/topics/{topicId}/messages/{messageId}')
.onCreate(async (snapshot, context) => {
    const eventId = context.params.eventId
    const topicId = context.params.topicId

    return db.collection('events').doc(eventId).collection('topics').doc(topicId).get().then((snap) => {
        const topicData = snap.data()
        let posts = topicData?.number_of_posts as number ?? 0
        let newPosts = topicData?.new_posts as number ?? 0
        posts++
        newPosts++
        db.collection('events').doc(eventId).collection('topics').doc(topicId).set({
            number_of_posts: posts,
            new_posts: newPosts,
        }, {merge: true})
        .then(() =>
            db.collection('events').doc(eventId).set({
                has_new_posts: true,
            }, {merge: true})
        )
        .catch()
    }).catch()
})

exports.sendNotificationToEventAttendees = functions.https
    .onCall((data, _context) => {
        const eventId = data.eventId
        const notification = data.notification

        const ref = db.collection('events').doc(eventId)
        const date = admin.firestore.Timestamp.fromDate(new Date())
        notification.date = date

       ref.get().then((snap) => {
            const eventData = snap.data()!
            const attendees = eventData.attending as Array<string>
            attendees.forEach(uid => {
                return db.collection('accounts').doc(uid).collection('notifications').doc().set(
                    notification
                )
            })
        }).catch()
})

function getPathStorageFromUrl(url:String){
    const baseUrl = "https://firebasestorage.googleapis.com:443/v0/b/slydeapp-dc745.appspot.com/o/";
    let imagePath:string = url.replace(baseUrl,"");
    const indexOfEndPath = imagePath.indexOf("?");
    imagePath = imagePath.substring(0,indexOfEndPath);    
    imagePath = imagePath.replace("%2F","/"); 
    return imagePath;
}

async function deleteFileFromStorage(filePath: string) {
    const file = admin.storage().bucket().file(filePath)
    try {
        await file.delete()
        console.log('File Deleted')
    }
    catch(error) {
        console.log('Error Deleteing File ' + error)
    }
}

exports.onEventDelete = functions.firestore
.document('events/{eventId}')
.onDelete(async (snapshot, context) => {
    const eventId = context.params.eventId

    const searchIndexRef = admin.firestore().collection('prod_search_index')

    try {
        await searchIndexRef.doc(eventId).delete()
    } catch (error) {
        console.error('Error deleting document from search index:', error);
    }

    await deleteCollection(db, `events/${eventId}/topics`, 10);
    await deleteCollection(db, `events/${eventId}/comments`, 10);

    const imageUrl = snapshot.data().event_flyer_url
    const imagePath:string = getPathStorageFromUrl(imageUrl);
    deleteFileFromStorage(imagePath)
})

exports.onAccountDelete = functions.firestore
.document('accounts/{accountId}')
.onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const accountId = context.params.accountId

    const eventsRef = db.collection('events')
    const searchIndexRef = db.collection('prod_search_index')

            try {
            await searchIndexRef.doc(accountId).delete()
        } catch (error) {
            console.error('Error deleting document from search index:', error);
        }
    
        await deleteCollection(db, `accounts/${accountId}/notifications`, 10);
        await deleteCollection(db, `accounts/${accountId}/nfp_invited`, 10);
        await deleteCollection(db, `accounts/${accountId}/reviews`, 10);

    await eventsRef
        .where('attending', 'array-contains', accountId)
        .get()
        .then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
                const documentRef = db.collection('events').doc(doc.id)
                documentRef.update({
                    'attending': admin.firestore.FieldValue.arrayRemove(accountId)
                })
                .then(() => console.log('Removed from attenfing event'))
                .catch(() => 'Error removing from attending event')
            })
        })

    await eventsRef
        .where('interested', 'array-contains', accountId)
        .get()
        .then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
                const documentRef = db.collection('events').doc(doc.id)
                documentRef.update({
                    'interested': admin.firestore.FieldValue.arrayRemove(accountId)
                })
                .then(() => console.log('Removed from interested event'))
                .catch(() => 'Error removing from interested event')
            })
        })

    await eventsRef
        .where('invited', 'array-contains', accountId)
        .get()
        .then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
                const documentRef = db.collection('events').doc(doc.id)
                documentRef.update({
                    'invited': admin.firestore.FieldValue.arrayRemove(accountId)
                })
                .then(() => console.log('Removed from invited event'))
                .catch(() => 'Error removing from invited event')
            })
        })

    const imageUrl = snapshot.data().profile_image_url
    const imagePath:string = getPathStorageFromUrl(imageUrl);

    deleteFileFromStorage(imagePath)
})

exports.onChatDelete = functions.firestore
.document('chats/{chatId}')
.onDelete(async (snapshot, context) => {
    const chatId = context.params.chatId

    await deleteCollection(db, `chats/${chatId}/messages`, 10);
})

async function deleteCollection(
    db: FirebaseFirestore.Firestore,
    collectionPath: string,
    batchSize: number
  ): Promise<void> {
    let numDeleted = 0;
    do {
      numDeleted = await deleteQueryBatch(db, collectionPath, batchSize);
    } while (numDeleted > 0);
  }
  
  async function deleteQueryBatch(
    db: FirebaseFirestore.Firestore,
    collectionPath: string,
    batchSize: number
  ): Promise<number> {
    const query = db.collection(collectionPath).limit(batchSize);
    const snapshot = await query.get();
  
    if (snapshot.empty) {
      return 0;
    }
  
    const batch = db.batch();
    snapshot.docs.forEach((doc) => {
      batch.delete(doc.ref);
      console.log(`Successfully deleted document in subcollection`);
    });
  
    await batch.commit();
    return snapshot.size;
  }

exports.listAllUsers = functions.https.onCall(async () => {
    
    try {
        const listUsers: any = async (nextPageToken?: string) => {
            const result = await admin.auth().listUsers(1000, nextPageToken);
            const users = result.users;
            if (result.pageToken) {
              return users.concat(await listUsers(result.pageToken));
            }
            return users;
          };

          const allUsers = await listUsers();
          const usersData = allUsers.map((userRecord: { uid: any; email: any; displayName: any; disabled: any; metadata: { creationTime: any; lastSignInTime: any; }; }) => {
            return {
                uid: userRecord.uid,
                email: userRecord.email,
                displayName: userRecord.displayName,
                disabled: userRecord.disabled,
                creationTime: userRecord.metadata.creationTime,
                lastSignInTime: userRecord.metadata.lastSignInTime,
            };
        });
        return { users: usersData, count: usersData.length };
    } catch (error: any) {
        console.log(error)
      throw new functions.https.HttpsError('unknown', error.message, error);
    }
  })

  exports.getUser = functions.https.onCall(async (data, context) => {
    const uid = data.uid;
    if (!uid) {
        throw new functions.https.HttpsError("invalid-argument", "UID is required");
    }
    try {
        const userRecord = await admin.auth().getUser(uid);
        return { uid: userRecord.uid, email: userRecord.email };
    } catch (error: any) {
        if (error.code === "auth/user-not-found") {
            return { uid: null };
        }
        throw new functions.https.HttpsError("internal", error.message);
    }
})

  exports.updateUser = functions.https
    .onCall((data, _context) => {
        const uid = data.uid
        const info = data.info
        try {
            admin.auth().updateUser(uid, info);
            console.log(`Successfully updated user: ${uid}`);
          } catch (error: any) {
            console.error('Error updating user:', error);
            throw new Error(`Failed to update user: ${error.message}`);
          }
})

exports.deleteUser = functions.https
.onCall((data, _context) => {
    const uid = data.uid
    
    try {
        admin.auth().deleteUser(uid)
        console.log(`Successfully deleted user: ${uid}`);
      } catch (error: any) {
        console.error('Error deleting user:', error);
        throw new Error(`Failed to delete user: ${error.message}`);
      }
})

exports.updateGroupOfUsers = functions.https
    .onCall((data, _context) => {
        const users = data.users as Array<{[key: string]: string}>

        users.forEach((user) => {
            const uid = user['uid']
            const info = {
                displayName: user['displayName'],
                photoURL: user['photoURL']
              };

              try {
                admin.auth().updateUser(uid, info);
                console.log(`Successfully updated user: ${uid}`);
              } catch (error: any) {
                console.error('Error updating user:', error);
                throw new Error(`Failed to update user: ${error.message}`);
              }
        })
})