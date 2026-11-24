#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
command -v flutter >/dev/null || { echo 'Install Flutter and add it to PATH.'; exit 1; }
chmod +x android/gradlew
flutter pub get
flutter analyze --no-fatal-infos
flutter test
if [[ ${1:-} == --apk ]]; then flutter build apk --debug; fi
