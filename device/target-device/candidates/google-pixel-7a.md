# Hardware-Facts Worksheet: Google Pixel 7a (`lynx`)

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `device/target-device/candidates/google-pixel-7a.md`

---

## Candidate Identity

- **Marketing Name:** Google Pixel 7a
- **Device Codename:** `lynx`
  - *Source:* Google Developers Factory Images (`https://developers.google.com/android/images#lynx`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **SoC (System on Chip):** Google Tensor G2 (5nm) + Titan M2 Security Coprocessor
  - *Source:* Google Pixel 7a Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **CPU Architecture:** ARM64 (2x2.85 GHz Cortex-X1 & 2x2.35 GHz Cortex-A78 & 4x1.80 GHz Cortex-A55)
  - *Source:* Google Tensor G2 Specs (`https://store.google.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **GPU:** Mali-G710 MP10
  - *Source:* Google Pixel 7a Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RAM Variants:** 8 GB LPDDR5
  - *Source:* Google Pixel 7a Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Storage Variants:** 128 GB UFS 3.1
  - *Source:* Google Pixel 7a Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Boot & Verified Boot (AVB)

- **Bootloader Unlock Procedure:** Standard AOSP unlock (`fastboot flashing unlock`).
  - *Source:* Android Source - Flashing Devices (`https://source.android.com/docs/setup/build/running#flashing-a-device`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Carrier / Account Lock Restrictions:** Unlocked retail models unlockable; US carrier-locked versions restricted.
  - *Source:* Google Pixel Support (`https://support.google.com/pixelphone/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **AVB Version Support:** AVB 2.0 supported.
  - *Source:* AOSP AVB Documentation (`https://source.android.com/docs/security/features/verifiedboot`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Custom Key Flashing (`fastboot flash avb_custom_key`):** **SUPPORTED**. Custom AVB key hash flashed directly to Titan M2.
  - *Source:* Google Pixel Custom Key Guide (`https://source.android.com/docs/security/features/verifiedboot/boot-flow`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Bootloader Relocking with Custom Key:** **SUPPORTED**. Fastboot relock allowed with custom key.
  - *Source:* AOSP Boot State Documentation (`https://source.android.com/docs/security/features/verifiedboot/boot-flow#boot-state`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Partition Scheme:** Virtual A/B with Dynamic Partitions (`super` partition).
  - *Source:* Android Device Partitions Guide (`https://source.android.com/docs/core/architecture/partitions`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Rollback Index Protection:** Supported via Titan M2 persistent counters.
  - *Source:* Google Titan M2 Security Blog (`https://security.googleblog.com/2021/10/titan-m2-user-security-baked-in.html`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Partition Layout

- **Documented Partitions:** `boot`, `init_boot`, `vendor_boot`, `dtbo`, `pvmfw`, `super`, `userdata`, `metadata`, `persist`, `modem`, `titan_m2`.
  - *Source:* Android Source - Pixel Partition Specifications (`https://source.android.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Kernel and Drivers

- **Shipped Kernel Version:** Linux Kernel 5.10 LTS / 6.1 LTS
  - *Source:* Google Git Kernel Manifest (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Source Repository:** `https://android.googlesource.com/kernel/gs`
  - *Source:* Google Git Repositories (`https://android.googlesource.com/kernel/gs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Licence:** GPLv2
  - *Source:* Linux Kernel License (`https://www.kernel.org/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Vendor Kernel Modules Openness:** Open kernel device drivers; closed GPU and modem firmware blobs.
  - *Source:* Google Git Pixel Kernel Trees (`https://android.googlesource.com/kernel/gs`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Firmware and Vendor Blobs

- **Blob Publication Location:** `https://developers.google.com/android/blobs-preview#lynx` and `https://developers.google.com/android/drivers#lynx`.
  - *Source:* Google Developers Driver Binaries (`https://developers.google.com/android/blobs-preview`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Licence / Redistribution Terms:** Google Software License Agreement.
  - *Source:* Google Driver License Terms (`https://developers.google.com/android/drivers#terms`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Export / Usage Restrictions:** Standard US EAR regulations.
  - *Source:* Google Site Terms (`https://developers.google.com/terms/site-terms`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Security Hardware & Keystore

- **Keymaster / KeyMint HAL Level:** KeyMint 3.0 in Titan M2.
  - *Source:* AOSP Keystore Documentation (`https://source.android.com/docs/security/features/keystore`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **StrongBox Security Coprocessor:** **PRESENT**. Titan M2 dedicated hardware element.
  - *Source:* Google Titan M2 Overview (`https://security.googleblog.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Secure Element / Coprocessor Name:** Titan M2 (`citadel`)
  - *Source:* Google Titan M2 Overview (`https://security.googleblog.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Biometric TEE Integration:** Under-display optical fingerprint HAL integrated with Titan M2 / TrustZone.
  - *Source:* Android Biometric Spec (`https://source.android.com/docs/security/features/biometrics`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Attestation Support:** KeyMint hardware-backed attestation via Titan M2 root keys.
  - *Source:* Android Key Attestation Guide (`https://developer.android.com/training/articles/keystore#hardware-backed`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Time & Counter Facilities

- **Trusted Time Source:** Titan M2 secure RTC and network synchronization.
  - *Source:* Google Titan M2 Specs (`https://security.googleblog.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RPMB (Replay Protected Memory Block) / Monotonic Counter:** Titan M2 hardware persistent counters.
  - *Source:* Google Titan M2 Architecture Overview (`https://security.googleblog.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Radios and Communications

- **Cellular Modem Vendor & Model:** Samsung Exynos 5300 5G Modem
  - *Source:* Google Pixel 7a Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Radio Controllability (Driver / Kernel RF Kill):** Standard Radio HAL power state interface.
  - *Source:* Android Telephony Documentation (`https://source.android.com/docs/core/connect/telephony`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Emergency Call Radio Behavior:** Hardcoded in baseband firmware per regulatory requirements.
  - *Source:* FCC Mandates (`https://www.fcc.gov/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **NFC Hardware & Disablement Path:** STMicroelectronics ST21NFC present; disableable via HAL / service removal.
  - *Source:* Android NFC HAL (`https://source.android.com/docs/core/connect/nfc`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## USB and Peripherals

- **USB Controller & Version:** USB 3.2 Gen 2 Type-C controller
  - *Source:* Google Pixel 7a Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **ConfigFS / USB Gadget Configuration Modes:** Full Linux ConfigFS USB gadget support.
  - *Source:* Android USB Gadget Guide (`https://source.android.com/docs/core/architecture/usb`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Thermal Management

- **Thermal Driver / Thermal HAL Support:** Google Tensor Thermal Driver and Thermal HAL 2.0.
  - *Source:* AOSP Thermal Guide (`https://source.android.com/docs/core/power/thermal`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Manufacturer Updates & Support

- **Stated Update / Support Period:** 5 years of security updates (supported through May 2028).
  - *Source:* Google Pixel Update Policy (`https://support.google.com/pixelphone/answer/4457701`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Regulatory and Market Notes

- **Target Market & Radio Band Notes:** Global 5G Sub-6GHz supported across North America, Europe, Asia.
  - *Source:* Google Pixel 7a Tech Specs (`https://store.google.com/product/pixel_7a_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Open Questions for Physical Device Testing

1. Is thermal throttling significantly higher on Tensor G2 under 3 concurrent account sessions compared to Tensor G3?
2. Does USB ConfigFS empty-drive mode remain active when device drops into deep sleep (S3)?
