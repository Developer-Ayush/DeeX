Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 5.2, 16.2

# Vendor Binaries Acquisition Procedure (Google Pixel 8 — shiba)

## 1. Overview & Policy

To achieve full hardware support (display, GPU, cellular modem, Titan M2 security coprocessor, Wi-Fi, Bluetooth, camera HALs) for Google Pixel 8 (`shiba`), proprietary device vendor driver binaries are required alongside open-source AOSP code.

**Strict Licensing & Agent Rules:**
- **Jules and the AI agent repository NEVER accept licenses or download vendor binaries on the project owner's behalf.**
- The project owner must personally read and accept Google's Driver Binaries License Agreement on Google's official developer page.
- Vendor binary archives and extracted driver files are stored strictly locally outside the Git repository in `$WORK_DIR/src/vendor/` and **MUST NEVER** be committed to Git.
- Licensing terms for vendor binaries are recorded as `UNKNOWN — decision required` regarding external redistribution rights; see `docs/build-records/licence-and-dependency-inventory.md`.

---

## 2. Primary Sources

1. **Google Pixel Driver Binaries Page**: `https://developers.google.com/android/drivers#shiba` (Access Date: 2025-05-16, Confidence: `VERIFIED`).
2. **Google Pixel 8 (shiba) Android 15 Tag `android-15.0.0_r1` Driver Archive**: `AP3A.240905.015.A2` driver package (Primary Source: Google Developers, `VERIFIED`).

---

## 3. Owner Acquisition Instructions

1. **Navigate to Official Driver Page**:
   Open `https://developers.google.com/android/drivers#shiba` in a Web browser on your build host.

2. **Locate Matching Build ID**:
   Find the section for **Google Pixel 8 (`shiba`)** matching build ID `AP3A.240905.015.A2` (Android 15 tag `android-15.0.0_r1`).

3. **Read and Accept License Terms**:
   Read Google's Software License Agreement carefully. If you agree, click "I Agree" to download the two vendor driver packages:
   - Google driver package (e.g., `extract-google_devices-shiba.sh`)
   - Hardware vendor driver package (e.g., Qualcomm/Tensor drivers `extract-broadcom-shiba.sh` / `extract-google_devices-shiba.sh`)

4. **Verify Download Checksums**:
   Run `tools/verify-vendor-binaries.sh` against your download directory:
   ```sh
   sh tools/verify-vendor-binaries.sh --vendor-dir /path/to/downloads --expected-sha256 <CHECKSUM_FROM_PAGE>
   ```

5. **Extract Driver Archives Into Source Tree**:
   Move the `.tgz` or self-extracting `.sh` files into your build source root (`$WORK_DIR/src/`):
   ```sh
   cd "$WORK_DIR/src"
   tar -zxvf /path/to/downloads/google_devices-shiba-ap3a.240905.015.a2-*.tgz
   sh extract-google_devices-shiba.sh
   ```
   During execution, type `I ACCEPT` when prompted by Google's license script. This extracts binary blobs into `vendor/google/shiba/` and `vendor/google_devices/shiba/`.

6. **Record Checksums in Build Record**:
   When invoking `tools/make-build-record.sh`, include the recorded SHA-256 checksums of the downloaded vendor driver archives in the build record notes section.
