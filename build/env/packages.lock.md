# DeeX Build Environment Package Lock Record

Status: UNVERIFIED — not built
Date: 2025-05-16
Master Plan Sections: 2.1, 2.2, 2.4

## Build Environment Image Status

- **Base Image**: `ubuntu:22.04@sha256:e0f80c829509ef4df9e76bd8944eb7b8ec25cbb379b112a7f9448b2c77a77c9b`
- **Build Container Status**: `UNVERIFIED — not built`
- **Build Attempt Output Summary**:
  Docker binary (`v29.2.1`) was present in the sandbox environment, but `docker build` failed due to sandbox container overlayfs nested mounting limitations (`err: invalid argument` on overlayfs cachemount snapshot).

Because the container image could not be fully built and executed inside this sandbox session, package version locking via `dpkg-query` / `apt list` inside the running container was not performed.

## Target Package Specifications (AOSP Ubuntu 22.04 Requirements)

The following package version requirements are specified based on official Ubuntu 22.04 LTS upstream repository baseline definitions:

| Package Name | Category | Primary Source Citation | Target Version Policy |
|---|---|---|---|
| `bc` | Build tool | source.android.com | Ubuntu 22.04 main repo (`1.07.1-*`) |
| `bison` | Parser generator | source.android.com | Ubuntu 22.04 main repo (`2:3.8.2-*`) |
| `build-essential` | Compiler/Make toolchain | source.android.com | Ubuntu 22.04 main repo (`12.9*`) |
| `ca-certificates` | Transport security | Ubuntu main | Ubuntu 22.04 main repo |
| `curl` | HTTP client | source.android.com | Ubuntu 22.04 main repo (`7.81.0-*`) |
| `flex` | Lexical analyzer | source.android.com | Ubuntu 22.04 main repo (`2.6.4-*`) |
| `fontconfig` | Font configuration | source.android.com | Ubuntu 22.04 main repo |
| `git` | SCM | source.android.com | Ubuntu 22.04 main repo (`1:2.34.1-*`) |
| `gnupg` | Cryptographic tool | source.android.com | Ubuntu 22.04 main repo (`2.2.27-*`) |
| `libc6-dev-i386` | 32-bit compatibility headers | source.android.com | Ubuntu 22.04 main repo |
| `libgl1-mesa-dev` | OpenGL headers | source.android.com | Ubuntu 22.04 main repo |
| `libx11-dev` | X11 headers | source.android.com | Ubuntu 22.04 main repo |
| `libxml2-utils` | XML toolchain | source.android.com | Ubuntu 22.04 main repo |
| `python3` | Runtime | source.android.com | Ubuntu 22.04 main repo (`3.10.6-*`) |
| `python-is-python3` | Symlink helper | source.android.com | Ubuntu 22.04 main repo |
| `rsync` | File sync | source.android.com | Ubuntu 22.04 main repo |
| `unzip` | Compression | source.android.com | Ubuntu 22.04 main repo |
| `zip` | Compression | source.android.com | Ubuntu 22.04 main repo |
| `zlib1g-dev` | Compression headers | source.android.com | Ubuntu 22.04 main repo |
| `repo` | Source management tool | storage.googleapis.com | Downloaded launcher v2.x |

## Verification Plan for Build Host Execution

When executed on a dedicated build host (or CI pipeline) with Docker overlayfs privileges, the following command must be run to generate the exact resolved `packages.lock.md`:

```bash
docker run --rm deex-build-env:ubuntu22.04-v1 dpkg-query -W -f='${Package}\t${Version}\n' > build/env/packages.lock.md
```
