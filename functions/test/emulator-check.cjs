// Exercises the v2 functions against the local emulators (demo project, nothing real is touched).
// Run with `npm test` (needs Java 21+ for the Firestore emulator).
const admin = require('firebase-admin')
const assert = require('assert/strict')

const PROJECT = 'demo-nightflyy'
admin.initializeApp({ projectId: PROJECT })
const db = admin.firestore()

async function waitFor(label, check) {
  for (let i = 0; i < 40; i++) {
    try { if (await check()) { console.log('PASS', label); return } } catch {}
    await new Promise((r) => setTimeout(r, 500))
  }
  throw new Error('FAIL ' + label)
}

async function call(name, data) {
  const res = await fetch(`http://127.0.0.1:5001/${PROJECT}/us-central1/${name}`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ data })
  })
  return { status: res.status, body: await res.json() }
}

const acct = (id) => db.doc(`accounts/${id}`)

async function main() {
  await acct('u1').set({
    token: 'fake-token', badge_count: 0, messages_count: 0, rating: 4, number_of_reviews: 1,
    notification_settings: { follow_start: true, message: true, alert_received: true }
  })

  await db.doc('accounts/u1/notifications/n1').set({ notification_type: 'follow_start', notification_data: { username: 'bob' } })
  await waitFor('onNotificationCreated bumps badge_count', async () => (await acct('u1').get()).data().badge_count === 1)

  await db.doc('accounts/u1/reviews/r1').set({ rating: 2 })
  await waitFor('updateReviewCount averages rating', async () => {
    const d = (await acct('u1').get()).data()
    return d.rating === 3 && d.number_of_reviews === 2
  })

  await db.doc('chats/c1').set({ members: ['u1', 'u2'] })
  await db.doc('chats/c1/messages/m1').set({ message_type: 'text', sender_name: 'bob', sender: 'u2', recipient: 'u1', message_data: { message: 'hi' } })
  await waitFor('onDirectMessageCreate updates chat and messages_count', async () => {
    const chat = (await db.doc('chats/c1').get()).data()
    return chat.last_message === 'hi' && (await acct('u1').get()).data().messages_count === 1
  })

  await db.doc('events/e1').set({ event_status: 'upcoming', attending: ['u1'], created_by: 'u2', event_name: 'Party', event_flyer_url: 'https://example.com/x.png?a=1' })
  await db.doc('events/e1').update({ event_status: 'live' })
  await waitFor('onEventStatusChanged writes event_alert', async () =>
    !(await db.collection('accounts/u1/notifications').where('notification_type', '==', 'event_alert').get()).empty)

  await db.doc('events/e1/topics/t1/messages/p1').set({ text: 'yo' })
  await waitFor('updateTopicPostCount counts posts', async () =>
    (await db.doc('events/e1/topics/t1').get()).data().number_of_posts === 1 &&
    (await db.doc('events/e1').get()).data().has_new_posts === true)

  await db.doc('chats/c1').delete()
  await waitFor('onChatDelete clears messages', async () => (await db.collection('chats/c1/messages').get()).empty)

  await db.doc('events/e1').delete()
  await waitFor('onEventDelete clears topics', async () => (await db.collection('events/e1/topics').get()).empty)

  await db.doc('events/e2').set({ event_status: 'upcoming', attending: ['u1'], interested: ['u1'], invited: [] })
  await acct('u1').delete()
  await waitFor('onAccountDelete clears notifications and event arrays', async () => {
    const e2 = (await db.doc('events/e2').get()).data()
    return (await db.collection('accounts/u1/notifications').get()).empty && e2.attending.length === 0 && e2.interested.length === 0
  })

  await db.doc('events/e3').set({ attending: ['u5'] })
  let r = await call('sendNotificationToEventAttendees', { eventId: 'e3', notification: { notification_type: 'event_created', notification_data: { username: 'x' } } })
  assert.equal(r.status, 200)
  assert.equal((await db.collection('accounts/u5/notifications').get()).size, 1)
  console.log('PASS sendNotificationToEventAttendees')

  await admin.auth().createUser({ uid: 'auth1', email: 'a@example.com' })
  r = await call('updateUser', { uid: 'auth1', info: { displayName: 'New Name' } })
  assert.equal(r.status, 200)
  assert.equal((await admin.auth().getUser('auth1')).displayName, 'New Name')
  console.log('PASS updateUser')

  r = await call('updateGroupOfUsers', { users: [{ uid: 'missing', displayName: 'x' }, { uid: 'auth1', displayName: 'Group Name' }] })
  assert.equal(r.status, 200)
  assert.equal((await admin.auth().getUser('auth1')).displayName, 'Group Name')
  console.log('PASS updateGroupOfUsers continues past a bad user')

  r = await call('getUser', { uid: 'auth1' })
  assert.equal(r.body.result.email, 'a@example.com')
  r = await call('listAllUsers', {})
  assert.equal(r.body.result.count, 1)
  console.log('PASS getUser and listAllUsers')

  r = await call('deleteUser', { uid: 'auth1' })
  assert.equal(r.status, 200)
  r = await call('getUser', { uid: 'auth1' })
  assert.equal(r.body.result.uid, null)
  console.log('PASS deleteUser')

  r = await call('updateUser', { uid: 'nope', info: { displayName: 'x' } })
  assert.equal(r.status, 500)
  console.log('PASS updateUser now reports errors')

  console.log('ALL PASSED')
}

main().then(() => process.exit(0), (e) => { console.error(e); process.exit(1) })
