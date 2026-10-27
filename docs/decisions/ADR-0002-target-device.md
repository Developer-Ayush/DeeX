# ADR-0002: Target Smartphone Device Selection for DeeX

- **Status**: ACCEPTED
- **Date**: 2025-05-16
- **Authors**: Jules (AI Security & Hardware Research Engineer)
- **Owning Module**: DeeX Base

## Context

DeeX requires a target ARM64 smartphone hardware platform supporting Android Verified Boot (AVB 2.0) with custom root key embedding, open kernel driver sources, hardware-backed key storage (KeyMint / StrongBox), secure biometrics TEE, tamper-resistant time sources, controllable radios, and sufficient CPU/RAM capacity for concurrent multi-account execution (Master Plan Sections 1.2, 3, 4, 5, 6, 9, 10, 13).

Four candidate devices were thoroughly researched and scored against the 17 selection criteria defined in `docs/decisions/device-selection-criteria.md`:
1. **Motorola Moto G35 5G** (Owner Preferred Candidate / Unisoc T760)
2. **Google Pixel 8** (`shiba` / Google Tensor G3 + Titan M2)
3. **Google Pixel 7a** (`lynx` / Google Tensor G2 + Titan M2)
4. **Fairphone 5** (`FP5` / Qualcomm QCM6490)

## Decision

**Google Pixel 8 (`shiba`)**

The project owner has selected Google Pixel 8 (`shiba`) as the target smartphone device for DeeX. This aligns with the top-ranked candidate from the technical evaluation and candidate scoring framework (125/138). Google Pixel 8 provides an official first-party AOSP target (`aosp_shiba-userdebug`), Google Tensor G3 SoC, Titan M2 hardware security element (StrongBox), full custom AVB root key embedding (`fastboot flash avb_custom_key`), and official security update support through October 2030.

## Summary of Candidates & Evaluation

| Candidate Device | Total Weighted Score | Status | Primary Technical Finding |
|---|---|---|---|
| **Google Pixel 8** (`shiba`) | **125 / 138** | **QUALIFIED (Rank 1)** | Official AOSP primary target; Titan M2 hardware coprocessor with StrongBox & custom AVB relock; 7-year update support through Oct 2030; native ARM64. |
| **Google Pixel 7a** (`lynx`) | **122 / 138** | **QUALIFIED (Rank 2)** | Official AOSP target; Titan M2 coprocessor; high physical availability and lower price point; 5-year security support through May 2028. |
| **Fairphone 5** (`FP5`) | **103 / 138** | **QUALIFIED (Rank 3)** | Open-source friendly commercial hardware; 8-10 year support commitment; custom AVB key relock supported; Qualcomm QCM6490 SoC; higher cost and EU-focused radio band profile. |
| **Motorola Moto G35 5G** | **59 / 138** | **DISQUALIFIED** | **Fails Critical Criterion `DEV-C-01`**: Unisoc bootloader firmware lacks custom AVB key flashing interface; relocking bootloader with custom image causes orange state boot failure or brick. |

## Disqualified Candidates

- **Motorola Moto G35 5G**: Disqualified due to lack of custom AVB key flashing support (`DEV-C-01`) and absence of a dedicated hardware security module (`DEV-C-04`).
- **Samsung Galaxy S23 / S24 (US/Canada)**: Disqualified because bootloader unlocking is permanently locked out by Samsung Knox on North American Snapdragon models.
- **Apple iPhone 14 / 15**: Disqualified due to locked hardware root of trust, absence of AOSP kernel/driver sources, and incompatible OS HAL architecture.

## Consequences of Possible Choices

### If Owner Selects Google Pixel 8 (`shiba`):
- **Pros**: Highest security posture; full hardware Titan M2 StrongBox & custom AVB key relock support; official first-party AOSP device tree (`aosp_shiba-userdebug`) minimizes HAL porting effort; 7-year update support horizon.
- **Cons**: Higher physical device cost (~$499-$699 USD).

### If Owner Selects Google Pixel 7a (`lynx`):
- **Pros**: Identical security architecture (Titan M2, AVB custom key, StrongBox) as Pixel 8 at significantly lower device cost (~$349-$449 USD); official AOSP support.
- **Cons**: Slightly shorter remaining security update window (May 2028 vs. Oct 2030); Tensor G2 thermal profile slightly warmer under heavy multi-account load.

### If Owner Selects Fairphone 5 (`FP5`):
- **Pros**: Excellent long-term open source philosophy; exceptional repairability and 10-year support horizon; modular hardware components.
- **Cons**: Higher unit cost (~€700 EUR); Qualcomm proprietary driver blob extraction required from stock builds; lacks dedicated EAL6+ Titan M2 hardware element (uses Qualcomm SPU).

---

## Decision Record for Owner

The project owner selected the target device in communication during Chunk 3 execution:

```text
===================================================================
DECISION RECORD FOR OWNER
===================================================================
Selected Target Device: Google Pixel 8 (shiba)
Date of Decision:       2025-05-16
Owner Rationale:        Target device decision confirmed by project owner in Chunk 3 prompt interaction ("Target device: Google Pixel 8 / shiba"). Top-ranked candidate meeting all critical security criteria including custom AVB root key relock and Titan M2 StrongBox.
Owner Signer / Title:   Project Owner
===================================================================
```
