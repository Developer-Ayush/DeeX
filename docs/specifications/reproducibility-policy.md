# DeeX Build Reproducibility Policy and Verification Procedure

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 16.2, 17.7

## 1. Definition of Reproducibility for DeeX

For the DeeX operating system, a build is defined as **Reproducible** if and only if two independent build executions, performed on separate host machines or at different points in time, using identical pinned input definitions and build configurations, produce bit-for-bit identical system image artifacts (identical SHA256 checksums across all output image partitions).

Per Master Plan Section 17.7, reproducibility is a strict technical goal to be demonstrated through empirical test evidence in Chunk 4. **Reproducibility has NOT been demonstrated yet.**

## 2. Pinned Build Inputs

To eliminate build variance, all inputs to the build process must be pinned to explicit, immutable identifiers:

1. **Source Code Manifest**: Upstream AOSP repositories pinned to exact 40-character SHA1 commit hashes in `build/manifests/aosp-pinned.xml`. No floating branch names permitted.
2. **Containerized Build Environment**: Docker build image pinned by immutable base image digest (`ubuntu:22.04@sha256:...`) and locked host tool packages in `build/env/packages.lock.md`.
3. **Toolchain and Compiler Versions**: Clang/LLVM toolchain binaries, Rust compilers, Soong build system binaries, and Ninja build tools pinned within the AOSP prebuilts tree (`prebuilts/clang/host/`).

## 3. Hermetic Environment Variables and Time Control

Build non-determinism is frequently introduced by ambient build host environment variables, variable timestamps, directory paths, and local user settings.

The build container execution script (`tools/build-container.sh`) MUST clamp and sanitize the following build variables:

| Environment Variable | Controlled Value / Policy | Impact on Output |
|---|---|---|
| `SOURCE_DATE_EPOCH` | Pinned Unix epoch timestamp (e.g. `1715817600`) | Standardizes zip header and file creation timestamps |
| `BUILD_DATETIME` | Pinned build timestamp file | Clamps AOSP `build_date` system property |
| `KBUILD_BUILD_TIMESTAMP` | Fixed UTC timestamp string | Standardizes kernel image compile timestamp |
| `KBUILD_BUILD_USER` | Fixed string (`deexbuilder`) | Eliminates host username in kernel build banner |
| `KBUILD_BUILD_HOST` | Fixed string (`deex-repro-host`) | Eliminates host domain in kernel build banner |
| `TZ` | `UTC` | Prevents local timezone offset discrepancies |
| `LC_ALL` / `LANG` | `C.UTF-8` | Ensures consistent locale sorting in archive generation |
| `PATH` | Strictly set to container toolchain paths | Prevents host binary leaks into build path |

## 4. Build Host Independence Requirement

A build configuration is considered truly reproducible only when two clean builds performed on different physical host architectures or cloud instances (e.g., Host A running Ubuntu 22.04 and Host B running Debian 12 inside the pinned Docker container) produce byte-identical SHA256 hashes for:
- `boot.img`
- `vendor_boot.img`
- `system.img`
- `vendor.img`
- `product.img`
- `system_ext.img`

## 5. Dual-Build Hash Comparison and Discrepancy Rule

### Verification Procedure (Chunk 4 Execution Protocol)

1. **Build Run 1 (Clean Worktree)**:
   - Perform clean checkout from pinned manifest.
   - Execute containerized build: `m aosp_shiba-user`.
   - Record output SHA256 hashes into `build_run1_hashes.txt`.
2. **Environment Wipe & Purge**:
   - Completely remove `out/` build output directory and clear ccache.
3. **Build Run 2 (Clean Worktree on Separate Machine/Instance)**:
   - Perform fresh checkout from pinned manifest.
   - Execute containerized build: `m aosp_shiba-user`.
   - Record output SHA256 hashes into `build_run2_hashes.txt`.
4. **Automated Hash Comparison**:
   - Compare `build_run1_hashes.txt` and `build_run2_hashes.txt` using `diff -u`.

### Mandatory Discrepancy Investigation Rule

If any output partition binary hash differs between Build Run 1 and Build Run 2:
- **Rule**: The difference must **NEVER** be ignored, bypassed, or silently accepted.
- **Action**: Build engineers must use binary diff tools (e.g. `diffoscope`) to isolate the exact non-deterministic bytes (e.g., embedded timestamps, file ordering in ramdisk archives, compiler alignment padding).
- **Resolution**: Fix the non-deterministic build rule or document the issue in `docs/decisions/open-decisions.md` before certifying the build configuration.

## 6. Primary Source References

- Reproducible Builds Project Guidelines: `https://reproducible-builds.org/docs/` (Access Date: 2025-05-16, Confidence: `VERIFIED`)
- Android Source Build Environment Controls: `https://source.android.com/docs/setup/build/building` (Access Date: 2025-05-16, Confidence: `VERIFIED`)
