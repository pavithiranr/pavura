# Firebase Security Configuration Guide

## ✅ Completed: Removed Exposed Credentials from Git

Your Firebase API keys have been successfully removed from git history:
- ✅ Deleted `lib/firebase_options.dart` from repository
- ✅ Updated `.gitignore` to prevent future commits
- ✅ Pushed changes to GitHub

## ⚠️ CRITICAL NEXT STEP: Rotate Firebase API Keys

The old credentials are still active in your Firebase project. You must delete and regenerate them:

### Step 1: Delete Old Firebase Apps (in Firebase Console)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select the **"pavura"** project
3. Click **⚙️ Project Settings** (gear icon)
4. Go to **Your apps** tab
5. Delete these apps one by one:
   - ❌ Web app `pavura` (ID: 1:912472454203:web:908170041c2ac31904d81e)
   - ❌ Android app `com.example.passenger_transportation_tracker` 
   - ❌ iOS app `com.example.passengerTransportationTracker`
   - ❌ macOS app
   - ❌ Windows app

**⚠️ After deletion, all old API keys will be invalidated automatically**

### Step 2: Regenerate Firebase Configuration with New Apps

```bash
cd c:\Users\Pavithiran Ramesh\Documents\Pavura\pavura
rm firebase.json
flutterfire configure
```

During the prompt:
- Select `pavura` project
- Choose all platforms: `android, ios, macos, web, windows`
- Confirm override when asked

This will create **NEW Firebase apps** with **NEW API keys** that are safe to use.

### Step 3: Verify Protected Configuration

```bash
# Check that firebase_options.dart is protected
git status lib/firebase_options.dart
# Output: "lib/firebase_options.dart" will not be committed

# Verify the file exists locally
ls lib/firebase_options.dart
# Output: lib/firebase_options.dart
```

### Step 4: Commit firebase.json

The `firebase.json` file is safe to commit (it only contains app IDs, not secrets):

```bash
git add firebase.json
git commit -m "Security: Regenerate firebase.json with new apps"
git push
```

## 📁 File Protection Status

| File | Status | Notes |
|------|--------|-------|
| `lib/firebase_options.dart` | 🔒 Protected | Contains API keys - in .gitignore |
| `firebase.json` | ✅ Safe | Contains only app IDs - OK to commit |
| `android/app/google-services.json` | 🔒 Protected | In .gitignore |
| `ios/GoogleService-Info.plist` | 🔒 Protected | In .gitignore |

## Team Setup Instructions

Create a file `docs/FIREBASE_SETUP_TEAM.md` for your team:

```markdown
# Firebase Setup for Team Members

After cloning the repo, you must regenerate `lib/firebase_options.dart` locally:

1. Ensure you have Firebase CLI installed:
   ```bash
   npm install -g firebase-tools
   flutter pub global activate flutterfire_cli
   ```

2. Run FlutterFire configuration:
   ```bash
   flutterfire configure
   ```

3. Select the `pavura` project and your platforms

4. The file `lib/firebase_options.dart` will be generated locally (not committed)

5. You can now run the app normally:
   ```bash
   flutter run
   ```

Never commit `lib/firebase_options.dart` or Firebase credential files!
```

## Security Checklist

- [ ] Old Firebase apps deleted from Firebase Console
- [ ] `flutterfire configure` executed (generates new apps + new API keys)
- [ ] `lib/firebase_options.dart` generated locally with new keys
- [ ] `.gitignore` contains `lib/firebase_options.dart`
- [ ] `firebase.json` committed to git
- [ ] All team members have run `flutterfire configure`
- [ ] No credentials in any committed files

## Verification Commands

```bash
# View what's in .gitignore for Firebase
grep -i firebase .gitignore

# Verify file won't be committed
git check-ignore lib/firebase_options.dart && echo "✓ Protected" || echo "✗ Not protected"

# Check git status before commit
git status --short | grep firebase_options.dart
# Should show nothing (file is ignored)
```

---

**Timeline:**
1. ✅ Removed old credentials from git history
2. ⏳ **NOW**: Delete old Firebase apps in console
3. ⏳ Regenerate with new apps
4. ✅ Protect with .gitignore

