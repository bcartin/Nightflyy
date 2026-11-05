# Cloud Functions

Firebase Cloud Functions for Nightflyy (TypeScript, Node 24, 2nd-gen `firebase-functions/v2` API).
Moved here from the old Slyde repo. `firebase.json` and `.firebaserc` live at the repo root.

## Projects

| Alias | Project ID | Used by |
|-------|------------|---------|
| `default` / `prod` | `slydeapp-dc745` | Release build (`GoogleService-Info-Release.plist`) |
| `dev` | `nightflyydev` | Debug build (`GoogleService-Info-Debug.plist`) |

`default` points at production, so a plain `firebase deploy` deploys to prod.

## Setup

```bash
npm install -g firebase-tools
firebase login
cd functions && npm ci
```

No secrets or runtime config are needed. The functions use the project's default service account,
and deploy uses your `firebase login` credentials. Do not commit service-account JSON, `.env` or `.runtimeconfig.json`.

## Test

`npm test` builds the functions and runs `test/emulator-check.cjs` against the local Auth, Firestore and Functions
emulators on a `demo-` project, so nothing real is touched. The Firestore emulator needs Java 21 or newer. If your
default `java` is older, point `JAVA_HOME` at a newer JDK (Android Studio ships one):

```bash
JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" npm test
```

## Build and deploy

Both projects run functions that aren't in this repo (`api` in prod, Stripe functions in dev).
A plain `firebase deploy --only functions` offers to delete those, so deploy these functions by name:

```bash
FNS=$(node -p "Object.keys(require('./functions/lib/index.js')).map(f => 'functions:' + f).join(',')")
firebase deploy --only "$FNS" -P dev
```

Run that from the repo root after `npm --prefix functions run build`. `firebase deploy` also runs the build first
(the `predeploy` step in `firebase.json`).

## Callable auth

Every callable needs a signed-in caller. `updateUser` and `deleteUser` let users act on their own uid
(`updateUser` only changes `displayName` and `photoURL`). Everything else, and acting on another uid,
needs the `admin: true` custom claim, which the NightflyyAdmin account must have.

Set the claim once per project **before** deploying these functions there, or the admin app gets `permission-denied`.
It uses your Application Default Credentials (`gcloud auth application-default login`):

```bash
cd functions
node -e "const a=require('firebase-admin');a.initializeApp({projectId:process.argv[1]});a.auth().getUserByEmail(process.argv[2]).then(u=>a.auth().setCustomUserClaims(u.uid,{...u.customClaims,admin:true})).then(()=>console.log('done'))" nightflyydev ADMIN_EMAIL
```

Repeat with `slydeapp-dc745` for prod. The claim shows up on the next sign-in, and the admin app signs in on every launch, so relaunch it.

## Moving prod from 1st gen to 2nd gen (one time)

Firebase can't upgrade a 1st-gen function to 2nd gen in place under the same name, and the app calls
`updateUser` and `deleteUser` by name. So the cutover deletes the 1st-gen functions and then deploys the 2nd-gen ones:

```bash
npm --prefix functions run build
FNS=$(node -p "Object.keys(require('./functions/lib/index.js')).join(' ')")
firebase functions:delete $FNS --region us-central1 -P prod --force
firebase deploy --only "$(for f in $FNS; do printf 'functions:%s,' $f; done | sed 's/,$//')" -P prod
```

Between the delete and the end of the deploy (a few minutes), Firestore events aren't handled: no push
notifications, counters or cleanup for changes made in that window, and the app's callable requests fail.
Do it at a quiet time. To roll back, delete the 2nd-gen functions and redeploy the 1st-gen code from git.

Dev has never had these functions, so a normal by-name deploy works there and is the place to try 2nd gen first.

## Notes

- Firestore field names (`notification_type`, `event_flyer_url`, `profile_image_url`, and so on) are shared with the iOS app. Rename them only together with the app.
- `getPathStorageFromUrl` hard-codes the prod storage bucket (`slydeapp-dc745.appspot.com`), so image cleanup on delete only works in prod.
- 2nd gen throttles CPU after a handler returns, so every Firestore, Auth and FCM call is awaited.
- `Timestamp` and `FieldValue` come from `firebase-admin/firestore`. Under the Functions emulator, `admin.firestore.Timestamp` is undefined.
