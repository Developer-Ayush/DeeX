Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.2, 3.3, 15.1, 15.8

# DeeX Boot — Test Plan & Traceability Matrix

## 1. Overview and Execution Principles

This document defines the formal test suite (`TEST-BOOT-001` …) for validating the requirements of the **DeeX Boot** module on the Google Pixel 8 (`shiba`).

In accordance with Chunk 6 rules and Master Plan Section 15.8:
- This document is a **test specification and procedure definition only**.
- No physical test execution is performed in Chunk 6. All test case results MUST remain marked **`NOT RUN`**.
- Execution will be carried out by the Project Owner in subsequent hardware bringup chunks.

---

## 2. Requirement Traceability Matrix

Every `BOOT-` requirement in `docs/specifications/boot-specification.md` MUST map 1:1 to at least one test procedure in this test plan.

| Specification Requirement ID | Requirement Summary | Corresponding Test Case ID | Test Execution Status |
|---|---|---|---|
| **`BOOT-001`** | Hardware Root of Trust Chain Verification | `TEST-BOOT-001`, `TEST-BOOT-008` | `NOT RUN` |
| **`BOOT-002`** | Pre-Execution Kernel Partition Verification | `TEST-BOOT-002` | `NOT RUN` |
| **`BOOT-003`** | Runtime Filesystem `dm-verity` Integrity | `TEST-BOOT-003` | `NOT RUN` |
| **`BOOT-004`** | Partition Coverage Audit | `TEST-BOOT-004` | `NOT RUN` |
| **`BOOT-005`** | AVB Boot State Reporting (`GREEN`/`ORANGE`/`RED`) | `TEST-BOOT-005` | `NOT RUN` |
| **`BOOT-006`** | Failure Response Policy Enforcement (Option B) | `TEST-BOOT-006` | `NOT RUN` |
| **`BOOT-007`** | Debug Privilege Absence in Release Builds | `TEST-BOOT-007` | `NOT RUN` |
| **`BOOT-008`** | Key Tier Isolation Enforcement | `TEST-BOOT-008` | `NOT RUN` |
| **`BOOT-009`** | DeeX Security Services Partition Integrity | `TEST-BOOT-009` | `NOT RUN` |
| **`BOOT-010`** | Verified Boot Boundary Verification | `TEST-BOOT-010` | `NOT RUN` |
| **`BOOT-011`** | Explicit Non-Goals Verification | `TEST-BOOT-011` | `NOT RUN` |

---

## 3. Detailed Test Cases (`TEST-BOOT-` Series)

### `TEST-BOOT-001`: Verification of Authentic Release Image Boot
- **Requirement Covered**: `BOOT-001`
- **Objective**: Confirm that a release build signed with production keys boots into `GREEN` state on a locked device with custom AVB key enrolled.
- **Preconditions**: Pixel 8 target device with bootloader locked and custom AVB key digest flashed into Titan M2.
- **Procedure Outline**:
  1. Build release target image (`aosp_shiba-user`).
  2. Sign all images and `vbmeta` using `deex-release-key-avb`.
  3. Flash signed images to target device using fastboot.
  4. Reboot device and observe boot process.
- **Expected Result**: Device boots silently into home screen with no warning banners; `getprop ro.boot.verifiedbootstate` returns `green`.
- **Evidence to Capture**: `adb shell getprop ro.boot.verifiedbootstate` log output, boot serial console log.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-002`: Rejection of Tampered Pre-Execution Kernel Image
- **Requirement Covered**: `BOOT-002`
- **Objective**: Confirm that modifying a single byte in `boot.img` causes the bootloader to reject execution.
- **Preconditions**: Pixel 8 target device in locked bootloader state with custom AVB key enrolled.
- **Procedure Outline**:
  1. Take signed `boot.img` and modify a byte in kernel binary payload.
  2. Flash tampered `boot.img` to `boot` partition via fastboot while unlocked, then lock device.
  3. Power cycle device and attempt normal boot.
- **Expected Result**: Bootloader detects hash mismatch against `vbmeta` descriptor; halts boot immediately with `RED` state error screen. Device does NOT execute kernel.
- **Evidence to Capture**: Digital photograph of device screen showing `RED` state error banner, serial UART console log.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-003`: Rejection of Tampered Runtime Filesystem Block (`dm-verity`)
- **Requirement Covered**: `BOOT-003`
- **Objective**: Confirm that corrupting a block in `/system` filesystem triggers immediate `dm-verity` kernel panic/reboot.
- **Preconditions**: Device running authenticated release image.
- **Procedure Outline**:
  1. Boot authenticated image into OS.
  2. Corrupt raw block on system partition using direct block device write during offline maintenance mode.
  3. Reboot device and initiate read operation on corrupted file.
- **Expected Result**: `dm-verity` driver detects hashtree mismatch; kernel panics immediately or reboots. Unauthenticated block is NEVER returned to user space.
- **Evidence to Capture**: `pstore` / `console-ramoops` kernel panic log, `dmesg` output showing `dm-verity` block verification error.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-004`: Audit of Partition Coverage Descriptors
- **Requirement Covered**: `BOOT-004`
- **Objective**: Audit `vbmeta.img` structure to verify all mandatory partitions (`boot`, `vendor_boot`, `init_boot`, `dtbo`, `pvmfw`, `system`, `vendor`, `product`, `system_ext`, `vendor_dl`) are covered by descriptors.
- **Preconditions**: Unsigned/signed build artifacts generated.
- **Procedure Outline**:
  1. Run `avbtool info_image --image vbmeta.img`.
  2. Parse descriptor output table and compare against `BOOT-004` partition list.
- **Expected Result**: Descriptors exist for every mandatory partition; zero mandatory system partitions left uncovered.
- **Evidence to Capture**: Text output of `avbtool info_image` captured into build record.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-005`: AVB Boot State Reporting Verification
- **Requirement Covered**: `BOOT-005`
- **Objective**: Verify that `androidboot.verifiedbootstate` prop matches actual bootloader state.
- **Preconditions**: Pixel 8 device in both locked and unlocked states.
- **Procedure Outline**:
  1. Boot device in unlocked state (`ORANGE`). Check `adb shell getprop ro.boot.verifiedbootstate`.
  2. Boot device in locked state with custom key (`GREEN`). Check property value.
- **Expected Result**: Property returns `orange` when unlocked, `green` when locked with matching key.
- **Evidence to Capture**: Terminal output of `adb shell getprop ro.boot.verifiedbootstate` for both states.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-006`: Failure Response Policy Verification (Release vs. Dev Builds)
- **Requirement Covered**: `BOOT-006`
- **Objective**: Confirm Option B failure policy: release builds halt on tampered image (`RED`); dev builds allow boot with warning (`YELLOW`/`ORANGE`).
- **Preconditions**: Tampered `system.img` built for both `user` and `userdebug` variants.
- **Procedure Outline**:
  1. Attempt to boot tampered `user` variant on locked device.
  2. Attempt to boot tampered `userdebug` variant on unlocked device.
- **Expected Result**: Release build halts completely (`RED` error screen). Development build boots after displaying 10-second warning screen.
- **Evidence to Capture**: Photo of release build halt screen, serial log of dev build warning sequence.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-007`: Debug Privilege Absence Audit in Release Builds
- **Requirement Covered**: `BOOT-007`
- **Objective**: Verify production release images contain zero debug privileges.
- **Preconditions**: Compiled `aosp_shiba-user` release zip.
- **Procedure Outline**:
  1. Extract `system/etc/prop.default` and `vendor/build.prop`.
  2. Verify `ro.debuggable=0`, `ro.secure=1`, `adb` root disabled.
  3. Attempt `adb root` on running release system.
- **Expected Result**: `ro.debuggable` is `0`; `adb root` fails with "cannot run as root in production builds".
- **Evidence to Capture**: Text dump of build properties and `adb root` refusal terminal output.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-008`: Rejection of Image Signed with Wrong Key Tier
- **Requirement Covered**: `BOOT-008`
- **Objective**: Verify locked bootloader with release key rejects image signed with dev key.
- **Preconditions**: Device locked with `deex-release-key-avb` digest.
- **Procedure Outline**:
  1. Sign `vbmeta.img` with `deex-dev-key-avb`.
  2. Flash to device and attempt boot.
- **Expected Result**: Bootloader detects signature key mismatch against Titan M2 enrolled digest; halts boot (`RED` state).
- **Evidence to Capture**: Bootloader error log / photos of halt screen.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-009`: DeeX Security Services Read-Only Partition Verification
- **Requirement Covered**: `BOOT-009`
- **Objective**: Verify that proprietary DeeX daemons under `system/deex/` sit on `dm-verity` protected partitions.
- **Preconditions**: Device booted to home screen.
- **Procedure Outline**:
  1. Inspect install paths of `deex-identityd`, `deex-vaultd`, etc.
  2. Attempt `adb shell touch /system/deex/identity/testfile`.
- **Expected Result**: Daemons are installed under `/system/deex/`; filesystem write fails with "Read-only file system".
- **Evidence to Capture**: Terminal transcript of `touch` command failure on `/system`.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-010`: Verified Boot Protection Boundary Documentation Audit
- **Requirement Covered**: `BOOT-010`
- **Objective**: Audit documentation to ensure runtime application memory boundaries are accurately represented.
- **Preconditions**: Specification documentation compiled.
- **Procedure Outline**: Review `docs/specifications/boot-specification.md` Section 2.5 for explicit statement of boundary.
- **Expected Result**: Section explicitly notes that Verified Boot protects system block integrity at boot/runtime, but not post-boot process memory corruption.
- **Evidence to Capture**: Doc diff / snippet verification.
- **Status**: `NOT RUN`

---

### `TEST-BOOT-011`: Non-Goals Verification Audit
- **Requirement Covered**: `BOOT-011`
- **Objective**: Audit specification to verify non-goals (encryption, theft, runtime exploitation) are clearly declared.
- **Preconditions**: Specification documentation compiled.
- **Procedure Outline**: Inspect Section 2.6 of `docs/specifications/boot-specification.md`.
- **Expected Result**: All four non-goals explicitly listed with cross-references to handling modules.
- **Evidence to Capture**: Doc diff / snippet verification.
- **Status**: `NOT RUN`
