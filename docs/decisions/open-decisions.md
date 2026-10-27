# Open Decisions Log

The following architectural, build, and hardware decisions are tracked for the DeeX project.

| Decision ID | Decision Required | Status | Owner | Informed By / Related File | Blocking Reason / Dependencies |
|---|---|---|---|---|---|
| `DEC-001` | Target smartphone model and SoC | **RESOLVED** | Project owner | `docs/decisions/ADR-0002-target-device.md` | Selected: Google Pixel 8 (`shiba` / Tensor G3) |
| `DEC-002` | Chosen AOSP release / tag | **RESOLVED** | Project owner | `docs/decisions/ADR-0003-aosp-release.md` | Confirmed: Android 15 tag `android-15.0.0_r1` (`AP3A.240905.015.A2`). `aosp-pinned.xml` instantiated. |
| `DEC-003` | Kernel version and source | **RESOLVED** | Project owner | `docs/decisions/ADR-0003-aosp-release.md` | Pixel 8 Linux 6.1 LTS baseline (`kernel/google/gs-common`). |
| `DEC-004` | Availability and licensing of vendor drivers/blobs | **OPEN** | Project owner | `docs/build-records/licence-and-dependency-inventory.md` | Proprietary Google driver blobs acquired personally by owner; external redistribution model pending decision. |
| `DEC-005` | Bootloader unlock/relock and AVB custom key support | **RESOLVED** | Project owner | `docs/specifications/key-and-signing-policy.md` | Bootloader unlock procedure documented; custom AVB key relocking deferred to DeeX Boot module (Chunk 6+). |
| `DEC-006` | Hardware security element (StrongBox, KeyMint, TEE) | **RESOLVED** | Project owner | `device/target-device/candidates/google-pixel-8.md` | Pixel 8 Titan M2 EAL6+ StrongBox coprocessor present. |
| `DEC-007` | Project's own open source / proprietary licence | **OPEN** | Project owner | `docs/build-records/licence-and-dependency-inventory.md` | Blocks formal distribution terms for `system/deex/*`. |
| `DEC-008` | Vulnerability-reporting security contact email | **OPEN** | Project owner | `SECURITY.md` | Blocks formal security response publication. |
| `DEC-009` | Build host specification (CPU, RAM, free disk) | **OPEN** | Project owner | `build/env/host-requirements.md` | Real measured build host values pending owner execution of baseline build. |
| `DEC-010` | GMS licensing process and legal applicant | **OPEN** | Project owner | Master Plan Section 13 | Blocks formal GMS partner application workflow. |
| `DEC-011` | Windows-compatibility technical approach | **OPEN** | Project owner | Master Plan Section 12 | Deferred to Windows module specification phase. |
| `DEC-012` | Git hosting location for DeeX-owned repositories | **OPEN** | Project owner | `build/manifests/deex-local-manifest.xml` | Remote set to `UNKNOWN — decision required` in local manifest. |
| `DEC-013` | Continuous Integration (CI) service provider | **OPEN** | Project owner | `build/configs/testing.md` | CI runner environment pending decision. |
| `DEC-014` | Local build work directory location (`WORK_DIR`) | **OPEN** | Project owner | `docs/build-records/baseline-build-procedure.md` | Owner configures local `WORK_DIR` path on build host. |
| `DEC-015` | Second build host for reproducibility comparison | **OPEN** | Project owner | `docs/build-records/two-build-comparison-procedure.md` | Pending owner availability of second build host. |
| `DEC-016` | Relocking policy and custom AVB root key provisioning | **OPEN** | Project owner | `docs/build-records/flash-and-boot-procedure.md` | Bootloader relocking with custom key deferred to DeeX Boot module. |
| `DEC-017` | Hardware-level driver control for radio isolation | **OPEN** | Project owner | `docs/build-records/known-limitations.md` | Driver-level radio cut capability pending physical hardware driver testing (`LIM-002`). |
| `DEC-018` | Hardware physical partition block sizes and dynamic extent allocation | **OPEN** | Project owner | `docs/build-records/partition-layout.md` | Pending physical device output from owner via `adb shell`. |
| `DEC-019` | Real hardware support test execution results | **OPEN** | Project owner | `docs/build-records/baseline-hardware-support-report.md` | Pending physical execution of checklist `HW-01` to `HW-16` by owner on target device. |
