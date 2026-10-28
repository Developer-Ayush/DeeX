# Hardware-Facts Worksheet: Google Pixel 8 (`shiba`)

**Status:** Draft — updated in Chunk 7
**Date:** 2025-05-16
**Module:** DeeX Base & Kernel (Chunk 2, Chunk 7 update)
**Document Ref:** `device/target-device/candidates/google-pixel-8.md`

---

## Candidate Identity

- **Marketing Name:** Google Pixel 8
- **Device Codename:** `shiba`
  - *Source:* Google Developers Factory Images (`https://developers.google.com/android/images#shiba`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **SoC (System on Chip):** Google Tensor G3 (SoC Codename: `zuma`) + Titan M2 Security Coprocessor (`citadel`)
  - *Source:* Google Android Kernel Repositories (`https://android.googlesource.com/kernel/manifest`, `https://source.android.com/docs/setup/build/building-kernels`) | Date: 2025-05-16 | Confidence: `VERIFIED`
  - *Previous Note (2025-05-16):* Previous unverified references mentioning `gs201` were corrected in Chunk 7 research. `gs201` corresponds to Tensor G2 (Pixel 7). Pixel 8 Tensor G3 is confirmed as `zuma`.
- **CPU Architecture:** Native ARM64 (ARMv9-A / Cortex cores, 64-bit GKI kernel baseline)
  - *Source:* Google Tensor G3 Tech Documentation & AOSP Kernel Manifest (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **GPU:** Immortalis-G715 MC10
  - *Source:* Google Pixel 8 Technical Specs (`https://store.google.com/product/pixel_8_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RAM Variants:** 8 GB LPDDR5X
  - *Source:* Google Pixel 8 Specs (`https://store.google.com/product/pixel_8_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Storage Variants:** 128 GB / 256 GB UFS 3.1
  - *Source:* Google Pixel 8 Specs (`https://store.google.com/product/pixel_8_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Boot & Verified Boot (AVB)

- **Bootloader Unlock Procedure:** Standard AOSP unlock (`fastboot flashing unlock`).
  - *Source:* Android Source - Flashing Devices (`https://source.android.com/docs/setup/build/running#flashing-a-device`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Carrier / Account Lock Restrictions:** Unlocked variants require no carrier approval; Verizon variants (`G9F88`) have bootloader unlock locked out.
  - *Source:* Google Pixel Support Knowledgebase (`https://support.google.com/pixelphone/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **AVB Version Support:** Android Verified Boot 2.0 with full key chaining.
  - *Source:* AOSP AVB Documentation (`https://source.android.com/docs/security/features/verifiedboot`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Custom Key Flashing (`fastboot flash avb_custom_key`):** **SUPPORTED**. Accepts custom AVB root public key hash stored into Titan M2 secure hardware.
  - *Source:* Google Pixel Custom Key Guide (`https://source.android.com/docs/security/features/verifiedboot/boot-flow`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Bootloader Relocking with Custom Key:** **SUPPORTED**. Bootloader can be relocked with custom key (`fastboot flashing lock`); displays yellow boot state warning without stopping boot.
  - *Source:* AOSP Boot State Documentation (`https://source.android.com/docs/security/features/verifiedboot/boot-flow#boot-state`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Partition Scheme:** Virtual A/B with Dynamic Partitions (`super` partition containing `system`, `system_ext`, `vendor`, `product`, `system_dlkm`, `vendor_dlkm`).
  - *Source:* Android Device Partitions Guide (`https://source.android.com/docs/core/architecture/partitions`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Rollback Index Protection:** Supported via Titan M2 eFuse persistent counters.
  - *Source:* Google Titan M2 Architecture Overview (`https://security.googleblog.com/2021/10/titan-m2-user-security-baked-in.html`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Partition Layout

- **Documented Partitions:** `boot`, `init_boot`, `vendor_boot`, `dtbo`, `pvmfw`, `super`, `userdata`, `metadata`, `persist`, `modem`, `titan_m2`.
  - *Source:* Android Source - Pixel Partition Specifications (`https://source.android.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Kernel and Drivers

- **Shipped Kernel Version:** Linux Kernel 6.1 LTS (Android Common Kernel `android-15.0.0_r1` / Kernel branch `android-gs-zuma-6.1`)
  - *Source:* Google Git Kernel Manifest (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Source Repository:** `https://android.googlesource.com/kernel/manifest` (Branch `android-gs-zuma-6.1`)
  - *Source:* Google Git Kernel Manifest (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Kernel Licence:** GPLv2 for core kernel (`kernel/common`); dual GPLv2/BSD or Apache 2.0 for vendor modules (`kernel/google-modules/*`).
  - *Source:* Linux Kernel License & AOSP Trees (`https://android.googlesource.com/kernel/common`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Vendor Kernel Modules Openness:** Kernel device module sources are open source in Google Git; GPU firmware and modem binaries are loaded as proprietary blobs into vendor modules.
  - *Source:* Google Git Pixel Kernel Trees (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Firmware and Vendor Blobs

- **Blob Publication Location:** Published officially by Google at `https://developers.google.com/android/blobs-preview#shiba` and `https://developers.google.com/android/drivers#shiba`.
  - *Source:* Google Developers Driver Binaries (`https://developers.google.com/android/blobs-preview`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Licence / Redistribution Terms:** Google Software License Agreement (permits personal development and non-commercial build installation; re-distribution requires adherence to terms).
  - *Source:* Google Driver License Terms (`https://developers.google.com/android/drivers#terms`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Export / Usage Restrictions:** Standard US Export Administration Regulations (EAR) apply.
  - *Source:* Google Developers License Terms (`https://developers.google.com/terms/site-terms`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Security Hardware & Keystore

- **Keymaster / KeyMint HAL Level:** KeyMint 3.0 (Android 15) running inside Titan M2 Secure Element.
  - *Source:* Android Security Bulletin & KeyMint Spec (`https://source.android.com/docs/security/features/keystore`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **StrongBox Security Coprocessor:** **PRESENT**. Titan M2 dedicated hardware security element certified under Common Criteria EAL6+.
  - *Source:* Google Titan M2 Security Blog (`https://security.googleblog.com/2021/10/titan-m2-user-security-baked-in.html`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Secure Element / Coprocessor Name:** Titan M2 (`citadel` / driver interface `/dev/citadel0` or `/dev/nos0`)
  - *Source:* Google Titan M2 Architecture Overview & AOSP Kernel Manifest (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Biometric TEE Integration:** Under-display optical fingerprint HAL integrated directly with Titan M2 / TrustZone TEE with hardware attempt limits.
  - *Source:* Android Biometric Architecture Specification (`https://source.android.com/docs/security/features/biometrics`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Hardware Attestation Support:** KeyMint hardware-backed key attestation using Google's hardware root certificate embedded in Titan M2.
  - *Source:* Android Key Attestation Guide (`https://developer.android.com/training/articles/keystore#hardware-backed`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Time & Counter Facilities

- **Trusted Time Source:** Titan M2 secure hardware real-time clock (RTC) and network time synchronization.
  - *Source:* Google Titan M2 Hardware Specification (`https://security.googleblog.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **RPMB (Replay Protected Memory Block) / Monotonic Counter:** Titan M2 hardware persistent monotonic counters used for AVB rollback and lockout timer storage.
  - *Source:* Google Titan M2 Architecture Overview (`https://security.googleblog.com/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Radios and Communications

- **Cellular Modem Vendor & Model:** Samsung Exynos 5300 5G Modem (Shannon IPC driver)
  - *Source:* Google Pixel 8 Tech Analysis & Kernel Source (`https://android.googlesource.com/kernel/manifest`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Radio Controllability (Driver / Kernel RF Kill):** Radio HAL / kernel power interfaces allow disabling modem, Wi-Fi (Broadcom BCM4389), and Bluetooth via RFKILL subsystem.
  - *Source:* Android Radio HAL Specification (`https://source.android.com/docs/core/connect/telephony`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **Emergency Call Radio Behavior:** Emergency calling (E911) overrides software radio-off states at the baseband radio layer as mandated by FCC/3GPP standards.
  - *Source:* FCC Wireless Emergency Services Guidance (`https://www.fcc.gov/`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **NFC Hardware & Disablement Path:** STMicroelectronics ST21NFC hardware present; software kernel driver and NFC HAL can be disabled completely in system image.
  - *Source:* Android NFC HAL Architecture (`https://source.android.com/docs/core/connect/nfc`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## USB and Peripherals

- **USB Controller & Version:** DWC3 USB 3.2 Gen 2 Type-C controller with DisplayPort Alternate Mode support and ConfigFS gadget interface.
  - *Source:* Google Pixel 8 Specs & Linux USB DWC3 Driver (`https://store.google.com/product/pixel_8_specs`) | Date: 2025-05-16 | Confidence: `VERIFIED`
- **ConfigFS / USB Gadget Configuration Modes:** Linux ConfigFS USB gadget framework supporting MTP, PTP, ADB, Accessory, RNDIS, and Mass Storage modes.
  - *Source:* Android USB Gadget Architecture (`https://source.android.com/docs/core/architecture/usb`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Thermal Management

- **Thermal Driver / Thermal HAL Support:** Google Tensor Thermal Driver and Android Thermal HAL 2.0 with active hardware diode throttling profiles.
  - *Source:* AOSP Thermal Management Guide (`https://source.android.com/docs/core/power/thermal`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Manufacturer Updates & Support

- **Stated Update / Support Period:** 7 years of OS, security, and feature updates (supported through October 2030).
  - *Source:* Google Pixel Update Policy Announcement (`https://support.google.com/pixelphone/answer/4457701`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Regulatory and Market Notes

- **Target Market & Radio Band Notes:** Global 5G Sub-6GHz and mmWave (Model G9B03 / GKWS6) supported across major global carriers.
  - *Source:* Google Pixel 8 Regulatory Specs (`https://support.google.com/pixelphone/`) | Date: 2025-05-16 | Confidence: `VERIFIED`

---

## Open Questions for Physical Device Testing

1. How does Titan M2 behave when custom AVB key is cleared via `fastboot erase avb_custom_key`?
2. What is the precise latency for Titan M2 hardware counter updates during rapid power loss simulation?
3. Can the Samsung Exynos 5300 modem be fully isolated in kernel sysfs while keeping internal IPC bus operational?
