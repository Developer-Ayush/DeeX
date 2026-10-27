Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 15.7, 16.3, 17.6

# Build Results Intake Form Template

This intake form must be filled in by the project owner after executing the baseline build procedure (`docs/build-records/baseline-build-procedure.md`) on their build host, and pasted back into the project prompt for results ingestion.

---

```text
===================================================================
DEEX BASELINE BUILD RESULTS INTAKE
===================================================================

1. BUILD METADATA & IDENTIFICATION
-------------------------------------------------------------------
Build ID:                 [ OWNER FILL IN: e.g. DEEX-BASE-SHIBA-20250516-01 ]
Build UTC Date & Time:    [ OWNER FILL IN: YYYY-MM-DD HH:MM:SS UTC ]
Build Result:             [ OWNER FILL IN: SUCCESS / FAILURE ]
AOSP Baseline Tag:        android-15.0.0_r1
AOSP Build ID / Release:  AP3A.240905.015.A2
Target Product & Variant: aosp_shiba-userdebug
Pinned Manifest SHA-256:  [ OWNER FILL IN: SHA-256 hash of build/manifests/aosp-pinned.xml ]
DeeX Repo Commit Hash:    [ OWNER FILL IN: Git commit hash of DeeX repository ]
Container Image Digest:   [ OWNER FILL IN: Container image digest if built in container, or "N/A - Direct Host" ]

2. BUILD HOST ENVIRONMENT
-------------------------------------------------------------------
Host OS / Distribution:   [ OWNER FILL IN: e.g. Ubuntu 22.04.4 LTS ]
CPU Architecture & Cores: [ OWNER FILL IN: e.g. x86_64 / 32 cores ]
System RAM Installed:     [ OWNER FILL IN: e.g. 64 GB ]
Free Disk Available:      [ OWNER FILL IN: e.g. 500 GB ]
Toolchain / Tool Versions:[ OWNER FILL IN: repo vX.Y, git vX.Y, Python 3.X, OpenJDK vX.Y ]

3. BUILD PERFORMANCE & RESOURCE MEASUREMENTS
-------------------------------------------------------------------
Sync Duration:            [ OWNER FILL IN: e.g. 45 min 12 sec ]
Sync Disk Usage:          [ OWNER FILL IN: e.g. 185 GB ]
Build Duration:           [ OWNER FILL IN: e.g. 2 hours 15 min ]
Peak RAM Usage:           [ OWNER FILL IN: e.g. 42 GB ]
Peak Disk Usage:          [ OWNER FILL IN: e.g. 310 GB ]
Build Warning Count:      [ OWNER FILL IN: Number of warnings printed during build ]

4. OUTPUT ARTIFACT LIST & CRYPTOGRAPHIC HASHES
-------------------------------------------------------------------
Directory: $WORK_DIR/out/target/product/shiba/

[ ] boot.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

[ ] system.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

[ ] vendor.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

[ ] product.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

[ ] system_ext.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

[ ] vbmeta.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

[ ] super.img
    SHA-256: [ OWNER FILL IN: 64-char hex SHA-256 hash ]
    Size:    [ OWNER FILL IN: Size in bytes ]

5. VENDOR BINARY VERIFICATION
-------------------------------------------------------------------
Vendor Driver Archive:    [ OWNER FILL IN: e.g. google_devices-shiba-ap3a.240905.015.a2-*.tgz ]
Vendor Archive SHA-256:   [ OWNER FILL IN: SHA-256 hash of downloaded vendor archive ]
Vendor License Accepted:  [ OWNER FILL IN: YES ]

6. FAILURE & ERROR LOGS (IF RESULT == FAILURE)
-------------------------------------------------------------------
Error Message / Summary:  [ OWNER FILL IN: Paste exact error output if build failed ]
Log File Name:            [ OWNER FILL IN: Name of log file under work/logs/ ]

7. NOTES & OBSERVATIONS
-------------------------------------------------------------------
Notes:                    [ OWNER FILL IN: Optional build notes ]
===================================================================
```
