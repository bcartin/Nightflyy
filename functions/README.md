# Cloud Functions

Firebase Cloud Functions for Nightflyy (TypeScript, Node 24, 1st-gen `firebase-functions/v1` API).
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

## Build and deploy

Run these from the repo root:

```bash
npm --prefix functions run build      # compile src/ to lib/
firebase deploy --only functions -P dev
firebase deploy --only functions -P prod
```

`firebase deploy` also runs the build first (the `predeploy` step in `firebase.json`).

## Notes

- Firestore field names (`notification_type`, `event_flyer_url`, `profile_image_url`, and so on) are shared with the iOS app. Rename them only together with the app.
- `getPathStorageFromUrl` hard-codes the prod storage bucket (`slydeapp-dc745.appspot.com`), so image cleanup on delete only works in prod.
