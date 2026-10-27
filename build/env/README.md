# DeeX Reproducible Build Environment

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.1, 2.2, 2.4, 16.2

## Overview

This directory defines the containerized, reproducible build environment for compiling DeeX baseline images for Google Pixel 8 (`shiba`).

The environment is encapsulated in a Docker container based on an official Ubuntu 22.04 LTS base image, pinned by immutable SHA256 image digest.

## Environment Contents

The build container contains:
- **Base Operating System**: Ubuntu 22.04 LTS (pinned digest `ubuntu:22.04@sha256:e0f80c829509ef4df9e76bd8944eb7b8ec25cbb379b112a7f9448b2c77a77c9b`).
- **AOSP Build Toolchain & Dependencies**: Packages explicitly required by official AOSP build host guidelines (`git-core`, `gnupg`, `flex`, `bison`, `build-essential`, `zip`, `curl`, `zlib1g-dev`, `libc6-dev-i386`, `libxml2-utils`, `xsltproc`, `fontconfig`, `python3`, `rsync`, `bc`).
- **Source Management Tools**: Google `repo` tool (`https://storage.googleapis.com/git-repo-downloads/repo`).
- **DeeX Helper Dependencies**: POSIX-compliant shell environment, `git`, `curl`, `sha256sum`, and Python 3 runtime for structure and manifest verification scripts.
- **Non-Root Build User**: Dedicated `deexbuilder` unprivileged user (UID/GID 1000) for running build operations.

## Deliberate Exclusions

To preserve strict reproducibility, security boundaries, and modularity, this build environment **deliberately does NOT contain**:
- **AOSP Source Code**: No AOSP code tree is fetched inside the container layer. Source code is mounted at container runtime into `/workspace/deex`.
- **Proprietary Vendor Binaries / Firmware**: Driver blobs for Google Pixel 8 (`shiba`) are not embedded in the container image.
- **Signing Keys or Certificates**: No development keys, production keys, AVB keys, or Keystore credentials exist in the container image. Release keys reside strictly on air-gapped/hardware storage per Master Plan 3.2 and 5.2.
- **Pre-Built System Images**: Output artifacts (`out/`) are generated exclusively during clean build runs and output to host workspace mounts.

## How to Build the Container Image

To build the pinned DeeX container image:

```bash
docker build \
  -t deex-build-env:ubuntu22.04-v1 \
  -f build/env/Dockerfile .
```

## How to Enter the Environment

To launch an interactive session inside the build container with host workspace mounted:

```bash
docker run --rm -it \
  --name deex-build-container \
  -v "$(pwd):/workspace/deex" \
  -w /workspace/deex \
  deex-build-env:ubuntu22.04-v1 \
  /bin/bash
```

## Verification & Reproducibility Status

- Container Base Image: **Pinned by SHA256 Digest**.
- Package Installations: **Locked in `packages.lock.md`**.
- Reproducibility Claim Status: **NOT YET VERIFIED** (per Master Plan 17.7 and prompt Section 5.3, container environment reproducibility must be demonstrated by repeating clean builds on separate hosts and comparing output hashes in a later chunk).
