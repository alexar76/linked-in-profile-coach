#!/usr/bin/env bash
# Build Flutter web demo for GitHub Pages (project site subpath).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BASE_HREF="${BASE_HREF:-/linked-in-profile-coach/}"
# Must match transitive `sqlite3` in pubspec.lock (3.x wasm ≠ 2.4.6 from default setup).
SQLITE3_WASM_URL="${SQLITE3_WASM_URL:-https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.3.1/sqlite3.wasm}"

flutter pub get
dart run sqflite_common_ffi_web:setup
# setup ignores --sqlite3-wasm-url (package bug); fetch 3.x wasm matching pubspec.lock.
curl -fsSL "$SQLITE3_WASM_URL" -o web/sqlite3.wasm
flutter build web --release --base-href "$BASE_HREF"

cp -f web/sqlite3.wasm web/sqflite_sw.js build/web/
touch build/web/.nojekyll

echo "OK build/web ready ($(du -sh build/web | awk '{print $1}'))"
