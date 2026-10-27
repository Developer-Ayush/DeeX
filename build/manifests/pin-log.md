# DeeX Manifest Pin Resolution Log

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 16.2

## Overview

This log records every pinned project in the DeeX manifest hierarchy, detailing upstream repository URLs, exact resolved commit hashes, resolution timestamps, and verification commands.

Per master plan rules (Section 2.4) and prompt directives:
- Revision commit hashes must be resolved in session from official primary repositories using `git ls-remote` or manifest inspection.
- No commit hash may be fabricated or recorded from unverified memory.
- Unresolved projects due to pending owner release decisions are marked `UNRESOLVED`.

## Resolution Summary

- **Total Projects Target**: TBD (Pending owner AOSP release confirmation in `ADR-0003`)
- **Pinned Projects Count**: 0
- **Unresolved Projects Count**: All upstream AOSP projects (`UNRESOLVED — awaiting owner release choice in ADR-0003`)

## Sample Verified Upstream Repository Metadata (Session Resolution Checks)

The following primary source repositories were queried during this session using `git ls-remote` to confirm repository accessibility and tag resolution:

| Project Name | Path | Upstream Repository URL | Sample Tag / Reference | Resolved Commit Hash (SHA1) | Date / Time Resolved (UTC) | Resolving Command |
|---|---|---|---|---|---|---|
| `platform/manifest` | `.repo/manifests` | `https://android.googlesource.com/platform/manifest` | `HEAD` | `ad156f32caaa06dae91c02d443f6a8fe210eaa54` | 2025-05-16 03:22:00 | `git ls-remote https://android.googlesource.com/platform/manifest HEAD` |
| `platform/manifest` | `.repo/manifests` | `https://android.googlesource.com/platform/manifest` | `refs/tags/android-15.0.0_r1` | `43fb9dc3730e791b8d5a1bc8f8c0db1b8ed6f758` | 2025-05-16 03:22:00 | `git ls-remote --tags https://android.googlesource.com/platform/manifest` |

## Pinned Upstream AOSP Projects Log

*Note: Pinned entries will be generated when the owner selects the exact release tag in ADR-0003.*

| Project Name | Path | Upstream URL | Revision (SHA1) | Date/Time Resolved | Command Used | Status |
|---|---|---|---|---|---|---|
| `AOSP Projects` | Multiple | `https://android.googlesource.com/*` | `UNRESOLVED` | 2025-05-16 | `git ls-remote` | `UNRESOLVED — awaiting owner choice in ADR-0003` |

## Vendor and Target Device Repositories Log

The following vendor and device driver repositories are required for Google Pixel 8 (`shiba`):

| Component Name | Path | Source Location | Licence Status | Redistribution Status | Notes / Primary Source |
|---|---|---|---|---|---|
| `device/google/shiba` | `device/google/shiba` | AOSP / Google | Apache-2.0 (`VERIFIED`) | Open Source | Pixel 8 device tree configuration (`https://source.android.com`, 2025-05-16) |
| `device/google/shiba-sepolicy` | `device/google/shiba-sepolicy` | AOSP / Google | Apache-2.0 (`VERIFIED`) | Open Source | Pixel 8 SELinux policies |
| Google Pixel 8 Driver Blobs | `vendor/google/shiba` | Google Developer Hardware Drivers | `UNKNOWN` (Proprietary Google EULA) | Restricted / No Redistribute | Proprietary binaries for Tensor G3, Titan M2, GPU, Modem (`https://developers.google.com/android/drivers#shiba`, 2025-05-16) |
