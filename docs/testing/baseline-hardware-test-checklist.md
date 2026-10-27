# DeeX Base — Baseline Hardware Test Checklist for Google Pixel 8 (shiba)

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Base
- **Target Device**: Google Pixel 8 (`shiba`)
- **AOSP Baseline**: Android 15 (`android-15.0.0_r1`)
- **Master Plan Sections**: 2.5, 4.2, 5.3, 6.6, 6.7, 7.3, 7.5, 9.6, 9.7, 9.8, 16.3

---

## 1. Safety Rule & Emergency Stop Instructions

> **SAFETY MANDATE**: Immediately terminate testing, disconnect any power/USB cable, power down the target device, and record the failure if any of the following occur:
> 1. Unexpected device heating (>45°C ambient surface feel) or thermal throttling popup.
> 2. Battery swelling, odor, uncharacteristic discharge rate, or smoke.
> 3. Persistent bootlooping or continuous unrecoverable kernel panic / crash dump.
> 4. **Emergency Calls Warning**: Cellular modem testing must **NEVER** dial emergency service numbers (e.g., 911, 112, 999). Test phone calling exclusively using a non-emergency test phone number.

---

## 2. Hardware Test Checklist Table

The project owner will execute each safe test step after successfully booting the baseline image, fill in the actual result and pass/fail status, and return the completed intake form.

| Item ID | Functionality / Hardware Component | Test Step (Simple, Safe Execution) | Expected Result | Actual Result | Status (`PASS` / `FAIL` / `NOT TESTED`) | Notes |
|---|---|---|---|---|---|---|
| `HW-01` | First Boot & Launcher | Observe first boot completion to home screen; record boot duration with stopwatch. | Device boots cleanly to AOSP launcher in <180s without bootloops. | | `NOT TESTED` | |
| `HW-02` | Display & Touchscreen | Navigate home screens, multi-touch gestures, adjust brightness slider, auto-rotate display. | Smooth display rendering, multi-touch responsive across screen, brightness responds correctly. | | `NOT TESTED` | |
| `HW-03` | Audio Subsystem | Play sample audio file via default player; test speaker, earpiece, microphone recording via Sound Recorder app. | Clear audio playback from speaker and earpiece; microphone records clear audio without distortion. | | `NOT TESTED` | |
| `HW-04` | Camera Hardware | Open Camera app; test primary rear lens, ultra-wide lens, front camera, LED flash, and 10s video recording. | Clear image capture on all camera lenses; flash triggers correctly; video records with audio. | | `NOT TESTED` | |
| `HW-05` | Cellular Modem & SIM | Insert active test SIM card. Verify SIM detection, place non-emergency test voice call, send/receive SMS, browse web via mobile data. | SIM recognized; call connects and clear voice path established; SMS sent/received; mobile data active. | | `NOT TESTED` | Do NOT dial emergency numbers (911/112). |
| `HW-06` | Wi-Fi Subsystem | Scan for local Wi-Fi networks in Settings, connect to a local WPA2/WPA3 access point, download a test file. | Wi-Fi networks listed; successful connection and IP assignment; internet connectivity confirmed. | | `NOT TESTED` | |
| `HW-07` | Bluetooth Subsystem | Enable Bluetooth in Settings, scan for nearby Bluetooth devices, pair with a secondary device, transfer a test file. | Bluetooth toggles ON; nearby devices discovered; pairing succeeds; file transfer completes. | | `NOT TESTED` | |
| `HW-08` | GPS / Location Hardware | Open location-enabled app or check `adb shell dumpsys location`. Verify GNSS fix acquisition outdoors. | Location service acquires valid latitude/longitude coordinates from GNSS satellites. | | `NOT TESTED` | |
| `HW-09` | NFC Subsystem | Bring an NFC card or tag near back of device. Check NFC toggle in Settings and HAL log output (`dumpsys nfc`). | NFC toggle available; NFC tag read event registered in system log. | | `NOT TESTED` | Relevant to Master Plan 9.6. |
| `HW-10` | Fingerprint Biometrics | Navigate to Security > Fingerprint Unlock. Attempt fingerprint enrollment on baseline image. | Fingerprint hardware detected; enrollment wizard initializes; fingerprint scanned and saved. | | `NOT TESTED` | Relevant to Master Plan 6.7. |
| `HW-11` | Onboard Sensors | Verify Accelerometer, Gyroscope, Proximity sensor, Ambient Light sensor, Compass via sensor test app or `dumpsys sensorservice`. | All hardware sensors enumerated and reporting changing real-time data values. | | `NOT TESTED` | |
| `HW-12` | USB Interface & ADB | Connect device to host PC via USB. Verify charging, MTP file transfer mode, and `adb shell` / `adb logcat` access. | USB charges battery; host mounts storage in MTP mode; `adb` shell commands execute without error. | | `NOT TESTED` | |
| `HW-13` | Internal Storage (UFS) | Check available free storage in Settings > Storage. Create, edit, and delete a 50MB file on internal storage. | Internal storage accurately reported (~128GB capacity); file I/O operations execute successfully. | | `NOT TESTED` | |
| `HW-14` | Thermal & Battery Performance | Measure idle temperature. Run 10-minute light web browsing workload; observe battery percentage drop and surface temperature. | Surface temperature remains normal (<38°C); battery drain <3% over 10 minutes. | | `NOT TESTED` | |
| `HW-15` | Multi-User Execution | Navigate to System > Multiple Users. Enable feature, create a new User, switch to new User, and switch back. | Multi-user creation succeeds; fast user switching completes without system server crash. | | `NOT TESTED` | Relevant to Master Plan 7.3, 7.5. |
| `HW-16` | Hardware Key Storage | Check hardware-backed key storage status via `adb shell dumpsys android.security.keystore` or KeyMint API test app. | Baseline reports active StrongBox / KeyMint 3.0 hardware security module available on Titan M2. | | `NOT TESTED` | Relevant to Master Plan 6.2, 10.1. |
