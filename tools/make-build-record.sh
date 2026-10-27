#!/bin/sh
# POSIX shell script to generate a build record from build output and template
# Master Plan Sections: 2.2, 2.4, 15.7, 16.3

set -eu

WORK_DIR=""
RESULT="UNKNOWN"
RECORD_FILE=""
LOG_FILE=""
EXIT_CODE="0"

usage() {
    cat << EOF
Usage: $0 --work-dir <PATH> --result <SUCCESS|FAILURE> [OPTIONS]

Options:
  --work-dir <PATH>      Path to working directory.
  --result <STATUS>      Build result status (SUCCESS or FAILURE).
  --record-file <PATH>   Output path for generated build record.
  --log-file <PATH>      Path to build log file.
  --exit-code <CODE>     Exit code of build process.
  --help                 Display this help message and exit.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --work-dir)
            WORK_DIR="$2"
            shift 2
            ;;
        --result)
            RESULT="$2"
            shift 2
            ;;
        --record-file)
            RECORD_FILE="$2"
            shift 2
            ;;
        --log-file)
            LOG_FILE="$2"
            shift 2
            ;;
        --exit-code)
            EXIT_CODE="$2"
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

if [ -z "$WORK_DIR" ]; then
    echo "Error: --work-dir is required." >&2
    exit 1
fi

REAL_WORK_DIR=$(cd "$(mkdir -p "$WORK_DIR" && pwd)" 2>/dev/null || echo "$WORK_DIR")
TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
BUILD_ID="DEEX-BASE-SHIBA-$TIMESTAMP"

if [ -z "$RECORD_FILE" ]; then
    RECORD_FILE="$REAL_WORK_DIR/records/build-record-$TIMESTAMP.md"
fi

mkdir -p "$(dirname "$RECORD_FILE")"

MANIFEST_FILE="build/manifests/aosp-pinned.xml"
MANIFEST_HASH="<SHA256_HERE>"
if [ -f "$MANIFEST_FILE" ]; then
    MANIFEST_HASH=$(sha256sum "$MANIFEST_FILE" | awk '{print $1}')
fi

DEEX_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "UNKNOWN — non-git build")

PRODUCT_OUT="$REAL_WORK_DIR/out/target/product/shiba"
EXPECTED_ARTIFACTS="boot.img system.img vendor.img product.img system_ext.img vbmeta.img super.img"

ARTIFACT_TABLE=""
for artifact in $EXPECTED_ARTIFACTS; do
    file_path="$PRODUCT_OUT/$artifact"
    if [ -f "$file_path" ]; then
        file_hash=$(sha256sum "$file_path" | awk '{print $1}')
        file_size=$(wc -c < "$file_path" | tr -d ' ')
        ARTIFACT_TABLE="${ARTIFACT_TABLE}| \`$artifact\` | Present | \`$file_hash\` | $file_size bytes |\n"
    else
        ARTIFACT_TABLE="${ARTIFACT_TABLE}| \`$artifact\` | Missing | \`<SHA256_HERE>\` | 0 bytes |\n"
    fi
done

cat << EOF > "$RECORD_FILE"
# DeeX Build Record: $BUILD_ID

- **Status**: $RESULT
- **Build ID**: \`$BUILD_ID\`
- **Date / Time**: $(date -u '+%Y-%m-%d %H:%M:%S UTC')
- **Build Result**: **$RESULT** (Exit Code: $EXIT_CODE)
- **AOSP Baseline Tag**: \`android-15.0.0_r1\` (Build ID \`AP3A.240905.015.A2\`)
- **Target Device / Product**: \`shiba\` / \`aosp_shiba-userdebug\`
- **Build Configuration**: \`build/configs/development.md\`
- **Pinned Manifest Hash (SHA-256)**: \`$MANIFEST_HASH\`
- **DeeX Repository Commit**: \`$DEEX_COMMIT\`
- **Container Image Digest**: \`NOT PROVIDED / UNKNOWN — decision required\`
- **Signing Key Identifier**: AOSP Development / Test Keys (\`build/target/product/security/testkey\`)

---

## Output Artifacts & Checksums

| Artifact File | Status | SHA-256 Checksum | File Size |
|---|---|---|---|
$(printf "%b" "$ARTIFACT_TABLE")

---

## Build Environment & Execution Summary

- **Work Directory**: \`$REAL_WORK_DIR\`
- **Build Log File**: \`$LOG_FILE\`
- **Build Host Architecture**: $(uname -m)
- **Host Kernel**: $(uname -sr)
- **Notes**: Baseline AOSP build for Google Pixel 8 (shiba). Proprietary vendor drivers acquired separately by owner per \`docs/build-records/vendor-binaries-procedure.md\`. No key material or secrets embedded.

EOF

echo "Build record successfully created at: $RECORD_FILE"
