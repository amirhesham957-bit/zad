#!/bin/bash

# Clone Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable flutter
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Pre-download artifacts
flutter doctor

# Run build
flutter build web --release

# Note: Vercel expects the build output in a specific directory.
# By default, Flutter builds to build/web.
# We will point Vercel to this directory in vercel.json or here.
