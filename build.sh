#!/bin/bash
set -e

# Clone Flutter if not present
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 flutter
fi

export PATH="$PATH:`pwd`/flutter/bin"

# Setup
flutter precache --web
flutter pub get

# Build for web (no shaders, no web-renderer flag)
flutter build web --release
