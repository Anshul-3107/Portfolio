#!/bin/bash
set -e

# If Flutter is not present in CI environment, download stable SDK
if ! command -v flutter &> /dev/null; then
  echo "=== Installing Flutter SDK on Vercel Build Container ==="
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable /tmp/flutter
  export PATH="$PATH:/tmp/flutter/bin"
fi

echo "=== Flutter Environment ==="
flutter --version

echo "=== Building Flutter Web Release ==="
flutter config --no-analytics
flutter pub get

if [ -n "$BACKEND_BASE_URL" ]; then
  echo "Injecting BACKEND_BASE_URL: $BACKEND_BASE_URL"
  flutter build web --release --dart-define=BACKEND_BASE_URL="$BACKEND_BASE_URL"
else
  flutter build web --release
fi

echo "=== Build Complete! Output at build/web ==="
