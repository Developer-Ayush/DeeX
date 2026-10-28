# DeeX Target Device Driver and Hardware Retention Matrix

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 4.1, 4.2, 5.2, 6.3, 9.6, 9.7, 9.8, 10.2, 14.5, 17

---

## 1. Overview

This matrix maps every hardware function required by Master Plan Section 4.2 and higher-level DeeX modules to its respective kernel driver component, source repository location, licensing model, open source vs. vendor binary status, DeeX control/modification requirements, and supporting requirement IDs for Google Pixel 8 (`shiba` / Google Tensor G3 `zuma` on Android 15 `android-15.0.0_r1`).

---

## 2. Driver Retention Matrix Table

| Hardware Function | Kernel Component / Driver | Source Location as Documented | Source Type | Licence Status | DeeX Control / Modification Need | Supporting Requirement | Closed-Component Isolation Flag |
|---|---|---|---|---|---|---|---|
| **CPU / SoC Cores** | ARMv8.2+ Cortex Cores (`kernel/common`) | `kernel/common` | Open Source | GPLv2 | CPU frequency scaling & cgroups v2 resource accounting | `KERN-001`, `KERN-008` | No |
| **Display Subsystem** | Tensor DPU / Samsung Display Driver | `kernel/google-modules/display` | Dual (OS/Binary FW) | GPLv2 + Vendor FW Blob | Display output retention; no kernel modifications | `KERN-001` | No |
| **Touchscreen** | Goodix / Synaptics Touch Driver | `kernel/google-modules/touch` | Open Source Driver | GPLv2 | Touch input retention; no kernel modifications | `KERN-001` | No |
| **Audio Subsystem** | Tensor Audio DSP Driver | `kernel/google-modules/audio` | Dual (OS/Binary FW) | GPLv2 + Vendor FW Blob | Audio HAL retention; no kernel modifications | `KERN-001` | No |
| **Camera Subsystem** | Tensor ISP / Google IPU Driver | `kernel/google-modules/soc/zuma` | Dual (OS/Binary FW) | GPLv2 + Vendor FW Blob | Camera HAL retention; no kernel modifications | `KERN-001` | No |
| **Cellular Modem** | Samsung Shannon 5123 Modem IPC Driver | `kernel/google-modules/modem` | Dual (OS Driver/Binary FW) | GPLv2 + Proprietary Baseband FW | Connect module RFKILL / radio power control | `KERN-001`, `KERN-010` | **CLOSED COMPONENT FLAG**: Modem kill-switch relies on closed baseband firmware response |
| **UFS Storage Controller** | UFS Host Controller & Inline Encryption | `kernel/common/drivers/ufs` | Open Source | GPLv2 | Vault `fscrypt` hardware inline encryption | `KERN-001`, `KERN-004` | No |
| **Wi-Fi Subsystem** | Broadcom BCM4389 Wi-Fi Driver | `kernel/google-modules/wlan/bcm4389` | Dual (OS Driver/Binary FW) | GPLv2 + Proprietary FW Blob | Connect module RFKILL Wi-Fi disablement | `KERN-001`, `KERN-010` | **CLOSED COMPONENT FLAG**: Wi-Fi radio isolation relies on firmware state |
| **Bluetooth Subsystem** | Broadcom Bluetooth Driver | `kernel/google-modules/bluetooth` | Dual (OS Driver/Binary FW) | GPLv2 + Proprietary FW Blob | Connect module RFKILL Bluetooth disablement | `KERN-001`, `KERN-010` | **CLOSED COMPONENT FLAG**: Bluetooth radio isolation relies on firmware state |
| **GNSS / GPS Subsystem** | Broadcom GNSS Driver | `kernel/google-modules/gps` | Dual (OS Driver/Binary FW) | GPLv2 + Proprietary FW Blob | Location service control; no kernel modifications | `KERN-001` | No |
| **NFC Subsystem** | STMicroelectronics ST21NFC Driver | `kernel/google-modules/nfc` | Dual (OS Driver/Binary FW) | GPLv2 + Proprietary FW Blob | Connect module NFC hardware disablement | `KERN-001`, `KERN-010` | **CLOSED COMPONENT FLAG**: NFC disablement depends on ST21NFC closed FW |
| **Fingerprint Sensor** | Goodix Optical Fingerprint Driver | `kernel/google-modules/fingerprint` | Dual (OS Driver/Vendor TEE App) | GPLv2 + Proprietary TEE App | Identity module biometric auth interface | `KERN-001` | **CLOSED COMPONENT FLAG**: Biometric matching in closed TrustZone TEE app |
| **Ambient & Motion Sensors** | Sensor Hub / CHRE Driver | `kernel/google-modules/sensors` | Dual (OS Driver/CHRE FW) | GPLv2 + Proprietary CHRE FW | Android Sensor HAL retention | `KERN-001` | No |
| **USB Controller** | DWC3 USB Controller & ConfigFS Gadget | `kernel/common/drivers/usb/dwc3` | Open Source | GPLv2 | Bridge module USB gadget role & auth control | `KERN-001`, `KERN-010` | No |
| **Power & Thermal Management** | Tensor PMIC & Thermal Zone Governors | `kernel/google-modules/soc/zuma` | Open Source | GPLv2 | Thermal safety retained; resource accounting policy | `KERN-001`, `KERN-008` | No |
| **Titan M2 Secure Hardware** | Google Citadel / EdgeTPU / Nos Driver | `kernel/google-modules/edgetpu` | Open Source Driver | GPLv2 + Proprietary Titan M2 FW | Vault/Identity hardware KeyMint & Weaver | `KERN-001`, `KERN-007` | **CLOSED COMPONENT FLAG**: Hardware security functions execute in closed Titan M2 FW |

---

## 3. High-Risk Closed Component Dependencies

The following hardware capabilities required by DeeX modules depend on proprietary, closed-source vendor firmware or binaries:

1. **Cellular Radio Kill-Switch (Connect Module)**:
   - *Dependency*: The cellular modem IPC driver is open source, but cellular modem power down and baseband isolation depend on proprietary Samsung Shannon modem firmware.
   - *Risk*: Firmware may not fully power down or cease radio emissions when requested via driver sysctl / RFKILL interface.
   - *Mitigation*: Physical RF shielding testing required during hardware validation.

2. **NFC Disablement (Connect Module)**:
   - *Dependency*: Disabling NFC requires issuing power state commands to the proprietary STMicroelectronics NFC controller firmware.
   - *Risk*: Firmware could remain active or respond to external NFC poll fields even when power state is set to disabled in user-space HAL.
   - *Mitigation*: Physical NFC test field verification required during hardware validation.

3. **Hardware Biometrics & Key Storage (Identity & Vault Modules)**:
   - *Dependency*: Fingerprint matching and Titan M2 StrongBox key derivation execute inside proprietary TEE / Titan M2 firmware.
   - *Risk*: Closed TEE apps cannot be audited or modified by DeeX.
   - *Mitigation*: DeeX interacts with hardware security elements exclusively through standard Android Hardware Abstraction Layer (HAL) interfaces (`android.hardware.security.keymint`).

---

## 4. Primary Source Citations

- AOSP Kernel Source Repositories (`https://android.googlesource.com/kernel/manifest`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- Google Pixel Hardware Specifications (`https://store.google.com/product/pixel_8_specs`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- Chunk 5 Hardware Support Report (`docs/build-records/baseline-hardware-support-report.md`, Access Date: 2025-05-16, Confidence: `UNVERIFIED — awaiting physical test`).
