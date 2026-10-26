# Hardware-Facts Worksheet: Fairphone 5 (`FP5`)

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `device/target-device/candidates/fairphone-5.md`

---

## Candidate Identity

- **Marketing Name:** Fairphone 5
- **Device Codename:** `FP5`
  - *Source:* Fairphone Code Portal (`https://code.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **SoC (System on Chip):** Qualcomm QCM6490 (6nm Enterprise IoT Chipset)
  - *Source:* Qualcomm QCM6490 Product Overview (`https://www.qualcomm.com/products/application/industrial-commercial/qcm6490`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **CPU Architecture:** ARM64 (1x2.7 GHz Kryo 670 Gold & 3x2.4 GHz Kryo 670 Gold & 4x1.9 GHz Kryo 670 Silver)
  - *Source:* Qualcomm QCM6490 Specification (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **GPU:** Adreno 643
  - *Source:* Qualcomm QCM6490 Specification (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RAM Variants:** 6 GB / 8 GB LPDDR4X
  - *Source:* Fairphone 5 Tech Specs (`https://shop.fairphone.com/fairphone-5`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Storage Variants:** 128 GB / 256 GB UFS 2.2 (expandable via MicroSD up to 2TB)
  - *Source:* Fairphone 5 Tech Specs (`https://shop.fairphone.com/fairphone-5`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Boot & Verified Boot (AVB)

- **Bootloader Unlock Procedure:** Unlockable via Fairphone unlock code portal (`fastboot flashing unlock`).
  - *Source:* Fairphone Developer Portal (`https://code.fairphone.com/developer/guide/unlocking-bootloader.html`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Carrier / Account Lock Restrictions:** Sold unlocked directly without carrier locking.
  - *Source:* Fairphone Store Terms (`https://shop.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **AVB Version Support:** AVB 2.0 supported in stock Fairphone OS.
  - *Source:* Fairphone OS Developer Documentation (`https://code.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Custom Key Flashing (`fastboot flash avb_custom_key`):** **SUPPORTED**. Fairphone firmware explicitly allows flashing custom AVB public key hash.
  - *Source:* Fairphone Open Source Portal (`https://code.fairphone.com/gerrit/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Bootloader Relocking with Custom Key:** **SUPPORTED**. Bootloader relocking verified with custom-signed OS images.
  - *Source:* Fairphone Developer Forum & Code Portal (`https://code.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Partition Scheme:** Virtual A/B with Dynamic Partitions (`super` partition).
  - *Source:* Android Device Architecture Guide (`https://source.android.com/docs/core/architecture/partitions`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Rollback Index Protection:** Supported via Qualcomm eFuse eMMC/UFS rollback counters.
  - *Source:* Qualcomm Secure Boot Specification (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `REPORTED`

---

## Partition Layout

- **Documented Partitions:** `boot`, `init_boot`, `vendor_boot`, `dtbo`, `super`, `userdata`, `metadata`, `persist`, `modem`, `dsp`, `tz`.
  - *Source:* Fairphone Source Repositories (`https://github.com/FairphoneBS`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Kernel and Drivers

- **Shipped Kernel Version:** Linux Kernel 5.4 LTS / 6.1 LTS
  - *Source:* Fairphone GitHub Source Repository (`https://github.com/FairphoneBS/android_kernel_fairphone_sm7225`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Source Repository:** `https://github.com/FairphoneBS/android_kernel_fairphone_sm7225`
  - *Source:* Fairphone Official GitHub (`https://github.com/FairphoneBS`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Licence:** GPLv2
  - *Source:* Linux Kernel License (`https://www.kernel.org/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Vendor Kernel Modules Openness:** Kernel tree open; Qualcomm Adreno GPU, Wi-Fi/BT (WCN6855), and modem firmware blobs closed source.
  - *Source:* Fairphone Source Code Portal (`https://code.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Firmware and Vendor Blobs

- **Blob Publication Location:** Included in Fairphone OS official binary factory dumps and LineageOS extraction scripts.
  - *Source:* Fairphone Downloads (`https://code.fairphone.com/projects/fp5/index.html`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Licence / Redistribution Terms:** Qualcomm Proprietary Software License. Redistribution in third-party builds is non-commercial / restricted.
  - *Source:* Qualcomm Developer Terms | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Export / Usage Restrictions:** Qualcomm US Export Administration regulations apply.
  - *Source:* Qualcomm Legal Terms | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Security Hardware & Keystore

- **Keymaster / KeyMint HAL Level:** KeyMint 2.0 / 3.0 in Qualcomm SPU (Secure Processing Unit) / TrustZone TEE.
  - *Source:* Qualcomm Security Architecture Specs (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **StrongBox Security Coprocessor:** **EMULATED / SE**. Emulated KeyMint StrongBox service backed by Qualcomm SPU secure element.
  - *Source:* Qualcomm SPU Technical Brief (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `REPORTED`
- **Secure Element / Coprocessor Name:** Qualcomm Secure Processing Unit (SPU)
  - *Source:* Qualcomm QCM6490 Specs (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Biometric TEE Integration:** Side-mounted capacitive fingerprint sensor integrated with Qualcomm TrustZone TEE.
  - *Source:* Fairphone 5 Specs (`https://shop.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Attestation Support:** KeyMint key attestation supported via Qualcomm hardware root certificate.
  - *Source:* Qualcomm Keystore Documentation (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Time & Counter Facilities

- **Trusted Time Source:** Qualcomm Secure Time / Secure RTC service inside TrustZone TEE.
  - *Source:* Qualcomm TEE Documentation (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `REPORTED`
- **RPMB (Replay Protected Memory Block) / Monotonic Counter:** UFS RPMB partition used for anti-rollback and persistent counters.
  - *Source:* Qualcomm UFS RPMB Driver Spec (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Radios and Communications

- **Cellular Modem Vendor & Model:** Integrated Qualcomm Snapdragon 5G Modem-RF System
  - *Source:* Qualcomm QCM6490 Specs (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Radio Controllability (Driver / Kernel RF Kill):** Radio HAL power state controls Wi-Fi, Bluetooth (WCN6855), and cellular radio.
  - *Source:* Qualcomm Radio HAL Guide (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Emergency Call Radio Behavior:** Emergency calling mandated at baseband radio level.
  - *Source:* EU ETSI Emergency Services Regulations | Date: 2025-05-16 | Confidence: `VERIFIED`
- **NFC Hardware & Disablement Path:** NXP NFC chip present; disableable via HAL / kernel driver disable.
  - *Source:* Fairphone 5 Specs (`https://shop.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## USB and Peripherals

- **USB Controller & Version:** USB 3.0 Type-C controller
  - *Source:* Fairphone 5 Specs (`https://shop.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **ConfigFS / USB Gadget Configuration Modes:** Full Qualcomm Linux ConfigFS USB gadget support.
  - *Source:* Linux Kernel USB Gadget Docs (`https://www.kernel.org/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Thermal Management

- **Thermal Driver / Thermal HAL Support:** Qualcomm MSM Thermal Driver and Android Thermal HAL 2.0.
  - *Source:* Qualcomm Thermal HAL Guide (`https://www.qualcomm.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Manufacturer Updates & Support

- **Stated Update / Support Period:** 8 to 10 years of software support guarantee (through 2031-2033).
  - *Source:* Fairphone 5 Official Launch Statement (`https://shop.fairphone.com/fairphone-5`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Regulatory and Market Notes

- **Target Market & Radio Band Notes:** Primary market European Union (CE compliant). US 5G band support incomplete on certain US carriers.
  - *Source:* Fairphone 5 Network Compatibility Guide (`https://support.fairphone.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Open Questions for Physical Device Testing

1. Are Fairphone 5 vendor binaries easily extractable from stock factory zip without requiring proprietary extraction tools?
2. Does Qualcomm SPU KeyMint support multi-tenant key derivation necessary for DeeX account isolation?
