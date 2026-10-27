#!/bin/sh
# POSIX shell script to verify owner-provided vendor binary archives
# Master Plan Sections: 2.2, 5.2, 16.2

set -eu

VENDOR_DIR=""
EXPECTED_SHA256=""

usage() {
    cat << EOF
Usage: $0 --vendor-dir <PATH> [OPTIONS]

Options:
  --vendor-dir <PATH>      Directory containing downloaded vendor binary archives (.tgz / .sh).
  --expected-sha256 <HASH> Optional expected SHA-256 hash to verify.
  --help                   Display this help message and exit.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --vendor-dir)
            VENDOR_DIR="$2"
            shift 2
            ;;
        --expected-sha256)
            EXPECTED_SHA256="$2"
            shift 2
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

if [ -z "$VENDOR_DIR" ]; then
    echo "Error: --vendor-dir is required." >&2
    usage
    exit 1
fi

if [ ! -d "$VENDOR_DIR" ]; then
    echo "Error: Vendor directory '$VENDOR_DIR' does not exist." >&2
    exit 1
fi

echo "=== DeeX Vendor Binaries Verification Tool ==="
echo "Vendor Directory: $VENDOR_DIR"

ARCHIVES=$(find "$VENDOR_DIR" -maxdepth 2 -type f \( -name "*.tgz" -o -name "extract-*.sh" \))

if [ -z "$ARCHIVES" ]; then
    echo "Error: No vendor binary archives (.tgz or extract-*.sh) found in $VENDOR_DIR." >&2
    exit 1
fi

ERRORS=0

echo "Found vendor binary archives:"
for archive in $ARCHIVES; do
    actual_hash=$(sha256sum "$archive" | awk '{print $1}')
    echo "  - File: $(basename "$archive")"
    echo "    SHA-256: $actual_hash"

    if [ -n "$EXPECTED_SHA256" ]; then
        if [ "$actual_hash" = "$EXPECTED_SHA256" ]; then
            echo "    [MATCH] Matches expected SHA-256 hash."
        else
            echo "    [FAIL] Hash mismatch! Expected: $EXPECTED_SHA256"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

if [ "$ERRORS" -gt 0 ]; then
    echo "=== Vendor Binary Verification: FAILED ($ERRORS error(s)) ==="
    exit 1
else
    echo "=== Vendor Binary Verification: PASSED ==="
    exit 0
fi
