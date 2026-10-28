# DeeX — Deep Encrypted Execution X-Kernel

DeeX is a security-first mobile operating system derived from the Android Open Source Project (AOSP) for ARM64 smartphones. It maintains the Android framework necessary to run standard Android applications while providing strict per-account encrypted storage, account isolation, root-account access controls, escalating lockout policies, controlled USB and wireless access, and an external-isolation switch.

## Current Status

**Current Status:** Kernel Module — Specification in progress — Chunk 7 complete (Specification and plan only — nothing implemented or tested).
- **AOSP Baseline Release**: Confirmed Android 15 (`android-15.0.0_r1` / `AP3A.240905.015.A2`). Pinned manifest `build/manifests/aosp-pinned.xml` fully instantiated.
- **AOSP Source:** Not synced in this repository. Build wrapper tooling (`tools/baseline-sync.sh`, `tools/baseline-build.sh`) provided for project owner execution.
- **OS Images:** No installable or runnable OS image exists yet in this repository. Specification, research, and test plan only.
- **Hardware Target:** Google Pixel 8 (`shiba` / Google Tensor G3 `zuma` + Titan M2).

## Module Roadmap and Status

| Module | Purpose | Status |
|---|---|---|
| **Base** | Source foundation, build environment, device configs, baseline build procedure, flash procedure & hardware report structure | In progress — Chunk 5 complete (Base completion `NOT YET EVIDENCED`) |
| **Boot** | Secure boot chain and verified boot (AVB) | Specification in progress — Chunk 6 complete (Specification and plan only — nothing implemented or tested) |
| **Kernel** | Platform support, kernel drivers, memory & access controls, resource accounting | Specification in progress — Chunk 7 complete (Specification and plan only — nothing implemented or tested) |
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
- `build/` — Pinned AOSP build manifests (`build/manifests/aosp-pinned.xml`), build environment container definitions (`build/env/`), build configurations (`build/configs/`), and templates.
- `release/` — Production release manifests and distribution records.
- `tools/` — Development, build host checking, manifest pin verification, baseline sync/build wrappers, build record generator, comparison tooling, vendor binary verifier, and structure verification scripts.
