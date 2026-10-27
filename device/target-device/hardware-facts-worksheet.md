# DeeX Target Device Hardware-Facts Worksheet Template

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `device/target-device/hardware-facts-worksheet.md`

---

## Instructions

This worksheet records factual hardware specifications, bootloader policies, kernel source locations, security coprocessor details, radio controls, and open questions for candidate devices evaluated for DeeX.

Every entry in a candidate worksheet **must** include:
1. Exact factual specification or state.
2. Primary Source URL.
3. Access Date (`YYYY-MM-DD`).
4. Confidence Level (`VERIFIED`, `REPORTED`, or `UNVERIFIED`).

If a detail is unknown or unpublished, mark it explicitly as `UNKNOWN — decision required`.

---

## Candidate Identity

- **Marketing Name:** `[Name]`
- **Device Codename:** `[Codename]`
- **SoC (System on Chip):** `[SoC]`
- **CPU Architecture:** `[CPU Arch / Cores]`
- **GPU:** `[GPU]`
- **RAM Variants:** `[RAM Size and Type]`
- **Storage Variants:** `[Storage Size and Type (UFS / eMMC)]`

---

## Boot & Verified Boot (AVB)

- **Bootloader Unlock Procedure:** `[Procedure and conditions]`
- **Carrier / Account Lock Restrictions:** `[Restrictions]`
- **AVB Version Support:** `[AVB version]`
- **Custom Key Flashing (`fastboot flash avb_custom_key`):** `[Supported / Not Supported]`
- **Bootloader Relocking with Custom Key:** `[Supported / Not Supported]`
- **Partition Scheme:** `[A/B or Virtual A/B with Dynamic Partitions]`
- **Hardware Rollback Index Protection:** `[Supported / Not Supported]`

---

## Partition Layout

- **Documented Partitions:** `[List known partitions or UNKNOWN — decision required]`

---

## Kernel and Drivers

- **Shipped Kernel Version:** `[Kernel version]`
- **Kernel Source Repository:** `[URL]`
- **Kernel Licence:** `[GPLv2]`
- **Vendor Kernel Modules Openness:** `[Open / Closed / Mixed]`

---

## Firmware and Vendor Blobs

- **Blob Publication Location:** `[URL]`
- **Licence / Redistribution Terms:** `[Terms]`
- **Export / Usage Restrictions:** `[Restrictions]`

---

## Security Hardware & Keystore

- **Keymaster / KeyMint HAL Level:** `[Version]`
- **StrongBox Security Coprocessor:** `[Present / Absent]`
- **Secure Element / Coprocessor Name:** `[Titan M2 / Qualcomm SPU / None]`
- **Biometric TEE Integration:** `[Supported / Not Supported]`
- **Hardware Attestation Support:** `[Supported / Not Supported]`

---

## Time & Counter Facilities

- **Trusted Time Source:** `[Secure RTC / Network Verified]`
- **RPMB (Replay Protected Memory Block) / Monotonic Counter:** `[Supported / Not Supported]`

---

## Radios and Communications

- **Cellular Modem Vendor & Model:** `[Vendor]`
- **Radio Controllability (Driver / Kernel RF Kill):** `[Controllable / Limited]`
- **Emergency Call Radio Behavior:** `[Hardcoded / Overrideable]`
- **NFC Hardware & Disablement Path:** `[Present and Disabling Path]`

---

## USB and Peripherals

- **USB Controller & Version:** `[Controller]`
- **ConfigFS / USB Gadget Configuration Modes:** `[Supported modes]`

---

## Thermal Management

- **Thermal Driver / Thermal HAL Support:** `[Driver / HAL]`

---

## Manufacturer Updates & Support

- **Stated Update / Support Period:** `[Period]`

---

## Regulatory and Market Notes

- **Target Market & Radio Band Notes:** `[Notes]`

---

## Open Questions for Physical Device Testing

- `[List open questions that require physical device verification]`
