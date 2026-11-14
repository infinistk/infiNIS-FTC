#!/usr/bin/env bash
set -euo pipefail

export ANDROID_HOME="$HOME/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

mkdir -p "$ANDROID_HOME/cmdline-tools/latest"

# curl и unzip уже доступны в базовом devcontainer
command -v curl >/dev/null || {
  echo "ERROR: curl is missing"
  exit 1
}

command -v unzip >/dev/null || {
  echo "ERROR: unzip is missing"
  exit 1
}

if [ ! -f "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
  curl -fL \
    "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
    -o /tmp/android-tools.zip

  mkdir -p /tmp/android-cmdline
  unzip -q /tmp/android-tools.zip -d /tmp/android-cmdline
  mv /tmp/android-cmdline/cmdline-tools/* \
    "$ANDROID_HOME/cmdline-tools/latest/"
fi

set +o pipefail
yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses >/dev/null
set -o pipefail

sdkmanager --sdk_root="$ANDROID_HOME" \
  "platform-tools" \
  "platforms;android-30" \
  "build-tools;30.0.3" \
  "build-tools;35.0.0" \
  "ndk;21.3.6528147"

echo "Android SDK installed successfully!"
