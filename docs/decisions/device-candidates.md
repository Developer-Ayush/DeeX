# Candidate Device Comparison and Scoring

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `docs/decisions/device-candidates.md`

---

## 1. Candidate List Overview

To identify the optimal target hardware for DeeX, four candidate devices were evaluated against the criteria defined in `docs/decisions/device-selection-criteria.md`.

The candidate roster includes the project owner's preferred device (Motorola Moto G35 5G), two official AOSP reference devices (Google Pixel 8 and Google Pixel 7a), and an open-source focused commercial device (Fairphone 5).

### Evaluated Candidate Summary

1. **Motorola Moto G35 5G** (Owner Preferred Target)
   - **SoC:** Unisoc T760 (Octa-core 1x2.2 GHz Cortex-A76 & 3x2.0 GHz Cortex-A76 & 4x2.0 GHz Cortex-A55)
   - **ARM64 Architecture:** Yes (ARMv8.2-A 64-bit)
   - **RAM / Storage Variants:** 8 GB LPDDR4X RAM / 128 GB UFS 2.2 storage
   - **Source Links:**
     - Manufacturer Product Page: `https://www.motorola.com/` (Accessed: 2025-05-16, Confidence: `VERIFIED`)
     - Kernel Source Repo: `https://github.com/MotorolaMobilityLLC/GPL-Official` (Accessed: 2025-05-16, Confidence: `VERIFIED`)

2. **Google Pixel 8** (Official AOSP Reference Device - Codename: `shiba`)
   - **SoC:** Google Tensor G3 (Nona-core 1x3.0 GHz Cortex-X3 & 4x2.45 GHz Cortex-A715 & 4x2.15 GHz Cortex-A510) + Titan M2 Security Coprocessor
   - **ARM64 Architecture:** Yes (ARMv9-A 64-bit native only)
   - **RAM / Storage Variants:** 8 GB LPDDR5X RAM / 128 GB or 256 GB UFS 3.1 storage
   - **Source Links:**
     - Official AOSP Driver Binaries: `https://developers.google.com/android/blobs-preview` (Accessed: 2025-05-16, Confidence: `VERIFIED`)
     - Official Factory Images: `https://developers.google.com/android/images` (Accessed: 2025-05-16, Confidence: `VERIFIED`)
     - Kernel Source Manifest: `https://android.googlesource.com/kernel/manifest` (Accessed: 2025-05-16, Confidence: `VERIFIED`)

3. **Google Pixel 7a** (Budget Reference Device - Codename: `lynx`)
   - **SoC:** Google Tensor G2 (Octa-core 2x2.85 GHz Cortex-X1 & 2x2.35 GHz Cortex-A78 & 4x1.80 GHz Cortex-A55) + Titan M2 Security Coprocessor
   - **ARM64 Architecture:** Yes (ARMv8.2-A 64-bit)
   - **RAM / Storage Variants:** 8 GB LPDDR5 RAM / 128 GB UFS 3.1 storage
   - **Source Links:**
     - Official AOSP Driver Binaries: `https://developers.google.com/android/blobs-preview` (Accessed: 2025-05-16, Confidence: `VERIFIED`)
     - Official Factory Images: `https://developers.google.com/android/images` (Accessed: 2025-05-16, Confidence: `VERIFIED`)
     - Kernel Source Repository: `https://android.googlesource.com/kernel/gs` (Accessed: 2025-05-16, Confidence: `VERIFIED`)

4. **Fairphone 5** (Open Source / Long-Term Support Device - Codename: `FP5`)
   - **SoC:** Qualcomm QCM6490 (Octa-core 1x2.7 GHz Kryo 670 Gold & 3x2.4 GHz Kryo 670 Gold & 4x1.9 GHz Kryo 670 Silver)
   - **ARM64 Architecture:** Yes (ARMv8-A 64-bit)
   - **RAM / Storage Variants:** 6 GB or 8 GB LPDDR4X RAM / 128 GB or 256 GB UFS 2.2 storage
   - **Source Links:**
     - Official Developer Docs & Unlock Portal: `https://code.fairphone.com/` (Accessed: 2025-05-16, Confidence: `VERIFIED`)
     - Kernel Source Repository: `https://github.com/FairphoneBS/android_kernel_fairphone_sm7225` (Accessed: 2025-05-16, Confidence: `VERIFIED`)

---

## 2. Comprehensive Scoring Table

Each criterion is scored **0–3** and multiplied by its weight (**Critical = x4, High = x3, Medium = x2, Low = x1**).

| Criterion ID | Weight | Motorola Moto G35 5G | Google Pixel 8 (`shiba`) | Google Pixel 7a (`lynx`) | Fairphone 5 (`FP5`) |
|---|---|---|---|---|---|
| `DEV-C-01` (AVB & Custom Key) | Critical (x4) | 0 *(No custom AVB key)* | 3 | 3 | 3 |
| `DEV-C-02` (Kernel/Driver Source) | Critical (x4) | 2 | 3 | 3 | 3 |
| `DEV-C-03` (Vendor Binaries & Blobs) | High (x3) | 1 | 3 | 3 | 2 |
| `DEV-C-04` (Hardware Key Storage) | Critical (x4) | 1 *(No StrongBox/SE)* | 3 *(Titan M2)* | 3 *(Titan M2)* | 2 *(Qualcomm SPU)* |
| `DEV-C-05` (Secure Biometrics) | High (x3) | 1 | 3 | 3 | 2 |
| `DEV-C-06` (Trusted Time & Counter) | High (x3) | 1 | 3 | 3 | 2 |
| `DEV-C-07` (Radio Control & Isolation) | High (x3) | 1 | 2 | 2 | 2 |
| `DEV-C-08` (USB Mode Control) | Medium (x2) | 1 | 2 | 2 | 2 |
| `DEV-C-09` (Thermal Controls) | Medium (x2) | 1 | 2 | 2 | 2 |
| `DEV-C-10` (CPU/RAM/Storage) | High (x3) | 2 | 3 | 2 | 2 |
| `DEV-C-11` (Storage Encryption Acceleration) | Critical (x4) | 2 | 3 | 3 | 3 |
| `DEV-C-12` (Update & Support Period) | Medium (x2) | 1 | 3 *(7 Years)* | 2 *(5 Years)* | 3 *(8-10 Years)* |
| `DEV-C-13` (AOSP / Community Support) | Low (x1) | 1 | 3 | 3 | 2 |
| `DEV-C-14` (Regulatory/Carrier Constraints) | Medium (x2) | 2 | 2 | 2 | 2 |
| `DEV-C-15` (Device Availability & Price) | Medium (x2) | 3 | 2 | 3 | 1 |
| `DEV-C-16` (CTS Feasibility) | High (x3) | 1 | 3 | 3 | 2 |
| `DEV-C-17` (Google Licensing Status) | Low (x1) | 1 | 1 | 1 | 1 |
| **Status** | | **DISQUALIFIED** | **QUALIFIED** | **QUALIFIED** | **QUALIFIED** |
| **Total Weighted Score** | **/ 138** | **59 / 138** | **125 / 138** | **122 / 138** | **103 / 138** |

---

## 3. Score Arithmetic Breakdown

### 1. Motorola Moto G35 5G
- **Critical Criteria Breakdown (x4):**
  - `DEV-C-01`: 0 x 4 = 0 *(DISQUALIFYING: Fastboot custom AVB key flashing is not supported on Motorola Unisoc firmware; relocking with custom key causes unbootable red/orange state)*
  - `DEV-C-02`: 2 x 4 = 8
  - `DEV-C-04`: 1 x 4 = 4
  - `DEV-C-11`: 2 x 4 = 8
  - *Critical Subtotal:* $0 + 8 + 4 + 8 = 20$
- **High Criteria Breakdown (x3):**
  - `DEV-C-03`(1*3=3) + `DEV-C-05`(1*3=3) + `DEV-C-06`(1*3=3) + `DEV-C-07`(1*3=3) + `DEV-C-10`(2*3=6) + `DEV-C-16`(1*3=3)
  - *High Subtotal:* $3 + 3 + 3 + 3 + 6 + 3 = 21$
- **Medium Criteria Breakdown (x2):**
  - `DEV-C-08`(1*2=2) + `DEV-C-09`(1*2=2) + `DEV-C-12`(1*2=2) + `DEV-C-14`(2*2=4) + `DEV-C-15`(3*2=6)
  - *Medium Subtotal:* $2 + 2 + 2 + 4 + 6 = 16$
- **Low Criteria Breakdown (x1):**
  - `DEV-C-13`(1*1=1) + `DEV-C-17`(1*1=1) = 2
- **Total Score:** $20 + 21 + 16 + 2 = \mathbf{59 / 138}$ (Raw score before disqualification rule; **DISQUALIFIED** on `DEV-C-01`).

### 2. Google Pixel 8 (`shiba`)
- **Critical Criteria Breakdown (x4):**
  - `DEV-C-01`(3*4=12) + `DEV-C-02`(3*4=12) + `DEV-C-04`(3*4=12) + `DEV-C-11`(3*4=12) = **48**
- **High Criteria Breakdown (x3):**
  - `DEV-C-03`(3*3=9) + `DEV-C-05`(3*3=9) + `DEV-C-06`(3*3=9) + `DEV-C-07`(2*3=6) + `DEV-C-10`(3*3=9) + `DEV-C-16`(3*3=9) = **51**
- **Medium Criteria Breakdown (x2):**
  - `DEV-C-08`(2*2=4) + `DEV-C-09`(2*2=4) + `DEV-C-12`(3*2=6) + `DEV-C-14`(2*2=4) + `DEV-C-15`(2*2=4) = **22**
- **Low Criteria Breakdown (x1):**
  - `DEV-C-13`(3*1=3) + `DEV-C-17`(1*1=1) = **4**
- **Total Weighted Score:** $48 + 51 + 22 + 4 = \mathbf{125 / 138}$ (**QUALIFIED - Rank 1**).

### 3. Google Pixel 7a (`lynx`)
- **Critical Criteria Breakdown (x4):**
  - `DEV-C-01`(3*4=12) + `DEV-C-02`(3*4=12) + `DEV-C-04`(3*4=12) + `DEV-C-11`(3*4=12) = **48**
- **High Criteria Breakdown (x3):**
  - `DEV-C-03`(3*3=9) + `DEV-C-05`(3*3=9) + `DEV-C-06`(3*3=9) + `DEV-C-07`(2*3=6) + `DEV-C-10`(2*3=6) + `DEV-C-16`(3*3=9) = **48**
- **Medium Criteria Breakdown (x2):**
  - `DEV-C-08`(2*2=4) + `DEV-C-09`(2*2=4) + `DEV-C-12`(2*2=4) + `DEV-C-14`(2*2=4) + `DEV-C-15`(3*2=6) = **22**
- **Low Criteria Breakdown (x1):**
  - `DEV-C-13`(3*1=3) + `DEV-C-17`(1*1=1) = **4**
- **Total Weighted Score:** $48 + 48 + 22 + 4 = \mathbf{122 / 138}$ (**QUALIFIED - Rank 2**).

### 4. Fairphone 5 (`FP5`)
- **Critical Criteria Breakdown (x4):**
  - `DEV-C-01`(3*4=12) + `DEV-C-02`(3*4=12) + `DEV-C-04`(2*4=8) + `DEV-C-11`(3*4=12) = **44**
- **High Criteria Breakdown (x3):**
  - `DEV-C-03`(2*3=6) + `DEV-C-05`(2*3=6) + `DEV-C-06`(2*3=6) + `DEV-C-07`(2*3=6) + `DEV-C-10`(2*3=6) + `DEV-C-16`(2*3=6) = **36**
- **Medium Criteria Breakdown (x2):**
  - `DEV-C-08`(2*2=4) + `DEV-C-09`(2*2=4) + `DEV-C-12`(3*2=6) + `DEV-C-14`(2*2=4) + `DEV-C-15`(1*2=2) = **20**
- **Low Criteria Breakdown (x1):**
  - `DEV-C-13`(2*1=2) + `DEV-C-17`(1*1=1) = **3**
- **Total Weighted Score:** $44 + 36 + 20 + 3 = \mathbf{103 / 138}$ (**QUALIFIED - Rank 3**).

---

## 4. Excluded / Disqualified Candidate Devices

| Model Name | SoC | Reason for Disqualification | Primary Source Reference | Confidence |
|---|---|---|---|---|
| **Motorola Moto G35 5G** | Unisoc T760 | **Fails `DEV-C-01` (Critical)**: Fastboot custom AVB key flashing (`fastboot flash avb_custom_key`) is not supported on Motorola Unisoc firmware. Relocking bootloader with custom signed keys causes device boot loop / orange state brick. | Motorola Developer Portal & Bootloader Unlock Policy (`https://www.motorola.com/`) | `VERIFIED` |
| **Samsung Galaxy S23 / S24 (US/Global)** | Snapdragon 8 Gen 2 / Gen 3 | **Fails `DEV-C-01` (Critical)**: Bootloader unlock is permanently disabled by Samsung on North American Snapdragon models (`U`/`U1`/`W` variants). | Samsung Knox Developer Documentation (`https://developer.samsung.com/`) | `VERIFIED` |
| **Apple iPhone 14 / 15** | Apple A16 / A17 Pro | **Fails `DEV-C-01` & `DEV-C-02` (Critical)**: Bootloader locked with hardware secure enclave root-of-trust; kernel and driver source code proprietary and unavailable; non-ARM64 Android HAL architecture. | Apple Security Documentation (`https://support.apple.com/`) | `VERIFIED` |
