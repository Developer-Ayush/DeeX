# DeeX — Deep Encrypted Execution X-Kernel

DeeX is a security-first mobile operating system derived from the Android Open Source Project (AOSP) for ARM64 smartphones. It maintains the Android framework necessary to run standard Android applications while providing strict per-account encrypted storage, account isolation, root-account access controls, escalating lockout policies, controlled USB and wireless access, and an external-isolation switch.

## Current Status

**Current Status:** Base Module — Chunk 3 Complete (Pinned AOSP Manifest and Reproducible Build-Environment Definition).
- **AOSP Source:** Not included in this repository.
- **OS Images:** No installable or runnable OS image exists yet.
- **Hardware Target:** Google Pixel 8 (`shiba` / Google Tensor G3 + Titan M2).

## Module Roadmap and Status

| Module | Purpose | Status |
|---|---|---|
| **Base** | Source foundation, build environment, device configs | In progress — Chunk 3 complete |
| **Boot** | Secure boot chain and verified boot (AVB) | Not started |
| **Kernel** | Platform support, kernel drivers, memory & access controls | Not started |
| **Vault** | Per-account encryption, key hierarchy, erasure & sanitization | Not started |
| **Identity** | Accounts, authentication, lockout policies, fingerprint state | Not started |
| **Isolation** | Storage & process separation between accounts | Not started |
| **Interface** | Login screen, root interface, minimal system apps | Not started |
| **Connect** | Telephony sharing, private Wi-Fi, external-isolation switch | Not started |
| **Bridge** | Controlled USB access, external-device authentication | Not started |
| **Android** | AOSP framework preservation, Android compatibility toggle | Not started |
| **Windows** | Windows execution compatibility layer & toggle | Not started |
| **Google** | CDD/CTS compliance, GMS licensing, Play Integrity | Not started |
| **Lifecycle** | Update integrity, recovery policies, account deletion | Not started |
| **Validation**| Repeatable security, performance, and reliability testing | Not started |
| **Release** | Production image generation, SBoM, performance metrics | Not started |

## Directory Map

- `docs/` — Architecture documentation, master specification, threat model, test framework, decision records (ADRs), and build records.
- `device/` — Device-specific board configs and targets (`target-device`).
- `vendor/` — Vendor drivers, binaries, and licensing rules (`target-device`).
- `packages/apps/` — Integrated system applications.
- `system/deex/` — DeeX custom core services (Identity, Vault, Isolation, Bridge, Connectivity, Policy).
- `tests/` — Automated test suites and security verification scripts.
- `build/` — Build system manifests (`build/manifests/`), build environment container definitions (`build/env/`), build configurations (`build/configs/`), and templates.
- `release/` — Production release manifests and distribution records.
- `tools/` — Development, build host checking, manifest verification, and structure verification scripts.
