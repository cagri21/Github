#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/Github.xcodeproj"
TIMESTAMP="$(date +%Y-%m-%d_%H%M%S)"
BUILD_ROOT="$ROOT_DIR/build/$TIMESTAMP"

TARGET_ENVIRONMENT="${1:-all}"

usage() {
    cat <<EOF
Usage: ./scripts/build_git.sh [dev|qa|prod|all]

  dev   Build the GitDev scheme
  qa    Build the GitQA scheme
  prod  Build the GitProd scheme
  all   Build all three schemes (default)
EOF
}

scheme_for_environment() {
    case "$1" in
    dev) echo "GitDev" ;;
    qa) echo "GitQA" ;;
    prod) echo "GitProd" ;;
    *)
        echo "Unsupported environment: $1" >&2
        return 1
        ;;
    esac
}

build_scheme() {
    local environment="$1"
    local scheme="$2"
    local output_dir="$BUILD_ROOT/$scheme"
    local derived_data_path="$output_dir/DerivedData"
    local log_path="$output_dir/build.log"
    local app_path="$derived_data_path/Build/Products/${scheme}-iphoneos/Github.app"

    mkdir -p "$output_dir"

    echo ""
    echo "============================================"
    echo " Building: $scheme"
    echo " Environment: $environment"
    echo " Output: $output_dir"
    echo "============================================"

    xcodebuild \
        -project "$PROJECT_PATH" \
        -scheme "$scheme" \
        -destination "generic/platform=iOS" \
        -derivedDataPath "$derived_data_path" \
        CODE_SIGNING_ALLOWED=NO \
        build | tee "$log_path"

    echo ""
    echo "✓ $scheme build complete"
    echo "  Log: $log_path"

    if [[ -d "$app_path" ]]; then
        echo "  App: $app_path"
    else
        echo "  App: not found"
    fi
}

case "$TARGET_ENVIRONMENT" in
dev|qa|prod)
    build_scheme "$TARGET_ENVIRONMENT" "$(scheme_for_environment "$TARGET_ENVIRONMENT")"
    ;;
all)
    build_scheme "dev" "$(scheme_for_environment "dev")"
    build_scheme "qa" "$(scheme_for_environment "qa")"
    build_scheme "prod" "$(scheme_for_environment "prod")"
    ;;
*)
    usage
    exit 1
    ;;
esac

echo ""
echo "Build output root: $BUILD_ROOT"
