Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.2, 3.3, 14.2, 14.3, 17.6

# DeeX Boot — Threat Model & Attack Surface Analysis

## 1. Overview and Asset Definitions

This document details threat scenarios targeting the **DeeX Boot** chain, bootloader, kernel loading process, and firmware update mechanisms.

### Primary Assets Targeted
- **System Partition Integrity**: Kernel, system binaries, and DeeX security daemons (`system/deex/*`).
- **Chain of Trust Root**: Hardware Root of Trust public key digest stored in Titan M2.
- **Rollback Index Counters**: Monotonic anti-rollback state stored in secure storage.
- **Release Signing Keys**: Private key material used to sign `vbmeta` and OTA packages.

---

## 2. Boot Threat Matrix (`TM-BOOT-` Entries)

| Threat ID | Threat Actor & Scenario | Asset Targeted | Attack Vector | Existing Design Mitigation | Residual Risk | Hardware Dependency & Verification Status |
|---|---|---|---|---|---|---|
| **`TM-BOOT-001`** | Physical attacker writes malicious `system.img` or `boot.img` over USB/fastboot. | System Partition Integrity | Direct flash write via fastboot on lost/stolen device. | **`BOOT-001`**, **`BOOT-002`**, **`BOOT-006`**: Locked bootloader rejects unauthenticated images; AVB halts boot (RED state). | Minimal if bootloader is LOCKED. If device is UNLOCKED, state is ORANGE. | Requires physical verification of boot halt on Pixel 8 (`GAP-BOOT-005`). |
| **`TM-BOOT-002`** | Malicious OTA update package downgrade attempt. | System Partition & Security State | Attacker sends older signed OTA release containing known unpatched vulnerability. | **`BOOT-001`**, Update Trust Spec Section 3: Titan M2 compares $R_{img} < R_{hw}$ and halts boot. | Zero if Titan M2 NVRAM rollback index is updated properly. | Requires physical verification of Titan M2 rollback enforcement (`GAP-BOOT-004`). |
| **`TM-BOOT-003`** | Compromised build host / insider tampered build artifact. | Build Pipeline & Release Binaries | Malicious binary injected into `out/` during compilation. | **`BOOT-008`**, Key Hierarchy Spec: Dual-build reproducibility checks (`compare-builds.sh`) and offline signing ceremony. | Dependency on developer host cleanliness prior to offline signing. | Verified via build reproducibility procedure. |
| **`TM-BOOT-004`** | Compromise or theft of release signing key material. | Global System Trust Chain | Exfiltration of `deex-release-key-avb` private key. | Key Hierarchy Spec Section 3: Air-gapped LUKS key storage, offsite encrypted backup, sole owner authorization. | Single-person authorization risk; loss of key prevents official updates. | Administrative procedure protection. |
| **`TM-BOOT-005`** | Malicious modification of `/system` block storage at runtime. | Operating System Runtime Integrity | Root privilege exploit or direct memory write to block device. | **`BOOT-003`**: Kernel `dm-verity` driver verifies hashtree blocks continuously; corruption triggers panic/reboot. | Read-only partition enforcement prevents persistence across reboot. | Standard AOSP kernel capability. |
| **`TM-BOOT-006`** | Recovery path account authentication bypass. | User Data & Account Credentials | Booting custom recovery image to attempt password/encryption bypass. | **`BOOT-001`**, **`BOOT-006`**, Update Trust Spec Section 5: Recovery enforces exact same AVB policy; factory wipe erases keys. | Wiping storage destroys data cryptographically; no plaintext exposure. | Requires physical verification on hardware (`GAP-BOOT-002`). |
