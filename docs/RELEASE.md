# Releases

Profile Coach ships as **desktop and Android binaries**. Source code lives in this repo; installable files are attached to [GitHub Releases](https://github.com/alexar76/linked-in-profile-coach/releases).

iOS is **not** distributed via GitHub — only App Store / TestFlight.

## Download naming

| File | Platform |
|------|----------|
| `ProfileCoach-v1.0.0-macos.zip` | macOS (Apple Silicon CI runner; unzip → `linkedin_profile_coach.app`) |
| `ProfileCoach-v1.0.0-windows-x64.zip` | Windows 64-bit |
| `ProfileCoach-v1.0.0-linux-x64.zip` | Linux 64-bit |
| `ProfileCoach-v1.0.0-android-universal.apk` | Android (sideload; Play Store uses AAB separately) |

**Web demo** (no install): [GitHub Pages](https://alexar76.github.io/linked-in-profile-coach/) — deployed from `main` on every push.

Version in the filename matches the git tag (e.g. tag `v1.0.0`).

## Cut a release (maintainers)

1. Bump version in `pubspec.yaml` (`version: 1.0.0+1` → name + build number).
2. Commit and push to `main`.
3. Create and push a tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

4. GitHub Actions workflow **Release** builds macOS, Windows, Linux, and Android, then creates a Release with assets.
5. Edit release notes on GitHub if needed (auto-generated notes are a starting point).

Manual run: **Actions → Release → Run workflow** (uses the current commit; tag the commit yourself for a proper versioned release).

## App icons

Before release builds, regenerate platform icons from the brand artwork:

```bash
python3 tool/generate_app_icons_pillow.py
```

This updates macOS `AppIcon.appiconset`, Windows `app_icon.ico`, and Android `mipmap-*`. Then run `flutter clean` and rebuild.

## Build locally

```bash
flutter pub get
```

### macOS

```bash
flutter build macos --release
open build/macos/Build/Products/Release/linkedin_profile_coach.app
```

Zip for distribution:

```bash
cd build/macos/Build/Products/Release
ditto -c -k --keepParent linkedin_profile_coach.app ProfileCoach-macos.zip
```

### Windows

```bash
flutter build windows --release
```

Zip `build\windows\x64\runner\Release\` and ship the archive.

### Linux

```bash
flutter build linux --release
# bundle: build/linux/x64/release/bundle/
```

Zip the bundle directory for distribution (CI produces `ProfileCoach-*-linux-x64.zip`).

### Android

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

CI builds use the **debug signing key** for APK until you configure release signing (see below).

## Android release signing (optional)

For production APK/AAB, add a keystore and GitHub secrets:

| Secret | Description |
|--------|-------------|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded `.jks` file |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password |
| `ANDROID_KEY_ALIAS` | Key alias |
| `ANDROID_KEY_PASSWORD` | Key password |

Then wire `signingConfigs` in `android/app/build.gradle.kts` (not enabled by default in this repo).

## macOS / Windows code signing (optional)

- **macOS**: Apple Developer ID + notarization for Gatekeeper.
- **Windows**: Authenticode certificate to reduce SmartScreen warnings.

Unsigned builds work for development; end users may need to allow the app in system security settings.

## What not to commit

Do **not** commit `build/`, `*.app`, `*.exe`, `*.apk`, or `*.zip` to git. Only source and workflow definitions.
