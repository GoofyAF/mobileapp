#!/usr/bin/env bash
# Build the Android APK for Obtainium ingestion
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Build using the Nix shell environment
NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE=1 \
nix-shell shell.nix --run '
  ANDROID_HOME_DIR="$ANDROID_HOME"
  cd "'"$SCRIPT_DIR"'"
  ./gradlew :androidApp:assembleRelease --no-daemon \
    -Pandroid.aapt2FromMavenOverride="$ANDROID_HOME_DIR/build-tools/36.0.0/aapt2" \
    -x :androidApp:uploadCrashlyticsMappingFileRelease
'

echo ""
echo "=== Build complete! ==="
echo "APK: androidApp/build/outputs/apk/release/*.apk"
ls -la androidApp/build/outputs/apk/release/*.apk
