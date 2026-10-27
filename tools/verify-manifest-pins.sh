#!/bin/sh
# POSIX shell script to verify aosp-pinned.xml manifest project pins

set -e

PINNED_MANIFEST="build/manifests/aosp-pinned.xml"
TEMPLATE_MANIFEST="build/manifests/aosp-pinned.xml.template"

echo "=== DeeX Manifest Pin Verification Check ==="

ERRORS=0

# 1. Check if pinned manifest exists
if [ ! -f "$PINNED_MANIFEST" ]; then
    echo "[FAIL] Missing pinned manifest file: $PINNED_MANIFEST"
    if [ -f "$TEMPLATE_MANIFEST" ]; then
        echo "[INFO] Manifest template file exists ($TEMPLATE_MANIFEST), but aosp-pinned.xml has not been instantiated."
    fi
    ERRORS=$((ERRORS + 1))
    echo "=== Manifest Verification Result: FAILED ($ERRORS error(s)) ==="
    exit 1
fi

# 2. Check for UNRESOLVED or UNKNOWN markers in pinned manifest
if grep -q "UNRESOLVED" "$PINNED_MANIFEST" || grep -q "UNKNOWN" "$PINNED_MANIFEST"; then
    echo "[FAIL] Manifest $PINNED_MANIFEST contains UNRESOLVED or UNKNOWN markers."
    ERRORS=$((ERRORS + 1))
fi

# 3. Check for floating branch names or non-40-char SHA1 revisions
# Parse each <project ... revision="..." /> line
grep '<project ' "$PINNED_MANIFEST" | while read -r line; do
    project_name=$(echo "$line" | sed -n 's/.*name="\([^"]*\)".*/\1/p')
    revision=$(echo "$line" | sed -n 's/.*revision="\([^"]*\)".*/\1/p')

    if [ -z "$revision" ]; then
        echo "[FAIL] Project $project_name is missing revision attribute."
        ERRORS=$((ERRORS + 1))
    elif ! echo "$revision" | grep -Eq '^[0-9a-fA-F]{40}$'; then
        echo "[FAIL] Project $project_name revision '$revision' is not a 40-character hexadecimal SHA1 hash."
        ERRORS=$((ERRORS + 1))
    fi
done

if [ "$ERRORS" -gt 0 ]; then
    echo "=== Manifest Verification Result: FAILED ($ERRORS error(s)) ==="
    exit 1
else
    echo "[OK] All project entries in $PINNED_MANIFEST are pinned to valid 40-character SHA1 hashes."
    echo "=== Manifest Verification Result: PASSED ==="
    exit 0
fi
