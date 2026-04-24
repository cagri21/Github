#!/bin/sh

if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin:${PATH}"
fi
export PATH

if which swiftgen >/dev/null; then
  swiftgen config run --config "$SRCROOT/swiftgen.yml"
else
  echo "warning: SwiftGen not installed, download it from https://github.com/SwiftGen/SwiftGen"
fi
