#!/usr/bin/env bash
# Package local release artifacts (same names as CI).
# Usage: ./tool/package_release.sh v1.0.0

set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
  VERSION="v$(grep '^version:' pubspec.yaml | sed 's/version: //;s/+.*//')"
fi
[[ "$VERSION" == v* ]] || VERSION="v${VERSION}"

PREFIX="ProfileCoach"
OUT_DIR="build/release"
mkdir -p "$OUT_DIR"

flutter pub get

case "$(uname -s)" in
  Darwin)
    flutter build macos --release
    ditto -c -k --keepParent \
      "build/macos/Build/Products/Release/linkedin_profile_coach.app" \
      "$OUT_DIR/${PREFIX}-${VERSION}-macos.zip"
    echo "Wrote $OUT_DIR/${PREFIX}-${VERSION}-macos.zip"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    flutter build windows --release
    powershell -Command "Compress-Archive -Path 'build/windows/x64/runner/Release/*' -DestinationPath '$OUT_DIR/${PREFIX}-${VERSION}-windows-x64.zip' -Force"
    echo "Wrote $OUT_DIR/${PREFIX}-${VERSION}-windows-x64.zip"
    ;;
  Linux)
    flutter build apk --release
    cp "build/app/outputs/flutter-apk/app-release.apk" \
      "$OUT_DIR/${PREFIX}-${VERSION}-android-universal.apk"
    echo "Wrote $OUT_DIR/${PREFIX}-${VERSION}-android-universal.apk"
    ;;
esac

echo "Other platforms: push tag v* to trigger .github/workflows/release.yml"
