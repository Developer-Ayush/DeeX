# DeeX Software License and Dependency Inventory

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 16.2

## Overview

This inventory records all software components, target device driver dependencies, third-party libraries, and custom DeeX modules comprising the DeeX operating system build tree.

Per prompt rules and Master Plan Section 2.2:
- Licences are cited from verified primary source repositories where inspected.
- Unverified licenses are marked `UNKNOWN` and must not be guessed.
- Redistribution permissions are explicitly recorded based on upstream licensing terms.

## Component License Inventory Table

| Component Name | Path / Location | Category | Upstream Licence | Redistribution Status | Notes / Primary Source Citation |
|---|---|---|---|---|---|
| **AOSP Framework & Build System** | `build/make`, `frameworks/base` | AOSP | Apache-2.0 (`VERIFIED`) | Open Source / Permissive | Official AOSP tree (`https://source.android.com/docs/setup/about/licenses`, Access Date: 2025-05-16) |
| **Linux Kernel Baseline** | `kernel/google/gs201` / `gs-common` | AOSP / Device | GPL-2.0-only (`VERIFIED`) | Open Source / Copyleft | Kernel source for Google Tensor G3 (`https://android.googlesource.com/kernel/google/gs-common`, 2025-05-16) |
| **Google Pixel 8 Device Target** | `device/google/shiba` | Device | Apache-2.0 (`VERIFIED`) | Open Source / Permissive | Pixel 8 device tree (`https://android.googlesource.com/device/google/shiba`, 2025-05-16) |
| **Pixel 8 SELinux Policies** | `device/google/shiba-sepolicy` | Device | Apache-2.0 (`VERIFIED`) | Open Source / Permissive | Pixel 8 SEPolicy definitions |
| **Google Pixel 8 Hardware Drivers** | `vendor/google/shiba` | Vendor | `UNKNOWN` (Proprietary EULA) | Restricted / No Redistribution | Proprietary drivers for Tensor G3, Titan M2, GPU, modem (`https://developers.google.com/android/drivers#shiba`, 2025-05-16) |
| **Google Repo Tool** | `usr/local/bin/repo` | Third-party | Apache-2.0 (`VERIFIED`) | Open Source / Permissive | Google repository tool (`https://storage.googleapis.com/git-repo-downloads/repo`, 2025-05-16) |
| **Ubuntu 22.04 LTS Base Image** | `build/env/Dockerfile` | Third-party | Canonical Multi-Licence (`VERIFIED`) | Open Source / Permissive | Base OCI build image (`ubuntu:22.04@sha256:e0f80c82...`, 2025-05-16) |
| **DeeX Vault System Module** | `system/deex/vault` | DeeX-authored | `UNKNOWN — decision required` | Project Internal | Custom per-account encryption & key management service |
| **DeeX Identity System Module** | `system/deex/identity` | DeeX-authored | `UNKNOWN — decision required` | Project Internal | Custom multi-user account & lockout authentication service |
| **DeeX Isolation System Module** | `system/deex/isolation` | DeeX-authored | `UNKNOWN — decision required` | Project Internal | Custom process & storage account separation HAL/SEPolicy |
| **DeeX Bridge System Module** | `system/deex/bridge` | DeeX-authored | `UNKNOWN — decision required` | Project Internal | Custom USB external connection authorization daemon |
| **DeeX Connect System Module** | `system/deex/connectivity` | DeeX-authored | `UNKNOWN — decision required` | Project Internal | Telephony & isolation switch policy enforcement service |
| **DeeX Policy System Module** | `system/deex/policy` | DeeX-authored | `UNKNOWN — decision required` | Project Internal | System-wide compatibility & resource accounting policy |

## Decisions Required from Project Owner

The project owner must make formal licensing decisions on the following items before commercial distribution or public release:

1. **DeeX Project Software Licence (`DEC-007`)**:
   - The project owner must choose and record the open-source or proprietary software license governing DeeX-authored system components (`system/deex/*`, `packages/apps/*`). Options include Apache-2.0, GPLv3, or proprietary commercial license.
2. **Proprietary Vendor Blob Redistribution (`DEC-004`)**:
   - Google Pixel 8 proprietary driver binaries (`vendor/google/shiba`) are distributed under Google Software License Agreement for Pixel Devices.
   - The owner must decide whether DeeX binaries will be distributed as "sans-vendor" images requiring users to flash Google vendor blobs locally, or under a vendor licensing agreement if applicable.
