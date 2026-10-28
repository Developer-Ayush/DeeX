Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.1, 3.2, 3.3, 3.4, 14.2, 14.3, 17.1, 17.3, 17.7

# DeeX Boot — Verified-Boot Specification

## 1. Objectives and Principles

This specification defines the mandatory technical requirements for the **DeeX Boot** module on the target smartphone platform (Google Pixel 8 `shiba` running Android 15 `android-15.0.0_r1`).

In accordance with Master Plan Section 3, DeeX Boot must establish an unbroken chain of cryptographic verification from the hardware Root of Trust (RoT) to the running operating system framework.

The primary mandate of DeeX Boot is: **An attacker must not be able to replace the installed DeeX system with a modified or corrupted image and have it silently accepted as authentic (Master Plan 3.3).**

---

## 2. Requirements Specification (`BOOT-` Requirements)

### 2.1 Trust Chain & Verification Architecture

#### `BOOT-001`: Hardware Root of Trust Chain
- **Statement**: The bootloader MUST verify the cryptographic signature of the initial boot metadata (`vbmeta`) against a hardware-protected Root of Trust key (Google Factory Key or owner-enrolled custom AVB key stored in Titan M2 secure element) before executing any software from primary storage.
- **Master Plan Mapping**: 3.1, 3.2
- **Existing Requirements Mapping**: `REQ-BOOT-001`, `RULE-SEC-001`
- **Testability**: Testable by attempting to boot an image signed with an untrusted or modified signature key.

#### `BOOT-002`: Pre-Execution Kernel & RAM Disk Verification
- **Statement**: The bootloader MUST verify the SHA-256/SHA-512 cryptographic hashes of the kernel, device tree, and initial ramdisk partitions (`boot`, `vendor_boot`, `init_boot`, `dtbo`, `pvmfw`) against the authenticated hash descriptors in `vbmeta` prior to loading them into system RAM for execution.
- **Master Plan Mapping**: 3.2
- **Existing Requirements Mapping**: `REQ-BOOT-002`
- **Testability**: Testable by modifying single bytes in the `boot` or `vendor_boot` partition image.

#### `BOOT-003`: Runtime Filesystem Verification (`dm-verity`)
- **Statement**: The operating system kernel MUST enforce read-only block-level integrity verification using `dm-verity` for all system filesystem partitions (`system`, `vendor`, `product`, `system_ext`, `vendor_dl`). Any read operation detecting an unauthenticated or modified block MUST trigger an immediate kernel panic or reboot.
- **Master Plan Mapping**: 3.2, 17.3
- **Existing Requirements Mapping**: `REQ-BOOT-003`
- **Testability**: Testable by writing corrupt data blocks directly to raw `system` block storage.

---

### 2.2 Covered Partitions and Residual Risk Analysis

#### `BOOT-004`: Mandatory Covered Partitions
- **Statement**: The DeeX boot chain MUST explicitly cover and authenticate all system software partitions listed below.
- **Master Plan Mapping**: 3.2
- **Existing Requirements Mapping**: `REQ-BOOT-004`

| Partition Name | Verification Method | Covering Descriptor | Residual Risk / Uncovered Reason |
|---|---|---|---|
| `boot` | Hash Descriptor (RAM pre-load) | `vbmeta` | None (fully authenticated before execution) |
| `vendor_boot` | Hash Descriptor (RAM pre-load) | `vbmeta` | None (fully authenticated before execution) |
| `init_boot` | Hash Descriptor (RAM pre-load) | `vbmeta` | None (fully authenticated before execution) |
| `dtbo` | Hash Descriptor (RAM pre-load) | `vbmeta` | None (fully authenticated before execution) |
| `pvmfw` | Hash Descriptor (RAM pre-load) | `vbmeta` | None (fully authenticated before execution) |
| `system` | Hashtree Descriptor (`dm-verity`) | `vbmeta` | None (runtime block-level verification) |
| `vendor` | Hashtree Descriptor (`dm-verity`) | `vbmeta` | None (runtime block-level verification) |
| `product` | Hashtree Descriptor (`dm-verity`) | `vbmeta` | None (runtime block-level verification) |
| `system_ext` | Hashtree Descriptor (`dm-verity`) | `vbmeta` | None (runtime block-level verification) |
| `vendor_dl` | Hashtree Descriptor (`dm-verity`) | `vbmeta` | None (runtime block-level verification) |
| `userdata` | **UNCOVERED by AVB** | None (Read/Write) | **Residual Risk**: User data storage cannot be verified via static hashes. Mitigated entirely by **DeeX Vault** hardware-backed FBE/FKM encryption. |
| `metadata` | **UNCOVERED by AVB** | None (Read/Write) | **Residual Risk**: Metadata stores filesystem keys and swap state. Mitigated by hardware key wrapping (Titan M2). |
| `persist` / `modemst` | **UNCOVERED by AVB** | Vendor Read/Write | **Residual Risk**: Calibration and radio NVRAM data. Mitigated by hardware write-protection registers and HAL isolation. |

---

### 2.3 Boot States & Failure Response Policy

#### `BOOT-005`: AVB Boot State Standard Compliance
- **Statement**: The boot chain MUST support and correctly report the standard AVB 2.0 boot states (`GREEN`, `YELLOW`, `ORANGE`, `RED`) to the kernel command line (`androidboot.verifiedbootstate`).
- **Master Plan Mapping**: 3.2, 3.3
- **Existing Requirements Mapping**: `REQ-BOOT-005`
- **Testability**: Testable by examining kernel command line parameters in different unlock and key states.

#### `BOOT-006`: Failure Response Policy (Owner Choice Option B)
- **Statement**: Upon detecting an unauthorized, modified, corrupted, or rolled-back system image:
  1. In **Production Release Builds (`user`)**: The bootloader MUST immediately **HALT BOOT** (State `RED`). Execution of the operating system MUST be completely refused. The device MUST present an immutable error message screen and require recovery mode or power off. **Silent fallback to an unverified or unauthenticated boot path is strictly prohibited.**
  2. In **Development / Testing Builds (`eng` / `userdebug`)**: The bootloader MAY allow execution to proceed to assist developer bringup, but MUST display a prominent warning screen (State `YELLOW` / `ORANGE`) for at least 10 seconds prior to booting.
- **Master Plan Mapping**: 3.2, 3.3, 17.3
- **Existing Requirements Mapping**: `REQ-BOOT-006`, `RULE-SEC-002`
- **Testability**: Testable by attempting to boot tampered release vs. development builds.

---

### 2.4 Build Variant Differences

#### `BOOT-007`: Strict Debug Privilege Absence in Release Builds
- **Statement**: Production release images (`build/configs/release.md` / `user`) MUST NOT contain development-only debugging privileges, including `adb` root access (`ro.debuggable=0`), disabled `dm-verity` options, fastboot OEM unlock flags, or permissive SELinux enforcement overrides.
- **Master Plan Mapping**: 2.4, 3.2
- **Existing Requirements Mapping**: `REQ-BOOT-007`
- **Testability**: Testable by auditing build configuration properties and attempting `adb root` on release images.

#### `BOOT-008`: Key Tier Isolation Rule
- **Statement**: System images compiled for release MUST be signed exclusively with production release keys (`deex-release-key-*`). Development keys (`deex-dev-key-*`) or test keys (`deex-test-key-*`) MUST be rejected by bootloaders running in locked state with release root keys.
- **Master Plan Mapping**: 3.2, 5.2
- **Existing Requirements Mapping**: `REQ-BOOT-008`, `RULE-SEC-003`
- **Testability**: Testable by signing a release image with a development key and attempting to boot on a locked target device.

---

### 2.5 Integrity of DeeX Security Services

#### `BOOT-009`: DeeX Native Service Partition Protection
- **Statement**: All proprietary DeeX platform daemons and security services located under `system/deex/` (`deex-identityd`, `deex-vaultd`, `deex-isolationd`, `deex-bridged`, `deex-connectd`, `deex-policyd`) MUST reside exclusively on verified read-only partitions (`/system` or `/system_ext`) covered by the `dm-verity` root hash in `vbmeta`.
- **Master Plan Mapping**: 3.2 (last bullet), 17.1
- **Existing Requirements Mapping**: `REQ-BOOT-009`
- **Testability**: Testable by checking binary install locations and verifying system mount read-only status.

#### `BOOT-010`: Boundary of Verified Boot Protection
- **Statement**: The DeeX Boot module establishes system integrity at boot time and block-level filesystem integrity during runtime. Verified Boot DOES NOT establish or guarantee runtime integrity of application memory after boot if a privileged process is compromised post-boot.
- **Master Plan Mapping**: 3.4, 17.7
- **Existing Requirements Mapping**: `REQ-BOOT-010`
- **Testability**: Documented boundary; verified via threat model analysis.

---

### 2.6 Explicit Non-Goals

#### `BOOT-011`: Non-Goals of Verified Boot
- **Statement**: Verified Boot explicitly DOES NOT provide:
  1. Confidentiality or encryption of user data files (handled by **DeeX Vault**).
  2. Physical theft protection against offline memory extraction from unlocked hardware.
  3. Defense against post-boot kernel memory exploitation or privilege escalation attacks (handled by **DeeX Kernel** and SELinux).
  4. Automatic recovery of user data corrupted by flash hardware failure.
- **Master Plan Mapping**: 3.4, 17.7
- **Existing Requirements Mapping**: `REQ-BOOT-011`
- **Testability**: Documented specification boundary.
