#!/bin/sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PROJECT_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"

if test -d "/opt/homebrew/bin/"; then
  PATH="/opt/homebrew/bin:${PATH}"
fi
export PATH

if which xcodegen >/dev/null; then
  xcodegen generate --spec "${PROJECT_ROOT}/project.yml"
else
  echo "warning: XcodeGen not installed, install it with Homebrew or Mint."
fi
