@echo off
setlocal
cd /d "%~dp0"
where flutter >nul 2>nul || (echo Install Flutter and add it to PATH. & exit /b 1)
call flutter pub get || exit /b 1
call flutter analyze --no-fatal-infos || exit /b 1
call flutter test || exit /b 1
if "%~1"=="--apk" (call flutter build apk --debug || exit /b 1)
