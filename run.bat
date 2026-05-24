@echo off
cd /d "%~dp0"

where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter не найден. Установите: https://docs.flutter.dev/get-started/install
  exit /b 1
)

call flutter pub get
call flutter run -d windows
