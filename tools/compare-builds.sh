#!/bin/sh
# POSIX shell script to compare output files and hashes between two builds
# Master Plan Sections: 2.4, 16.2, 17.7

set -eu

DIR_A=""
DIR_B=""

usage() {
    cat << EOF
Usage: $0 --dir-a <PATH> --dir-b <PATH> [OPTIONS]

Options:
  --dir-a <PATH>   Path to output directory or build-record directory of Build A.
  --dir-b <PATH>   Path to output directory or build-record directory of Build B.
  --help           Display this help message and exit.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --dir-a)
            DIR_A="$2"
            shift 2
            ;;
        --dir-b)
            DIR_B="$2"
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

if [ -z "$DIR_A" ] || [ -z "$DIR_B" ]; then
    echo "Error: Both --dir-a and --dir-b are required." >&2
    usage
    exit 1
fi

if [ ! -d "$DIR_A" ]; then
    echo "Error: Directory A '$DIR_A' does not exist." >&2
    exit 1
fi

if [ ! -d "$DIR_B" ]; then
    echo "Error: Directory B '$DIR_B' does not exist." >&2
    exit 1
fi

echo "=== DeeX Build Comparison Report ==="
echo "Build Directory A: $DIR_A"
echo "Build Directory B: $DIR_B"
echo "Timestamp: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "----------------------------------------"

TEMP_LIST=$(mktemp)
trap 'rm -f "$TEMP_LIST"' EXIT

(
    cd "$DIR_A" && find . -type f | sort
    cd "$DIR_B" && find . -type f | sort
) | sort -u > "$TEMP_LIST"

MATCH_COUNT=0
DIFF_COUNT=0
ONLY_A_COUNT=0
ONLY_B_COUNT=0

printf "%-30s | %-12s | %-64s | %-64s\n" "Filename" "Status" "SHA-256 Hash (A)" "SHA-256 Hash (B)"
echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"

while read -r rel_file; do
    file_a="$DIR_A/$rel_file"
    file_b="$DIR_B/$rel_file"

    if [ -f "$file_a" ] && [ -f "$file_b" ]; then
        hash_a=$(sha256sum "$file_a" | awk '{print $1}')
        hash_b=$(sha256sum "$file_b" | awk '{print $1}')

        if [ "$hash_a" = "$hash_b" ]; then
            printf "%-30s | %-12s | %-64s | %-64s\n" "$rel_file" "IDENTICAL" "$hash_a" "$hash_b"
            MATCH_COUNT=$((MATCH_COUNT + 1))
        else
            printf "%-30s | %-12s | %-64s | %-64s\n" "$rel_file" "DIFFERENT" "$hash_a" "$hash_b"
            DIFF_COUNT=$((DIFF_COUNT + 1))
        fi
    elif [ -f "$file_a" ]; then
        hash_a=$(sha256sum "$file_a" | awk '{print $1}')
        printf "%-30s | %-12s | %-64s | %-64s\n" "$rel_file" "ONLY_IN_A" "$hash_a" "MISSING"
        ONLY_A_COUNT=$((ONLY_A_COUNT + 1))
    else
        hash_b=$(sha256sum "$file_b" | awk '{print $1}')
        printf "%-30s | %-12s | %-64s | %-64s\n" "$rel_file" "ONLY_IN_B" "MISSING" "$hash_b"
        ONLY_B_COUNT=$((ONLY_B_COUNT + 1))
    fi
done < "$TEMP_LIST"

echo "--------------------------------------------------------------------------------------------------------------------------------------------------------"
echo "Summary:"
echo "  Identical Files: $MATCH_COUNT"
echo "  Differing Files: $DIFF_COUNT"
echo "  Only in A:       $ONLY_A_COUNT"
echo "  Only in B:       $ONLY_B_COUNT"

TOTAL_DISCREPANCIES=$((DIFF_COUNT + ONLY_A_COUNT + ONLY_B_COUNT))

if [ "$TOTAL_DISCREPANCIES" -gt 0 ]; then
    echo "[FAIL] Build comparison detected $TOTAL_DISCREPANCIES discrepancy(ies). Builds are NOT binary reproducible."
    exit 1
else
    echo "[OK] All artifacts are bit-for-bit identical across builds."
    exit 0
fi
