#!/bin/sh
# POSIX shell wrapper script to initialize and sync pinned AOSP source tree
# Master Plan Sections: 2.2, 2.4

set -eu

SHOW_HELP=0
DRY_RUN=0
WORK_DIR=""

usage() {
    cat << EOF
Usage: $0 --work-dir <PATH> [OPTIONS]

Options:
  --work-dir <PATH>   Path to the working directory (must not be empty, '/', or home directory).
  --dry-run           Print commands without executing them.
  --help              Display this help message and exit.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --work-dir)
            WORK_DIR="$2"
            shift 2
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

PINNED_MANIFEST="build/manifests/aosp-pinned.xml"
REPO_ROOT=$(pwd)

echo "=== DeeX Baseline Source Sync Tool ==="
echo "Work Directory: $REAL_WORK_DIR"
echo "Manifest File: $PINNED_MANIFEST"

# Verify pinned manifest existence and validity before attempting sync
if [ ! -f "$PINNED_MANIFEST" ]; then
    echo "Error: Pinned manifest file '$PINNED_MANIFEST' does not exist." >&2
    exit 1
fi

if grep -q "UNRESOLVED" "$PINNED_MANIFEST" || grep -q "UNKNOWN" "$PINNED_MANIFEST"; then
    echo "Error: Manifest '$PINNED_MANIFEST' contains UNRESOLVED or UNKNOWN markers. Cannot sync from uninstantiated template." >&2
    exit 1
fi

SRC_DIR="$REAL_WORK_DIR/src"
LOG_DIR="$REAL_WORK_DIR/logs"
TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
LOG_FILE="$LOG_DIR/sync-$TIMESTAMP.log"

if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY-RUN] Would create directory structure: $SRC_DIR, $LOG_DIR"
    echo "[DRY-RUN] Would execute inside $SRC_DIR:"
    echo "  repo init -u https://android.googlesource.com/platform/manifest -b refs/tags/android-15.0.0_r1 --manifest-name=aosp-pinned.xml"
    echo "  cp $REPO_ROOT/$PINNED_MANIFEST $SRC_DIR/.repo/manifests/aosp-pinned.xml"
    echo "  repo sync -c -j\$(nproc)"
    echo "[DRY-RUN] Would log output to $LOG_FILE"
    echo "[DRY-RUN] Sync dry-run completed successfully."
    exit 0
fi

mkdir -p "$SRC_DIR" "$LOG_DIR"

echo "Starting AOSP source sync at $(date -u)... Logging to $LOG_FILE"

# Log start time
{
    echo "=== DeeX Baseline Sync Log ==="
    echo "Start Time: $(date -u)"
    echo "Pinned Manifest: $PINNED_MANIFEST"
    echo "Source Path: $SRC_DIR"
    echo "----------------------------------------"
} > "$LOG_FILE"

cd "$SRC_DIR"

# Execute repo init
repo init -u https://android.googlesource.com/platform/manifest -b refs/tags/android-15.0.0_r1 --manifest-name=aosp-pinned.xml >> "$LOG_FILE" 2>&1 || {
    echo "Error: repo init failed. See $LOG_FILE for details." >&2
    exit 1
}

mkdir -p "$SRC_DIR/.repo/manifests"
cp "$REPO_ROOT/$PINNED_MANIFEST" "$SRC_DIR/.repo/manifests/aosp-pinned.xml"

# Execute repo sync
repo sync -c -j"$(nproc 2>/dev/null || echo 4)" >> "$LOG_FILE" 2>&1 || {
    echo "Error: repo sync failed. See $LOG_FILE for details." >&2
    exit 1
}

# Verify synced revisions match pins
echo "Verifying synced repository revisions against $PINNED_MANIFEST..."
"$REPO_ROOT/tools/verify-manifest-pins.sh" >> "$LOG_FILE" 2>&1 || {
    echo "Error: Synced repositories fail manifest pin verification. See $LOG_FILE for details." >&2
    exit 1
}

echo "=== Sync Completed Successfully at $(date -u) ===" | tee -a "$LOG_FILE"
