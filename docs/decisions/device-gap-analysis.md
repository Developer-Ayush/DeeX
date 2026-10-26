# DeeX Device Gap Analysis Matrix

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `docs/decisions/device-gap-analysis.md`

---

## 1. Overview

This document presents a technical gap analysis comparing the four evaluated hardware candidates against the core requirements specified in **DeeX Master Development Plan v1.0 Section 1.2** and **Chunk 2 Prompt Section 3**.

Capability support for each requirement is categorized into four explicit levels:
- **(a) Supported with Evidence:** Verified primary documentation demonstrates complete hardware/AOSP support.
- **(b) Might Support (Pending Physical Test):** Hardware capability exists, but physical testing is required to confirm software integration.
- **(c) Not Shown to Support:** No documented evidence exists demonstrating hardware or HAL capability.
- **(d) Cannot Support:** Hardware or firmware constraints permanently prevent compliance.

---

## 2. Requirement Gap Analysis Matrix

| Requirement Ref & Description | Motorola Moto G35 5G | Google Pixel 8 (`shiba`) | Google Pixel 7a (`lynx`) | Fairphone 5 (`FP5`) |
|---|---|---|---|---|
| **R1. Target ARM64 Hardware Execution** (Master Plan 1.2) | (a) Supported (Unisoc T760 ARM64) | (a) Supported (Tensor G3 ARM64) | (a) Supported (Tensor G2 ARM64) | (a) Supported (QCM6490 ARM64) |
| **R2. AVB Custom Key & Relock** (Master Plan 3) | **(d) Cannot Support** *(No custom AVB key interface)* | (a) Supported *(Titan M2 custom AVB key)* | (a) Supported *(Titan M2 custom AVB key)* | (a) Supported *(Qualcomm fastboot custom AVB key)* |
| **R3. Kernel & Driver Source Openness** (Master Plan 2.2, 4) | (b) Might Support *(Mixed vendor GPL)* | (a) Supported *(Google Git AOSP trees)* | (a) Supported *(Google Git AOSP trees)* | (a) Supported *(Fairphone GitHub trees)* |
| **R4. Vendor Blobs Redistribution Terms** (Master Plan 2.2, 2.3) | (c) Not Shown to Support *(Proprietary EULA)* | (a) Supported *(Google Driver Terms)* | (a) Supported *(Google Driver Terms)* | (b) Might Support *(Qualcomm non-commercial)* |
| **R5. Hardware Key Storage (KeyMint/StrongBox)** (Master Plan 5.3) | (c) Not Shown to Support *(No StrongBox/SE)* | (a) Supported *(Titan M2 StrongBox EAL6+)* | (a) Supported *(Titan M2 StrongBox EAL6+)* | (b) Might Support *(Qualcomm SPU KeyMint)* |
| **R6. Per-Account Independent Key Hierarchies** (Master Plan 5.3, 5.4) | (b) Might Support | (b) Might Support *(Requires DeeX Vault HAL extension)* | (b) Might Support *(Requires DeeX Vault HAL extension)* | (b) Might Support *(Requires DeeX Vault HAL extension)* |
| **R7. Secure Biometric Subsystem & Retry Counter** (Master Plan 6.7) | (c) Not Shown to Support *(Software counter)* | (a) Supported *(Titan M2 TEE hardware counter)* | (a) Supported *(Titan M2 TEE hardware counter)* | (b) Might Support *(Qualcomm TrustZone counter)* |
| **R8. Tamper-Resistant Monotonic Time / Counter** (Master Plan 6.6) | (c) Not Shown to Support *(Standard RTC)* | (a) Supported *(Titan M2 persistent monotonic counter)* | (a) Supported *(Titan M2 persistent monotonic counter)* | (b) Might Support *(Qualcomm RPMB counter)* |
| **R9. Radio Cut-off / External Isolation** (Master Plan 9.7, 9.8) | (b) Might Support *(Kernel RF kill)* | (b) Might Support *(Kernel/Driver sysfs power)* | (b) Might Support *(Kernel/Driver sysfs power)* | (b) Might Support *(Kernel RF kill)* |
| **R10. Mandated Emergency Calling Behavior** (Master Plan 9.8) | (a) Supported *(Hardcoded E911)* | (a) Supported *(Hardcoded E911)* | (a) Supported *(Hardcoded E911)* | (a) Supported *(Hardcoded E911)* |
| **R11. USB Empty-Drive ConfigFS Control** (Master Plan 10) | (b) Might Support *(Linux ConfigFS)* | (b) Might Support *(Linux ConfigFS)* | (b) Might Support *(Linux ConfigFS)* | (b) Might Support *(Linux ConfigFS)* |
| **R12. Multi-Account RAM & CPU Capacity** (Master Plan 4.3, 7.5) | (b) Might Support *(8GB LPDDR4X)* | (a) Supported *(8GB LPDDR5X + Tensor G3)* | (a) Supported *(8GB LPDDR5 + Tensor G2)* | (b) Might Support *(8GB LPDDR4X)* |
| **R13. Hardware Crypto Acceleration (FBE)** (Master Plan 5.2) | (a) Supported *(ARMv8 CE)* | (a) Supported *(Tensor ICE AES-256-XTS)* | (a) Supported *(Tensor ICE AES-256-XTS)* | (a) Supported *(Qualcomm ICE AES-XTS)* |
| **R14. Android CTS Feasibility** (Master Plan 13.2) | (c) Not Shown to Support | (a) Supported *(First-party AOSP target)* | (a) Supported *(First-party AOSP target)* | (b) Might Support *(LineageOS / Open trees)* |
| **R15. GMS Licensing Eligibility** (Master Plan 11.4, 13.1) | (c) Not Shown (`UNKNOWN — decision required`) | (c) Not Shown (`UNKNOWN — decision required`) | (c) Not Shown (`UNKNOWN — decision required`) | (c) Not Shown (`UNKNOWN — decision required`) |

---

## 3. Analysis of Hardest DeeX Requirements vs. Hardware Reality

### 1. Tamper-Resistant Lockout Timers (6.6) & Hardware Biometric Retry Limits (6.7)
- **Hardware Reality:** Operating system reboot resets ordinary kernel system uptime counters. Software clock manipulation (e.g. rolling back network time or RTC) can easily bypass software lockout timers.
- **Candidate Evaluation:**
  - **Pixel 8 & Pixel 7a (Titan M2):** Google's Titan M2 Secure Element provides hardware persistent monotonic counters stored in tamper-proof non-volatile memory. Titan M2 increments counters via KeyMint HAL RPCs that survive hard reboot, battery removal, and factory reset.
  - **Fairphone 5 (Qualcomm SPU):** Qualcomm QCM6490 uses UFS RPMB (Replay Protected Memory Block) partitions key-bound to eFuse keys. While tamper-resistant, corrupting the RPMB key during forced power loss can brick access.
  - **Motorola Moto G35:** Lacks a dedicated secure element; lockout counters rely on ordinary software state stored in `userdata`, which can be reset or manipulated if bootloader is unlocked.

### 2. External Isolation Radio Cut-off (9.7, 9.8) vs. Mandated Emergency Calling (E911)
- **Hardware Reality:** Master Plan 9.7 requires cutting cellular, Wi-Fi, Bluetooth, and GPS at the driver/hardware level when external isolation is turned OFF. However, regulatory frameworks (FCC in US, ETSI in EU) require mobile phone baseband processors to enforce Emergency Calling (E911) even when SIM is removed or radios are requested off by software.
- **Candidate Evaluation:**
  - Baseband radio firmware on all candidate devices (Samsung Exynos 5300 on Pixels, Qualcomm 5G modem on Fairphone 5, Unisoc modem on Moto G35) runs closed-source RTOS code on a separate ARM/DSP core.
  - While DeeX can unbind kernel driver interfaces (`sysfs` RF kill / driver unbind) to block OS access to radios, **the physical modem hardware cannot be completely powered down if the power rails are shared**. Emergency calls initiated via hardware triggers (e.g., long-press power button) will bypass OS driver cut-off and activate baseband radio transmit circuits.
  - **Risk Record:** DeeX must document that software RF kill unbinds driver communications but cannot alter baseband RTOS regulatory emergency call overrides.

### 3. Per-Account Key Hierarchies with Hardware Keystore (5.3, 5.4)
- **Hardware Reality:** Standard Android KeyMint / Keymaster HAL supports device-level key wrapping and per-user keys bound to Android User IDs (e.g. `UserHandle.USER_SYSTEM`, `UserHandle 10+`).
- **Candidate Evaluation:**
  - **Pixel 8 & Pixel 7a:** Titan M2 natively supports KeyMint key wrapping where master keys can be derived using credential-bound HKDF inputs passed to Titan M2.
  - **Fairphone 5 & Moto G35:** Support standard Android FBE (File-Based Encryption) CE/DE key derivation, but multi-tenant credential binding requires custom DeeX Vault HAL wrappers to prevent cross-account key derivation leaks.

### 4. Custom Signed OS Compatibility with Google Play Integrity & CTS (13.3, 13.4)
- **Hardware Reality:** Google Play Integrity API performs hardware-backed remote attestation. When an AOSP build is booted with a custom AVB key on a relocked bootloader:
  - Hardware attestation returns `MEETS_BASIC_INTEGRITY` = True.
  - Hardware attestation returns `MEETS_DEVICE_INTEGRITY` = True (if device build fingerprint matches certified baseline).
  - Hardware attestation returns `MEETS_STRONG_INTEGRITY` = False (or conditional), because the custom AVB root public key hash differs from Google's factory bootloader certificate.
- **Risk Record:** Operating a custom security OS like DeeX will trigger Play Integrity hardware attestation flags for high-security banking and payment apps. This must be recorded as a inherent architecture risk, not a solvable software bug.
