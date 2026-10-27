Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 15.8, 17.3

# Baseline Build Troubleshooting Guide (Google Pixel 8 — shiba)

## Overview

This guide lists common failure categories encountered during initial AOSP builds, based on official primary sources (`https://source.android.com/docs/setup/download/troubleshoot-sync` and `https://source.android.com/docs/setup/build/building`, Access Date: 2025-05-16, Confidence: `VERIFIED`).

**Golden Rule:** Never attempt to resolve build failures by disabling verification checks, skipping manifest pin validation, bypassing script safety controls, or modifying code outside assigned chunk scope.

---

## Failure Categories & Safe Next Steps

### 1. Insufficient Host Disk Space or RAM
- **Symptom**: Soong / Ninja build crashes with `Out of Memory` (OOM), `Killed`, `No space left on device`, or compiler internal errors.
- **Confirmation**: Check `dmesg | grep -i oom` or run `df -h $WORK_DIR`.
- **What to Record**: Peak disk usage and peak RAM usage prior to crash, exact error log message.
- **Safe Next Step**: Increase swap allocation, expand build storage volume to at least 400 GB free space, or restrict parallel build jobs using `m -j<N>` where N is half host CPU core count.

### 2. Network Sync Interruption / Repo Failure
- **Symptom**: `tools/baseline-sync.sh` fails with `git fetch` timeouts, RPC errors, or incomplete object transfer.
- **Confirmation**: Inspect `$WORK_DIR/logs/sync-<TIMESTAMP>.log` for HTTP 50x or EOF errors.
- **What to Record**: Failed git repository URL, specific error code.
- **Safe Next Step**: Re-run `tools/baseline-sync.sh --work-dir "$WORK_DIR"` (repo automatically resumes interrupted downloads). Do not force checkout on unpinned branches.

### 3. Missing Required Host Packages or Toolchain Dependencies
- **Symptom**: `build/envsetup.sh` or `m` fails early reporting missing tools (e.g. `python3`, `git`, `flex`, `bison`, `rsync`, `zip`, `libssl-dev`).
- **Confirmation**: Run `tools/check-build-host.sh`.
- **What to Record**: Missing executable name and build stage where failure occurred.
- **Safe Next Step**: Execute the build inside the official container environment (`build/env/Dockerfile`) which pre-installs all pinned required host packages.

### 4. Vendor Binary Driver Blobs Missing or Incorrect
- **Symptom**: `lunch aosp_shiba-userdebug` succeeds, but `m` fails during packaging with missing vendor files under `vendor/google/shiba/` or `vendor/google_devices/shiba/`.
- **Confirmation**: Run `tools/verify-vendor-binaries.sh` against the vendor archive directory.
- **What to Record**: Missing vendor file path reported by Ninja.
- **Safe Next Step**: Re-read `docs/build-records/vendor-binaries-procedure.md`, ensure vendor `.sh` self-extractors were run inside `$WORK_DIR/src` and accepted, then re-run build.

### 5. Build Target Name Mismatch
- **Symptom**: `lunch` fails with `Invalid lunch combo: aosp_shiba-userdebug` or unknown target product.
- **Confirmation**: Verify that `device/google/shiba` exists in `$WORK_DIR/src/device/google/shiba` and `source build/envsetup.sh` was run.
- **What to Record**: `lunch` stdout/stderr error output.
- **Safe Next Step**: Verify that repo sync completed without error and `device/google/shiba` repository commit matches the pin in `build/manifests/aosp-pinned.xml`.

### 6. Unpinned Manifest or Template Manifest Detection
- **Symptom**: `tools/baseline-sync.sh` refuses to run with `[FAIL] Manifest contains UNRESOLVED markers or template format`.
- **Confirmation**: Run `tools/verify-manifest-pins.sh`.
- **What to Record**: Manifest verification script output.
- **Safe Next Step**: Ensure `build/manifests/aosp-pinned.xml` exists and contains no `UNKNOWN` or `UNRESOLVED` markers.
