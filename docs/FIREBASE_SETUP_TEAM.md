# Firebase Setup for Team Members

After cloning the Pavura repository, each team member must generate `lib/firebase_options.dart` locally. This file contains sensitive API keys and is **not committed to git**.

## Prerequisites

Ensure you have the required tools installed:

```bash
# 1. Install Firebase CLI globally
npm install -g firebase-tools

# 2. Activate FlutterFire CLI
flutter pub global activate flutterfire_cli

# 3. Add FlutterFire to PATH (Windows)
# Already included if Flutter is in PATH

# 4. Verify installation
flutterfire --version
firebase --version
```

## Setup Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/pavithiranr/pavura.git
cd pavura
```

You'll notice `lib/firebase_options.dart` is **missing** - this is expected (it's in .gitignore).

### Step 2: Generate Firebase Configuration

Run the FlutterFire CLI:

```bash
flutterfire configure
```

### Step 3: Follow the Prompts

1. **Login to Firebase** (if not already logged in)
   ```
   Prompt: You have not authenticated with Firebase yet. Do you want to authenticate now?
   Answer: yes
   ```

2. **Select Project**
   ```
   Prompt: Which Firebase project should you configure?
   Select: pavura
   ```

3. **Choose Platforms**
   ```
   Prompt: Which platforms should your configuration support?
   Select: android, ios, macos, web, windows (use space to select all)
   ```

4. **Confirm File Generation**
   ```
   Prompt: Generated FirebaseOptions file ... already exists, override?
   Answer: yes
   ```

### Step 4: Verify Setup

Check that the file was created:

```bash
# On Windows:
dir lib\firebase_options.dart

# On macOS/Linux:
ls lib/firebase_options.dart
```

You should see output like:
```
C:\Users\YourName\pavura\lib\firebase_options.dart
```

### Step 5: Verify Git Status

The file should **not** be tracked by git:

```bash
git status | grep firebase_options
# Should show nothing (file is in .gitignore)
```

## Running the App

Once configured, you can run the app normally:

```bash
# Run on device/emulator
flutter run

# Run on web
flutter run -d chrome

# Run on iOS
flutter run -d ios

# Run on Android
flutter run -d android
```

## Troubleshooting

### Issue: "FlutterFire not found"

**Solution:** Activate FlutterFire CLI:
```bash
flutter pub global activate flutterfire_cli
```

### Issue: "Firebase CLI not authenticated"

**Solution:** Login to Firebase:
```bash
firebase login
```

### Issue: "ProjectId or FirebaseOptions not found"

**Solution:** Ensure you selected the correct project (pavura) in the FlutterFire prompt.

### Issue: "Platform not configured in project"

**Solution:** That platform isn't available in this Firebase project. Skip it and proceed.

## Important Notes

⚠️ **DO NOT:**
- ❌ Commit `lib/firebase_options.dart`
- ❌ Share your local `lib/firebase_options.dart` file
- ❌ Upload it to any public repository
- ❌ Modify the file manually (regenerate with flutterfire configure)

✅ **DO:**
- ✅ Run `flutterfire configure` locally
- ✅ Keep the file on your machine only
- ✅ Regenerate if you change Firebase project settings
- ✅ Report security issues if you see credentials in git

## Support

If you encounter issues:

1. Check [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview/)
2. See [Firebase Console](https://console.firebase.google.com) to verify project setup
3. Check `.gitignore` to ensure `lib/firebase_options.dart` is protected
4. Contact the team lead if you need Firebase project access
