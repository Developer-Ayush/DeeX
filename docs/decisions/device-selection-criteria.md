# DeeX Target Device Selection Criteria

**Status:** Draft — awaiting owner decision
**Date:** 2025-05-16
**Module:** DeeX Base (Chunk 2)
**Document Ref:** `docs/decisions/device-selection-criteria.md`

---

## 1. Overview

This document defines the evaluation criteria, weights, required evidence, and scoring methodology used to evaluate candidate ARM64 hardware for the **DeeX Operating System**. The criteria are derived directly from the **DeeX Master Development Plan v1.0**.

---

## 2. Selection Criteria Matrix

| Criterion ID | Criterion Description | Master Plan Ref | Weight | Required Evidence / Proof |
|---|---|---|---|---|
| `DEV-C-01` | **Bootloader & AVB Support**: Bootloader unlockable and relockable; Android Verified Boot (AVB) 2.0 with custom key embedding (`avbroot` / `fastboot flash avb_custom_key`) supported; hardware rollback protection enforced. | Section 3 | **Critical** | Official manufacturer / AOSP documentation demonstrating bootloader unlock command (`fastboot flashing unlock`), custom AVB key flashing support, and persistent rollback counters. |
| `DEV-C-02` | **Kernel & Driver Source Availability**: Upstream/vendor kernel, device-tree, and open driver source availability under GPL-compatible licence terms. | Section 2.2, 4 | **Critical** | Public git repositories (e.g. Android Kernel OS / Google Git / kernel.org / vendor GitHub) containing full device kernel source and device trees. |
| `DEV-C-03` | **Vendor Firmware & Binary Blobs**: Availability, accessibility, and legal redistribution/usage terms of vendor HAL binaries and hardware proprietary firmware. | Section 2.2, 2.3 | **High** | Official AOSP / vendor binary image download pages (e.g. Google Developers Driver Binaries) with clear licensing terms for development and distribution. |
| `DEV-C-04` | **Hardware-Backed Key Storage**: Presence of hardware security module (KeyMint / Keymaster, StrongBox, or dedicated Secure Element / Titan M2) for per-account key hierarchies. | Section 5.3, 5.4 | **Critical** | Vendor technical specifications or AOSP HAL implementation confirming hardware KeyMint HAL implementation and StrongBox/SE capabilities. |
| `DEV-C-05` | **Secure Biometrics Subsystem**: Secure biometric (fingerprint) TEE hardware processing with hardware-enforced retry counters and biometric key binding. | Section 6.7 | **High** | Official hardware spec or TEE architecture documentation confirming fingerprint processing inside TEE/Secure Enclave with retry limit enforcement. |
| `DEV-C-06` | **Trusted Time & Counter**: Presence of a tamper-resistant time source (RPMB counter, secure RTC, or network/TEE verified time) usable for persistent lockout timers across reboots. | Section 6.6 | **High** | Hardware datasheet / TEE documentation showing RPMB (Replay Protected Memory Block) or persistent secure timer support accessible to HAL. |
| `DEV-C-07` | **Radio Control & Isolation**: Ability to control and isolate modem, Wi-Fi, Bluetooth, GPS, and disable NFC at driver or hardware level for external-isolation switch. | Section 9.6, 9.7, 9.8 | **High** | Vendor driver/HAL architectural documentation confirming independent kernel module or hardware RF power control interfaces; NFC disablement path. |
| `DEV-C-08` | **USB Mode Control**: Ability to configure USB gadget controller dynamically to present empty drive prior to dual-stage authentication and gate storage access. | Section 10 | **Medium** | Kernel ConfigFS / USB gadget driver support (`gadget.g_mass_storage` or Android USB HAL) allowing dynamic LUN backing file swap. |
| `DEV-C-09` | **Thermal Protection Controls**: Hardware-supported thermal monitoring and throttling protection mechanisms to preserve hardware safety during concurrent account sessions. | Section 4.3 | **Medium** | Kernel device tree (`thermal-zones`) and Thermal HAL implementation in vendor device tree. |
| `DEV-C-10` | **CPU, RAM, & Storage Capacity**: ARM64 multi-core performance, minimum 8 GB RAM, and UFS 3.1 / 4.0 storage capacity sufficient for concurrent multi-account sessions. | Section 4.3, 7.5, 7.6 | **High** | Official physical device hardware specifications confirming ARM64 CPU, >= 8GB LPDDR5 RAM, and >= 128GB fast flash storage. |
| `DEV-C-11` | **Storage Encryption Acceleration**: Hardware cryptographic acceleration (ARMv8 CE, inline encryption hardware / ICE) supporting File-Based Encryption (FBE) or metadata encryption. | Section 5.2 | **Critical** | SoC spec sheet and kernel device configuration confirming Inline Crypto Engine (ICE) or ARM CE support for AES-256-XTS/Adiantum. |
| `DEV-C-12` | **Update & Support Period**: Stated manufacturer security update commitments and OS support timeframe. | Master Plan 2.2 | **Medium** | Official manufacturer support commitment publication (e.g. Pixel 7-year update guarantee, Fairphone 8-10 year commitment). |
| `DEV-C-13` | **Upstream AOSP / Community Support**: Level of integration into main AOSP branch (`target/product`), LineageOS, or active developer ecosystem (for risk assessment). | Section 2.1 | **Low** | Upstream repository commits, main AOSP target presence, or active community developer trees. |
| `DEV-C-14` | **Regulatory, Carrier, & Emergency Calling Constraints**: Compliance with regional regulatory standards, carrier band support, and hardwired VoLTE/emergency calling constraints. | Section 9.8 | **Medium** | Official device radio band specifications and carrier compatibility documentation. |
| `DEV-C-15` | **Device Availability & Price**: Commercial availability and purchase cost of the physical device for testing by project owner. | Section 1 Inputs | **Medium** | Official retail vendor store or authorized distributor pricing and stock availability. |
| `DEV-C-16` | **CTS Compatibility Feasibility**: Likelihood of passing Android Compatibility Test Suite (CTS) on baseline AOSP without vendor-specific proprietary HAL failures. | Section 13.2 | **High** | Historical CTS compliance reports, official Android One / AOSP reference status, or published open-source vendor tree CTS results. |
| `DEV-C-17` | **Google Licensing Relevance**: Clarification of GMS licensing status (Recorded as `UNKNOWN — decision required` per master plan boundary). | Section 11.4, 13.1 | **Low** | Legal/business agreement with Google (Note: AOSP device compatibility does not grant GMS licensing; left as `UNKNOWN — decision required`). |

---

## 3. How Scoring Works

Candidate devices are evaluated against each criterion and assigned a raw score from **0 to 3**:

- **0 = Unmet or No Evidence**: The device fails to meet the requirement, or no reliable documentation exists to verify support.
- **1 = Partially Met**: The feature is partially supported, requires proprietary unreleased blobs, or relies on unverified community workarounds.
- **2 = Met**: The device meets the requirement based on verified manufacturer/AOSP primary sources.
- **3 = Met with Strong Evidence**: The device meets the requirement with exceptional primary evidence (e.g. official AOSP reference target, public open driver source, dedicated hardware security coprocessor).

### Weight Multipliers

Each criterion's raw score is multiplied by its category weight multiplier:
- **Critical**: Weight Multiplier = **x4**
- **High**: Weight Multiplier = **x3**
- **Medium**: Weight Multiplier = **x2**
- **Low**: Weight Multiplier = **x1**

### Arithmetic Scoring Formula

$$\text{Total Weighted Score} = \sum_{i=1}^{17} \left( \text{Raw Score}_i \times \text{Weight Multiplier}_i \right)$$

- **Maximum Possible Score**: $(4 \text{ Critical} \times 3 \times 4) + (6 \text{ High} \times 3 \times 3) + (5 \text{ Medium} \times 3 \times 2) + (2 \text{ Low} \times 3 \times 1) = 48 + 54 + 30 + 6 = \mathbf{138}$.

### Disqualification Rule

> **CRITICAL DISQUALIFICATION RULE**: If a candidate device receives a **Raw Score of 0 on ANY Critical criterion** (`DEV-C-01`, `DEV-C-02`, `DEV-C-04`, `DEV-C-11`), the device is **DISQUALIFIED** regardless of its total weighted score.

Disqualified candidates will be listed in an Excluded/Disqualified table with explicit primary source references explaining the failure.
