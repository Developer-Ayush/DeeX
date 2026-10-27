# DeeX Development Tools

This directory contains utility scripts and tools used during DeeX development and continuous integration.

## Available Tools

- **`check-repo-structure.sh`**: POSIX shell script that verifies the presence of required directory skeletons, README files, top-level specifications, deliverables across all completed chunks, `.gitignore` safety rules, and absence of committed cryptographic key files (`*.key`, `*.pem`, `*.keystore`, `*.pk8`).
- **`check-build-host.sh`**: POSIX shell script that checks host CPU core count, system RAM capacity, and free disk space against minimum threshold requirements in `build/env/host-requirements.md`.
- **`verify-manifest-pins.sh`**: POSIX shell script that verifies `build/manifests/aosp-pinned.xml` project pins, ensuring every project revision is a 40-character hexadecimal commit hash and no floating branch names exist.

## Usage Instructions

```sh
# Run repository structure and hygiene verification
sh tools/check-repo-structure.sh

# Run host environment hardware threshold check
sh tools/check-build-host.sh

# Run manifest project pin verification (expects populated aosp-pinned.xml)
sh tools/verify-manifest-pins.sh
```
