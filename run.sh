#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter не найден. Установите: https://docs.flutter.dev/get-started/install"
  exit 1
fi

flutter pub get

if [[ "$(uname -s)" == "Darwin" ]]; then
  flutter run -d macos
elif [[ "$(uname -s)" == "Linux" ]]; then
  flutter run -d linux
else
  echo "Для Windows запустите run.bat"
  exit 1
fi
