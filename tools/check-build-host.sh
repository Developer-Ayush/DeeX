#!/bin/sh
# POSIX shell script to verify build host CPU, RAM, and free disk space against build/env/host-requirements.md thresholds

set -e

THRESHOLDS_FILE="build/env/host-requirements.md"

echo "=== DeeX Build Host Environment Check ==="

# Threshold minimums (AOSP requirements)
MIN_CPU_CORES=8
MIN_RAM_GB=32
MIN_DISK_GB=400

# Detect CPU Cores
if command -v nproc >/dev/null 2>&1; then
    CPU_CORES=$(nproc)
elif [ -f /proc/cpuinfo ]; then
    CPU_CORES=$(grep -c '^processor' /proc/cpuinfo)
else
    CPU_CORES=1
fi

# Detect System RAM in GB
RAM_GB=0
if [ -f /proc/meminfo ]; then
    RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    if [ -n "$RAM_KB" ]; then
        RAM_GB=$((RAM_KB / 1024 / 1024))
    fi
elif command -v free >/dev/null 2>&1; then
    RAM_MB=$(free -m | awk '/^Mem:/{print $2}')
    if [ -n "$RAM_MB" ]; then
        RAM_GB=$((RAM_MB / 1024))
    fi
fi

# Detect Free Disk Space in GB
DISK_GB=0
DISK_KB=$(df -k . | tail -n 1 | awk '{print $4}')
if [ -n "$DISK_KB" ]; then
    DISK_GB=$((DISK_KB / 1024 / 1024))
fi

echo "Detected Host Hardware Resources:"
echo "  - CPU Cores:      $CPU_CORES (Minimum required: $MIN_CPU_CORES)"
echo "  - System RAM:     ${RAM_GB} GB (Minimum required: ${MIN_RAM_GB} GB)"
echo "  - Free Disk:      ${DISK_GB} GB (Minimum required: ${MIN_DISK_GB} GB)"
echo "========================================="

ERRORS=0

# Check detected hardware against minimum thresholds
if [ "$CPU_CORES" -lt "$MIN_CPU_CORES" ]; then
    echo "[FAIL] Host CPU cores ($CPU_CORES) below minimum threshold ($MIN_CPU_CORES)."
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] Host CPU cores meet threshold."
fi

if [ "$RAM_GB" -lt "$MIN_RAM_GB" ]; then
    echo "[FAIL] Host RAM (${RAM_GB} GB) below minimum threshold (${MIN_RAM_GB} GB)."
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] Host RAM meets threshold."
fi

if [ "$DISK_GB" -lt "$MIN_DISK_GB" ]; then
    echo "[FAIL] Host free disk space (${DISK_GB} GB) below minimum threshold (${MIN_DISK_GB} GB)."
    ERRORS=$((ERRORS + 1))
else
    echo "[OK] Host free disk space meets threshold."
fi

# Check if thresholds file is missing or still contains UNKNOWN markers for owner host fit
if [ ! -f "$THRESHOLDS_FILE" ]; then
    echo "[FAIL] Host requirements thresholds file missing: $THRESHOLDS_FILE"
    ERRORS=$((ERRORS + 1))
elif grep -q "UNKNOWN" "$THRESHOLDS_FILE"; then
    echo "[FAIL] $THRESHOLDS_FILE contains 'UNKNOWN' owner specification markers."
    ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -gt 0 ]; then
    echo "=== Build Host Check Result: FAILED ($ERRORS error(s)) ==="
    exit 1
else
    echo "=== Build Host Check Result: PASSED ==="
    exit 0
fi
