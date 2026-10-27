#!/bin/sh
# POSIX shell wrapper script to execute baseline image build and log output
# Master Plan Sections: 2.2, 2.4, 2.5

set -eu

DRY_RUN=0
WORK_DIR=""
CONFIG_FILE="build/configs/development.md"
BUILD_CMD="m"
STUB_FAIL_TEST=0

usage() {
    cat << EOF
Usage: $0 --work-dir <PATH> [OPTIONS]

Options:
  --work-dir <PATH>      Path to the working directory.
  --config <PATH>        Path to build configuration specification (default: build/configs/development.md).
  --build-cmd <CMD>      Build command to execute (default: 'm').
  --stub-fail-test       Run a harmless test stub simulating a build failure (for tooling verification).
  --dry-run              Print commands without executing them.
  --help                 Display this help message and exit.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --work-dir)
            WORK_DIR="$2"
            shift 2
            ;;
        --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --build-cmd)
            BUILD_CMD="$2"
            shift 2
            ;;
        --stub-fail-test)
            STUB_FAIL_TEST=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown argument '$1'" >&2
            usage
            exit 1
            ;;
    esac
done

if [ -z "$WORK_DIR" ]; then
    echo "Error: --work-dir is required." >&2
    usage
    exit 1
fi

# Safety check on WORK_DIR
mkdir -p "$WORK_DIR"
REAL_WORK_DIR=$(cd "$WORK_DIR" && pwd)
HOME_DIR=$(cd "$HOME" 2>/dev/null && pwd)

if [ "$REAL_WORK_DIR" = "/" ] || [ "$REAL_WORK_DIR" = "$HOME_DIR" ] || [ -z "$REAL_WORK_DIR" ]; then
    echo "Error: Dangerous WORK_DIR '$REAL_WORK_DIR'. WORK_DIR cannot be '/', empty, or home directory." >&2
    exit 1
fi

SRC_DIR="$REAL_WORK_DIR/src"
OUT_DIR="$REAL_WORK_DIR/out"
LOG_DIR="$REAL_WORK_DIR/logs"
RECORD_DIR="$REAL_WORK_DIR/records"
TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
LOG_FILE="$LOG_DIR/build-$TIMESTAMP.log"
RECORD_FILE="$RECORD_DIR/build-record-$TIMESTAMP.md"
REPO_ROOT=$(pwd)

echo "=== DeeX Baseline Image Build Wrapper ==="
echo "Work Directory: $REAL_WORK_DIR"
echo "Build Configuration: $CONFIG_FILE"

if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY-RUN] Environment Variables:"
    echo "  export OUT_DIR=$OUT_DIR"
    echo "  export TARGET_PRODUCT=aosp_shiba"
    echo "  export TARGET_BUILD_VARIANT=userdebug"
    echo "[DRY-RUN] Would execute inside $SRC_DIR:"
    echo "  source build/envsetup.sh"
    echo "  lunch aosp_shiba-userdebug"
    echo "  $BUILD_CMD"
    echo "[DRY-RUN] Expecting output artifacts in: $OUT_DIR/target/product/shiba/"
    echo "  boot.img, system.img, vendor.img, product.img, system_ext.img, vbmeta.img, super.img"
    echo "[DRY-RUN] Would write build record to $RECORD_FILE"
    echo "[DRY-RUN] Build dry-run completed successfully."
    exit 0
fi

mkdir -p "$LOG_DIR" "$RECORD_DIR"

# Initialize Log
{
    echo "=== DeeX Baseline Build Execution Log ==="
    echo "Start UTC Time: $(date -u)"
    echo "Work Directory: $REAL_WORK_DIR"
    echo "Configuration File: $CONFIG_FILE"
    echo "----------------------------------------"
} > "$LOG_FILE"

BUILD_EXIT_CODE=0

if [ "$STUB_FAIL_TEST" -eq 1 ]; then
    echo "Running failure simulation stub test..." | tee -a "$LOG_FILE"
    BUILD_EXIT_CODE=42
    echo "Simulated build error occurred (stub exit code 42)." >> "$LOG_FILE"
else
    if [ ! -f "$SRC_DIR/build/envsetup.sh" ]; then
        echo "Error: AOSP source tree not found at $SRC_DIR (missing build/envsetup.sh). Run tools/baseline-sync.sh first." | tee -a "$LOG_FILE"
        BUILD_EXIT_CODE=1
    else
        echo "Executing build sequence in $SRC_DIR..." | tee -a "$LOG_FILE"
        (
            cd "$SRC_DIR"
            export OUT_DIR="$OUT_DIR"
            . build/envsetup.sh
            lunch aosp_shiba-userdebug
            $BUILD_CMD
        ) >> "$LOG_FILE" 2>&1 || BUILD_EXIT_CODE=$?
    fi
fi

# Verify artifact existence
EXPECTED_ARTIFACTS="boot.img system.img vendor.img product.img system_ext.img vbmeta.img super.img"
PRODUCT_OUT="$OUT_DIR/target/product/shiba"
MISSING_ARTIFACTS=0

if [ "$BUILD_EXIT_CODE" -eq 0 ]; then
    for artifact in $EXPECTED_ARTIFACTS; do
        if [ ! -f "$PRODUCT_OUT/$artifact" ]; then
            echo "Error: Expected output artifact '$artifact' is missing from $PRODUCT_OUT." | tee -a "$LOG_FILE"
            MISSING_ARTIFACTS=$((MISSING_ARTIFACTS + 1))
        fi
    done
else
    MISSING_ARTIFACTS=1
fi

# Generate Build Record
if [ "$BUILD_EXIT_CODE" -eq 0 ] && [ "$MISSING_ARTIFACTS" -eq 0 ]; then
    RESULT_STATUS="SUCCESS"
else
    RESULT_STATUS="FAILURE"
fi

echo "Build finished with exit code $BUILD_EXIT_CODE. Result: $RESULT_STATUS" | tee -a "$LOG_FILE"

"$REPO_ROOT/tools/make-build-record.sh" \
    --work-dir "$REAL_WORK_DIR" \
    --result "$RESULT_STATUS" \
    --record-file "$RECORD_FILE" \
    --log-file "$LOG_FILE" \
    --exit-code "$BUILD_EXIT_CODE"

if [ "$RESULT_STATUS" = "SUCCESS" ]; then
    echo "=== Build Succeeded! Record saved to $RECORD_FILE ==="
    exit 0
else
    echo "=== Build Failed! Failure record saved to $RECORD_FILE ===" >&2
    exit "$BUILD_EXIT_CODE"
fi
