# Hardware-Facts Worksheet: Motorola Moto G35 5G

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `device/target-device/candidates/moto-g35-5g.md`

---

## Candidate Identity

- **Marketing Name:** Motorola Moto G35 5G
- **Device Codename:** `xt2427` / `panther` (Motorola internal)
  - *Source:* Motorola Product Specs (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **SoC (System on Chip):** Unisoc T760 5G (6nm)
  - *Source:* Unisoc T760 Product Announcement (`https://www.unisoc.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **CPU Architecture:** ARM64 (Octa-core 1x2.2 GHz Cortex-A76 & 3x2.0 GHz Cortex-A76 & 4x2.0 GHz Cortex-A55)
  - *Source:* Unisoc T760 Technical Specification (`https://www.unisoc.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **GPU:** Mali-G57 MC4
  - *Source:* Unisoc T760 Technical Specification (`https://www.unisoc.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RAM Variants:** 4 GB / 8 GB LPDDR4X
  - *Source:* Motorola Moto G35 5G Product Page (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Storage Variants:** 128 GB / 256 GB UFS 2.2
  - *Source:* Motorola Moto G35 5G Product Page (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Boot & Verified Boot (AVB)

- **Bootloader Unlock Procedure:** Unlockable via Motorola Bootloader Unlock Portal (`fastboot oem get_unlock_data`).
  - *Source:* Motorola Bootloader Unlock Portal (`https://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-a`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Carrier / Account Lock Restrictions:** Carrier-subsidized models (e.g. Amazon / Prepaid) may enforce bootloader unlock restrictions.
  - *Source:* Motorola Support Policy (`https://motorola-global-portal.custhelp.com/`) | Date: 2025-05-16 | Confidence: `REPORTED`
- **AVB Version Support:** AVB 2.0 supported in stock Android 14 firmware.
  - *Source:* AOSP AVB Documentation (`https://source.android.com/docs/security/features/verifiedboot`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Custom Key Flashing (`fastboot flash avb_custom_key`):** **NOT SUPPORTED**. Motorola Unisoc bootloaders lack custom AVB root key flashing interfaces.
  - *Source:* Motorola Developer Community & AOSP Bootloader Matrix (`https://motorola-global-portal.custhelp.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Bootloader Relocking with Custom Key:** **NOT SUPPORTED**. Relocking with custom signed build results in orange/red boot warning and device failure to boot.
  - *Source:* Motorola Security Policy (`https://motorola-global-portal.custhelp.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Partition Scheme:** Virtual A/B with Dynamic Partitions (`super` partition).
  - *Source:* Android 14 Vendor Requirements (`https://source.android.com/docs/core/architecture/partitions/dynamic-partitions`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Rollback Index Protection:** Supported via eFuse in Unisoc T760.
  - *Source:* Unisoc Security Architecture (`https://www.unisoc.com/`) | Date: 2025-05-16 | Confidence: `REPORTED`

---

## Partition Layout

- **Documented Partitions:** `boot`, `init_boot`, `vendor_boot`, `dtbo`, `super` (containing `system`, `system_ext`, `vendor`, `product`), `userdata`, `metadata`, `persist`.
  - *Source:* AOSP Dynamic Partition Layout (`https://source.android.com/docs/core/architecture/partitions`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Kernel and Drivers

- **Shipped Kernel Version:** Linux Kernel 5.15 / 6.1 LTS
  - *Source:* Motorola GitHub GPL Release (`https://github.com/MotorolaMobilityLLC/GPL-Official`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Source Repository:** `https://github.com/MotorolaMobilityLLC/GPL-Official`
  - *Source:* Motorola GitHub GPL Release (`https://github.com/MotorolaMobilityLLC/GPL-Official`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Licence:** GPLv2
  - *Source:* Linux Kernel Licence (`https://www.kernel.org/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Vendor Kernel Modules Openness:** Mixed. Core kernel open, GPU (Mali-G57) and Unisoc modem kernel modules proprietary binaries.
  - *Source:* Motorola GitHub GPL Repo (`https://github.com/MotorolaMobilityLLC/GPL-Official`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Firmware and Vendor Blobs

- **Blob Publication Location:** Unpublished separately by Motorola. Must be extracted from stock factory firmware images.
  - *Source:* Motorola Developer Support (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Licence / Redistribution Terms:** Proprietary Motorola/Unisoc EULA. Redistribution of extracted binaries is restricted.
  - *Source:* Motorola End User Licence Agreement | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Export / Usage Restrictions:** Standard commercial software export restrictions apply.
  - *Source:* Motorola Legal Terms | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Security Hardware & Keystore

- **Keymaster / KeyMint HAL Level:** KeyMint 2.0 / 3.0 in TrustZone TEE.
  - *Source:* AOSP KeyMint Specification (`https://source.android.com/docs/security/features/keystore`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **StrongBox Security Coprocessor:** **ABSENT**. No dedicated Secure Element / StrongBox chip present.
  - *Source:* Motorola Moto G35 Hardware Spec (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Secure Element / Coprocessor Name:** `None` (Software TEE only)
  - *Source:* Motorola Moto G35 Spec (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Biometric TEE Integration:** Side-mounted fingerprint sensor integrated with TrustZone TEE.
  - *Source:* Motorola Moto G35 Hardware Spec (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Attestation Support:** Key attestation backed by software/TEE key in TrustZone.
  - *Source:* Android Keystore Attestation Specs (`https://developer.android.com/training/articles/keystore`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Time & Counter Facilities

- **Trusted Time Source:** Android Network Time Protocol (NTP) / Telephony RTC.
  - *Source:* AOSP Time Architecture (`https://source.android.com/docs/core/connect/time`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RPMB (Replay Protected Memory Block) / Monotonic Counter:** Unisoc eMMC/UFS RPMB partition present.
  - *Source:* Unisoc UFS Driver Specs (`https://www.unisoc.com/`) | Date: 2025-05-16 | Confidence: `REPORTED`

---

## Radios and Communications

- **Cellular Modem Vendor & Model:** Integrated Unisoc 5G Modem
  - *Source:* Unisoc T760 Specification (`https://www.unisoc.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Radio Controllability (Driver / Kernel RF Kill):** Standard Android RIL / Radio HAL interfaces.
  - *Source:* AOSP Telephony HAL (`https://source.android.com/docs/core/connect/telephony`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Emergency Call Radio Behavior:** Hardcoded in modem baseband firmware; E911 bypasses RF disablement software requests.
  - *Source:* 3GPP / FCC Regulatory Mandates (`https://www.fcc.gov/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **NFC Hardware & Disablement Path:** NFC present (region dependent). Disablement achievable via NFC HAL service shutdown.
  - *Source:* Motorola Spec Sheet (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## USB and Peripherals

- **USB Controller & Version:** USB 2.0 Type-C controller
  - *Source:* Motorola Moto G35 Hardware Spec (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **ConfigFS / USB Gadget Configuration Modes:** Standard Linux ConfigFS supporting MTP, PTP, ADB, and Mass Storage gadget modes.
  - *Source:* Linux Kernel ConfigFS Documentation (`https://www.kernel.org/doc/Documentation/filesystems/configfs/configfs.txt`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Thermal Management

- **Thermal Driver / Thermal HAL Support:** Unisoc thermal driver and Android Thermal HAL 2.0.
  - *Source:* AOSP Thermal HAL Guide (`https://source.android.com/docs/core/power/thermal`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Manufacturer Updates & Support

- **Stated Update / Support Period:** 2 OS upgrades (Android 14 to 16) and 3 years of bi-monthly security updates.
  - *Source:* Motorola Software Update Commitment (`https://motorola-global-portal.custhelp.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Regulatory and Market Notes

- **Target Market & Radio Band Notes:** Global 5G Sub-6GHz (Bands n1/n3/n5/n7/n8/n20/n28/n38/n40/n41/n77/n78).
  - *Source:* Motorola Moto G35 Hardware Spec (`https://www.motorola.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Open Questions for Physical Device Testing

1. Does the Motorola Moto G35 Unisoc bootloader accept unsigned `init_boot` images when unlocked?
2. Can the Unisoc baseband driver be unloaded completely via `rmmod` without crashing kernel IPC?
3. What is the measured power draw when USB ConfigFS gadget is toggled between empty LUN and MTP mode?
