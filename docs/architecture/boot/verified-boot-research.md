Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.1, 3.2, 3.3, 17.6

# Android Verified Boot (AVB) Research Note for Google Pixel 8 (shiba) on Android 15

## 1. Overview and Architecture

Android Verified Boot 2.0 (AVB) establishes a verified chain of trust starting from the hardware Root of Trust (RoT) in ROM/bootloader to the running operating system framework. On the Google Pixel 8 (`shiba`), the hardware RoT resides in the Google Tensor G3 Primary Bootloader (PBL) and Titan M2 security coprocessor.

Primary Sources Cited:
- [Primary Source 1: Android Open Source Project, "Verified Boot Overview", https://source.android.com/docs/security/features/verifiedboot, Access Date: 2025-05-16, Confidence: VERIFIED]
- [Primary Source 2: Android Open Source Project, "Android Verified Boot (AVB)", https://source.android.com/docs/security/features/verifiedboot/avb, Access Date: 2025-05-16, Confidence: VERIFIED]
- [Primary Source 3: Android Open Source Project, "Boot Flow", https://source.android.com/docs/security/features/verifiedboot/boot-flow, Access Date: 2025-05-16, Confidence: VERIFIED]
- [Primary Source 4: Android Open Source Project, "Device State", https://source.android.com/docs/security/features/verifiedboot/device-state, Access Date: 2025-05-16, Confidence: VERIFIED]
- [Primary Source 5: Google Pixel Security Documentation, "Google Titan M2 Security Chip", https://store.google.com/magazine/pixel_titan_m2, Access Date: 2025-05-16, Confidence: REPORTED]

---

## 2. Chain of Trust Architecture

```text
+-------------------------------------------------------------+
| Google Tensor G3 Primary Bootloader (PBL / Hardware RoT)    |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
| Secondary Bootloader (SBL / ABL) & Titan M2 Validation      |
+-------------------------------------------------------------+
                               |
                               v
+-------------------------------------------------------------+
| vbmeta Partition (AVB RSA-4090 / SHA-256 Signature Check)   |
+-------------------------------------------------------------+
            |                                  |
            v                                  v
+-----------------------+          +--------------------------+
| Hash Descriptors      |          | Hashtree Descriptors     |
| (boot, vendor_boot,   |          | (system, vendor, product,|
|  dtbo, init_boot)     |          |  system_ext, system_dl)  |
+-----------------------+          +--------------------------+
            |                                  |
            v                                  v
+-----------------------+          +--------------------------+
| Direct Hash Check in  |          | dm-verity Runtime Tree   |
| RAM during loading    |          | Integrity Verification   |
+-----------------------+          +--------------------------+
```

1. **Hardware Root of Trust**: The Google Tensor G3 PBL verifies the cryptographic signature of the Secondary Bootloader (SBL/ABL) using public keys fused into SoC hardware registers during manufacturing.
2. **Bootloader Execution**: The bootloader initializes memory, checks the device lock state (LOCKED vs. UNLOCKED), and reads the primary `vbmeta` partition header.
3. **`vbmeta` Verification**:
   - In **LOCKED** state with OEM keys: Bootloader checks `vbmeta` signature against Google/OEM public key stored in Titan M2.
   - In **LOCKED** state with Custom Root Key: Bootloader checks `vbmeta` signature against the key digest embedded via `fastboot flash avb_custom_key`.
   - In **UNLOCKED** state: Bootloader validates `vbmeta` and proceeds to boot, but reports state as ORANGE/UNVERIFIED to kernel command line.
4. **Kernel Partition Loading**: `vbmeta` contains Hash Descriptors for header/boot partitions (`boot`, `vendor_boot`, `init_boot`, `dtbo`, `pvmfw`). Bootloader hashes these images in RAM before transferring execution.
5. **Dynamic Partition Verification (`dm-verity`)**: For filesystem partitions (`system`, `vendor`, `product`, `system_ext`), `vbmeta` contains dm-verity root hashes and hashtrees. Kernel `dm-verity` driver verifies block integrity continuously at runtime.

---

## 3. AVB Structure & Descriptors

AVB 2.0 uses centralized or chained `vbmeta` structures containing cryptographic descriptors:

- **Hash Descriptors**: Store expected SHA-256 or SHA-512 hashes for small partitions (`boot`, `vendor_boot`, `init_boot`, `dtbo`).
- **Hashtree Descriptors**: Store dm-verity root hashes, salt, block size, and hashtree tree structure location for large read-only filesystems (`system`, `vendor`, `product`, `system_ext`).
- **Chained Partition Descriptors**: Direct verification of secondary partitions (e.g., `vbmeta_system`, `vbmeta_vendor`) signed with distinct key pairs, referencing rollback index locations.

---

## 4. Boot States and Security Implications

[Primary Source: AOSP Boot Flow & Device State, https://source.android.com/docs/security/features/verifiedboot/boot-flow, Access Date: 2025-05-16, Confidence: VERIFIED]

| Boot State | Condition / Trigger | User Display / Warning | Functional & Security Implication |
|---|---|---|---|
| **GREEN** | Device is LOCKED. Boot image chain and `vbmeta` signed by verified key (OEM or enrolled custom key). Rollback check passed. | None (Silent boot to OS home screen). | Full chain of trust established. Hardware-backed key storage (Titan M2 / StrongBox) operates in fully verified mode. |
| **YELLOW** | Device is LOCKED or UNLOCKED. Image is signed by a custom key, or fallback warning flag is set on custom image. | Warning screen displayed for 10 seconds before proceeding. | Verification succeeded using alternate custom key. System notifies user that custom software is running. |
| **ORANGE** | Device is UNLOCKED (`fastboot flashing unlock`). | Warning screen displayed for 10-30 seconds. User can press power to pause/continue. | Integrity CANNOT be guaranteed. Bootloader allows unauthenticated images to execute. Titan M2 restricts certain strict key attestation properties. |
| **RED** | Device is LOCKED, but verification failed (corrupted image, hash mismatch, signature invalid, or rollback check failed). | Warning screen displayed indicating device is corrupted and cannot boot. | **Boot halts completely.** Device halts execution or drops into bootloader/recovery mode. Operating system loading is BLOCKED. |

---

## 5. Rollback Protection Architecture

AVB provides anti-rollback protection to prevent downgrade attacks to older software versions containing known vulnerabilities.

1. **Rollback Index Numbers**: Every image signed with AVB includes a numeric Rollback Index (e.g. `1`, `2`, `3`).
2. **Hardware Storage**: Rollback location counters are stored in tamper-evident non-volatile storage managed by the Titan M2 secure element.
3. **Enforcement Rule**:
   - `Image_Rollback_Index >= Stored_Rollback_Index`: Boot succeeds.
   - If `Image_Rollback_Index > Stored_Rollback_Index`, bootloader updates Titan M2 stored counter to match.
   - `Image_Rollback_Index < Stored_Rollback_Index`: Boot **FAILS immediately** (RED state halt).

---

## 6. Pixel 8 (`shiba`) Custom Key Enrollment and Relocking

[Primary Source: AOSP Device State & Pixel Bootloader Documentation, https://source.android.com/docs/security/features/verifiedboot/device-state, Access Date: 2025-05-16, Confidence: VERIFIED]

### Key Enrollment Mechanics
- The Pixel 8 bootloader supports user enrollment of a custom AVB public key digest using the fastboot interface:
  `fastboot flash avb_custom_key <public_key_pkmd.bin>`
- The custom key binary (`pkmd.bin`) contains the raw AVB public key metadata (`AvbPublicKeyHeader` + key bytes).
- When the bootloader is subsequently locked (`fastboot flashing lock`), the SHA-256 hash of the custom key is stored in Titan M2 OTP/NVRAM memory.
- During boot, if a custom key is enrolled, the bootloader validates `vbmeta` against the enrolled custom key rather than the Google factory key.

### Erasing / Resetting Custom Key
- `fastboot erase avb_custom_key` clears the custom key digest from storage (requires bootloader to be in UNLOCKED state).

### Physical Verification Requirement
While Google Pixel devices officially support `fastboot flash avb_custom_key`, the exact behavior under Android 15 on `shiba` (such as specific Titan M2 attestation responses or error codes) requires physical verification on target hardware once the owner executes testing.

---

## 7. Gaps and Physical Verification Register

Every device-specific claim in this document is categorized by its verification status:

| Item ID | Claim / Hardware Feature | Primary Source | Confidence | Needs Physical Verification |
|---|---|---|---|---|
| `GAP-BOOT-001` | Tensor G3 PBL signature verification of SBL/ABL | AOSP Boot Overview | `VERIFIED` | Yes (hardware execution path) |
| `GAP-BOOT-002` | `fastboot flash avb_custom_key` success on Pixel 8 | AOSP Device State | `VERIFIED` | Yes (physical fastboot command execution) |
| `GAP-BOOT-003` | Relocking Pixel 8 bootloader with custom AVB key (`fastboot flashing lock`) | Pixel Developer Docs / AOSP | `REPORTED` | Yes (confirm no bootloop or brick on real device) |
| `GAP-BOOT-004` | Titan M2 rollback counter persistence across reflashing | Pixel Titan M2 Specs | `REPORTED` | Yes (physical downgrade attempt test) |
| `GAP-BOOT-005` | RED state boot halt behavior on partition tampering | AOSP Boot Flow Specs | `VERIFIED` | Yes (physical byte-tampering test) |
| `GAP-BOOT-006` | Titan M2 KeyMint attestation response in YELLOW state with custom key | AOSP KeyMint Specs | `REPORTED` | Yes (CTS / KeyMint attestation test) |

---

## 8. Primary Source Claims Summary Table

| Claim ID | Source Topic | Primary Source URL | Access Date | Confidence Level | Needs Physical Verification |
|---|---|---|---|---|---|
| `CLM-001` | AVB 2.0 Architecture & Descriptors | `https://source.android.com/docs/security/features/verifiedboot/avb` | 2025-05-16 | `VERIFIED` | No |
| `CLM-002` | Boot Flow States (GREEN, YELLOW, ORANGE, RED) | `https://source.android.com/docs/security/features/verifiedboot/boot-flow` | 2025-05-16 | `VERIFIED` | Yes |
| `CLM-003` | Custom Key Enrollment (`avb_custom_key`) | `https://source.android.com/docs/security/features/verifiedboot/device-state` | 2025-05-16 | `VERIFIED` | Yes |
| `CLM-004` | Anti-Rollback Index Enforcement | `https://source.android.com/docs/security/features/verifiedboot/boot-flow` | 2025-05-16 | `VERIFIED` | Yes |
| `CLM-005` | Titan M2 Security Hardware Coprocessor | `https://store.google.com/magazine/pixel_titan_m2` | 2025-05-16 | `REPORTED` | Yes |
