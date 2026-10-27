# DeeX Development Tools

This directory contains utility scripts and tools used during DeeX development and continuous integration.

## Available Tools

- **`check-repo-structure.sh`**: POSIX shell script that verifies the presence of required directory skeletons, README files, top-level specifications, deliverables across all completed chunks, `.gitignore` safety rules, and absence of committed cryptographic key files (`*.key`, `*.pem`, `*.keystore`, `*.pk8`).
- **`check-build-host.sh`**: POSIX shell script that checks host CPU core count, system RAM capacity, and free disk space against minimum threshold requirements in `build/env/host-requirements.md`.
- **`verify-manifest-pins.sh`**: POSIX shell script that verifies `build/manifests/aosp-pinned.xml` project pins, ensuring every project revision is a 40-character hexadecimal commit hash and no floating branch names exist.
- **`baseline-sync.sh`**: POSIX shell wrapper script that initializes and syncs the pinned AOSP source tree into `$WORK_DIR/src` using `build/manifests/aosp-pinned.xml`, logs execution to `$WORK_DIR/logs/`, and verifies commit pins after sync. Supports `--dry-run`.
- **`baseline-build.sh`**: POSIX shell wrapper script that executes the baseline image build (`m`) for `aosp_shiba-userdebug`, logs execution, verifies output artifact presence (`boot.img`, `system.img`, `vendor.img`, `product.img`, `system_ext.img`, `vbmeta.img`, `super.img`), writes build records via `make-build-record.sh`, and fails non-zero on error. Supports `--dry-run` and `--stub-fail-test`.
- **`make-build-record.sh`**: POSIX shell script that constructs build records from `build/templates/build-record.md` containing build ID, timestamps, manifest hash, git commit hash, artifact checksums, host specs, and result status.
- **`compare-builds.sh`**: POSIX shell script that compares output directories or build records between two builds, reporting matching, differing, or missing files with SHA-256 hashes, exiting non-zero on any discrepancy.
- **`verify-vendor-binaries.sh`**: POSIX shell script that verifies owner-provided vendor binary archives in a specified directory against expected SHA-256 checksums without downloading files.

## Usage Instructions

```sh
# Run repository structure and hygiene verification
sh tools/check-repo-structure.sh

# Run host environment hardware threshold check
sh tools/check-build-host.sh

# Run manifest project pin verification
sh tools/verify-manifest-pins.sh

# Execute dry-run of baseline source sync
sh tools/baseline-sync.sh --work-dir ./work --dry-run

# Execute dry-run of baseline image build
sh tools/baseline-build.sh --work-dir ./work --dry-run

# Compare two build output directories
sh tools/compare-builds.sh --dir-a ./work_a/out/target/product/shiba --dir-b ./work_b/out/target/product/shiba

# Verify downloaded vendor driver binary archives
sh tools/verify-vendor-binaries.sh --vendor-dir /path/to/downloads --expected-sha256 <HASH>
```
