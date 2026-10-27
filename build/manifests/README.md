# DeeX Build Manifests

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.3, 2.4, 16.2

## Overview

This directory contains the manifest definitions required to fetch and manage the DeeX source code tree using the Android `repo` tool.

DeeX uses a layered manifest structure to separate upstream AOSP components from custom DeeX system extensions and device target trees:

```text
       +---------------------------------------------+
       |   aosp-pinned.xml (or template)             |
       |   Upstream AOSP repositories pinned to      |
       |   exact 40-character commit hashes          |
       +---------------------------------------------+
                              |
                              v
       +---------------------------------------------+
       |   deex-local-manifest.xml                   |
       |   Custom DeeX system, device, and package   |
       |   repositories layered into .repo/local_manifests
       +---------------------------------------------+
                              |
                              v
       +---------------------------------------------+
       |   Developer Source Tree                     |
       |   Combined reproducible AOSP + DeeX tree    |
       +---------------------------------------------+
```

## Layered Manifest Architecture

1. **Upstream Pinned Manifest (`aosp-pinned.xml`)**:
   - Contains the explicit list of upstream AOSP repositories required to build the target device (`aosp_shiba-userdebug`).
   - Every project entry must specify a 40-character hexadecimal commit hash (`revision="<SHA1>"`). Floating branch names (such as `main`, `android-15.0.0_r1`, or `master`) are strictly forbidden in production pinned manifests.
   - Note: Until the project owner confirms the selected AOSP release in `ADR-0003`, this file is maintained as `aosp-pinned.xml.template` with `UNKNOWN — decision required` markers.

2. **DeeX Local Manifest (`deex-local-manifest.xml`)**:
   - Placed in `.repo/local_manifests/` during tree setup.
   - Defines DeeX-owned system modules (`system/deex/*`), custom applications (`packages/apps/*`), target device overlay (`device/target-device/`), and vendor driver specifications.
   - Remote hosting URLs are set to `UNKNOWN — decision required` where git hosting location has not been specified by the project owner.

3. **Pin Log (`pin-log.md`)**:
   - Records the exact resolution metadata for every pinned repository, including upstream URL, commit revision, resolution date, and resolving command.

4. **Change Management (`CHANGES.md`)**:
   - Defines strict policies governing manifest modifications. Pins may only be updated via formal ADR or logged security updates.

## Reproducing the Source Tree

When the AOSP release decision is confirmed by the owner and pins are resolved:

```bash
# 1. Initialize repo workspace using pinned manifest
repo init -u <deex-manifest-repo-url> -m aosp-pinned.xml -b refs/tags/<aosp-tag> --no-clone-bundle

# 2. Add DeeX local manifest
mkdir -p .repo/local_manifests
cp build/manifests/deex-local-manifest.xml .repo/local_manifests/deex.xml

# 3. Synchronize source tree (when on build host with required bandwidth and storage)
repo sync -c -j$(nproc) --no-tags --no-clone-bundle
```
