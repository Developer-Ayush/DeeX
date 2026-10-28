Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.1, 3.2, 3.3, 3.4, 13.3, 13.4, 14.2, 14.3

# DeeX Boot — Hardware Feasibility and Risk Assessment for Google Pixel 8 (shiba)

## 1. Line-by-Line Assessment against Master Plan Section 3 Requirements

This document evaluates whether the Google Pixel 8 (`shiba`) running Android 15 (`android-15.0.0_r1`) can satisfy each requirement in Master Plan Section 3 based on cited primary sources and technical documentation.

| Requirement Topic | Master Plan Requirement | Technical Feasibility Status | Primary Source Evidence | Key Risk & Impact |
|---|---|---|---|---|
| **Hardware Root of Trust** | Integrate supported bootloader and hardware RoT (MP 3.2) | `SUPPORTED (evidence)` | AOSP Boot Overview / Tensor G3 Specs | Tensor G3 PBL and Titan M2 execute cryptographic boot signature verification. |
| **Android Verified Boot** | Configure AVB 2.0 verification across chain (MP 3.2) | `SUPPORTED (evidence)` | AOSP AVB Documentation | AVB 2.0 standard fully implemented in Pixel 8 bootloader and AOSP tree. |
| **Partition Verification** | Verify kernel, device tree, system, vendor partitions (MP 3.2) | `SUPPORTED (evidence)` | AOSP Boot Flow Specs | Hash descriptors in `vbmeta` verify `boot`/`vendor_boot`; `dm-verity` verifies `system`/`vendor`. |
| **Rollback Protection** | Configure anti-rollback protection where supported (MP 3.2) | `SUPPORTED (evidence)` | Titan M2 & AOSP AVB Specs | Titan M2 non-volatile NVRAM counters enforce $R_{img} >= R_{hw}$. |
| **Key Protection** | Separate release keys from dev keys; protect release keys (MP 3.2) | `SUPPORTED (evidence)` | DeeX Key Hierarchy Spec / AOSP | Air-gapped LUKS key storage policy defined; AOSP supports separate key tiers. |
| **Failure Response** | Defined response to corrupted/unauthenticated images (MP 3.2) | `SUPPORTED (evidence)` | AOSP Device State Specs | Release builds trigger `RED` state boot halt on tamper; dev builds display warning. |
| **Recovery & Update Trust** | Recovery and updates follow same trust policy (MP 3.2, 14.2, 14.3) | `SUPPORTED (evidence)` | AOSP Update Engine Specs | Recovery uses identical AVB verification; Virtual A/B updates payload integrity. |
| **DeeX Service Integrity** | Protect integrity of `system/deex/*` services (MP 3.2) | `SUPPORTED (evidence)` | DeeX Boot Spec (`BOOT-009`) | Services sit on `dm-verity` read-only system partitions. |
| **Owner-Enrolled AVB Keys** | Support custom AVB root key embedding (`fastboot flash avb_custom_key`) | `PROBABLY — needs physical verification` | AOSP Device State Docs | Google Pixel devices support custom key enrollment, but physical flashing on Pixel 8 needs owner test confirmation (`GAP-BOOT-002`). |
| **Bootloader Relock with Custom Key** | Relock bootloader with custom key into GREEN state (`fastboot flashing lock`) | `PROBABLY — needs physical verification` | Pixel Developer Docs | Supported on Pixel hardware, but physical verification required to confirm no bootloops (`GAP-BOOT-003`). |

---

## 2. Top Three Highest Risks & Gaps

### 1. Custom AVB Key Relocking Risk (`GAP-BOOT-003`)
- **Risk**: While Google Pixel hardware officially supports `fastboot flash avb_custom_key` and relocking, an unexpected vendor bootloader firmware discrepancy under Android 15 could cause a bootloop or render the device unbootable when locked with custom keys.
- **Mitigation**: Staged approach in ADR-0004 (Phase 1 bringup in unlocked state; physical verification in Phase 2 before locking production builds).

### 2. Single-Person Key Authorization Risk (`TM-BOOT-004`)
- **Risk**: Release signing key authorization rests solely with the Project Owner. Permanent key loss or owner unavailability blocks official OTA updates.
- **Mitigation**: Offsite AES-256 encrypted key backup and succession plan placeholder in `docs/specifications/boot-key-hierarchy.md`.

### 3. Impact on Google Play Integrity & CTS Certification (`REQ-CERT-001`)
- **Risk**: Relocking the bootloader with a custom AVB key sets the KeyMint attestation `verifiedBootColor` to `YELLOW` (or `CUSTOM`). Third-party Google Play Integrity API attestations may report `MEETS_BASIC_INTEGRITY` but fail `MEETS_STRONG_INTEGRITY` or `MEETS_DEVICE_INTEGRITY` if Google's attestation servers do not recognize the custom root certificate.
- **Mitigation**: Record as a risk per Master Plan Section 13.3/13.4. DeeX will pursue official GMS certification and partner licensing through legitimate channels without spoofing attestation results.
