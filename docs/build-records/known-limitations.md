# DeeX Base — Register of Known Limitations for Baseline AOSP

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Base
- **Target Device**: Google Pixel 8 (`shiba`)
- **AOSP Baseline**: Android 15 (`android-15.0.0_r1`)
- **Master Plan Sections**: 2.5, 4.2, 9.7, 16.3

---

## 1. Limitation Register Table

| Limitation ID | Description | Evidence / Primary Source | Affected DeeX Requirement(s) | Status |
|---|---|---|---|---|
| `LIM-001` | Baseline AOSP build relies on proprietary prebuilt binary blobs extracted from Google Pixel firmware for cellular, GPU, Wi-Fi/BT, and Titan M2 HALs. | `docs/build-records/vendor-binaries-procedure.md` / `vendor/google_devices/shiba/` | DeeX Master Plan Section 2.3, 4.1 (Vendor Blob Policy) | **ACTIVE** |
| `LIM-002` | Radio hardware (Cellular, Wi-Fi, Bluetooth) cannot be hard-isolated at the physical hardware driver level without dropping power to the entire Tensor G3 PCIe bus. | Google Android Source — Kernel/Driver Architecture for Tensor SoCs | DeeX Master Plan Section 9.7 (Radio Isolation & Kill Switches) | **ACTIVE** |
| `LIM-003` | Bootloader relocking requires flashing a custom AVB key (`avb_custom_key`) into Titan M2 secure storage; stock baseline image cannot be relocked without custom key provision. | Google Android Source — Verified Boot Boot Flow & Titan M2 Docs | DeeX Master Plan Section 5.2 (Custom AVB Key Relock) | **ACTIVE** |
| `LIM-004` | Baseline AOSP `aosp_shiba-userdebug` includes default Google ADB daemon with root access enabled over USB by default (`adb root`). | AOSP Build Configuration (`aosp_shiba-userdebug`) | DeeX Master Plan Section 5.1, 12.1 (Production Hardening) | **ACTIVE** |

---

## 2. Analysis of Threat to DeeX Architecture Requirements

### 2.1 LIM-001: Proprietary Prebuilt Vendor Blobs
- **Threat**: Proprietary vendor binaries in `vendor/google_devices/shiba/` are closed-source and cannot be recompiled from source, limiting static analysis and binary verification.
- **Mitigation Strategy in Future Modules**: DeeX Isolation and Connectivity modules will wrap vendor HAL interfaces with strict eBPF, SELinux, and binder permission boundaries.

### 2.2 LIM-002: Driver-Level Radio Kill Switches
- **Threat**: Master Plan Section 9.7 mandates hardware/driver level radio isolation. If radio chips share power rails on the SoC, software power-down commands may leave baseband firmware active in low-power states.
- **Mitigation Strategy in Future Modules**: DeeX Connectivity module must implement strict kernel-level RF kill switch drivers that unbind PCIe/USB driver instances and assert GPIO reset lines.
