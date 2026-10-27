# ADR-0003: AOSP Baseline Release Selection for Google Pixel 8 (shiba)

- **Status**: PROPOSED
- **Date**: 2025-05-16
- **Authors**: Jules (AI Build & Release Engineer)
- **Owning Module**: DeeX Base
- **Master Plan Sections**: 2.1, 2.2, 13.2, 16.2, 17

## Context

DeeX requires a pinned AOSP baseline release for the selected target device, **Google Pixel 8 (`shiba`)**. The chosen release serves as the upstream source foundation for all system framework modifications, kernel drivers, security services (DeeX Vault, Identity, Isolation, Bridge, Connect), Android Compatibility Definition Document (CDD) alignment, and Compatibility Test Suite (CTS) verification (Master Plan Sections 2, 13.2).

Per master plan rules and project owner instructions, the release selection must be evaluated against primary sources and DeeX requirements, but left as `UNDECIDED — awaiting project owner` in status `PROPOSED` until the project owner explicitly confirms the choice.

## Evaluation of Candidate Releases for Google Pixel 8 (shiba)

Two primary AOSP release branches support the Google Pixel 8 (`shiba`) hardware platform:

### Candidate 1: Android 14 (`android-14.0.0_r...` / `android-14.0.0_r75`)
- **Primary Source Evidence**: Official Google Codenames, Tags, and Build Numbers (`https://source.android.com/docs/setup/about/build-numbers`, Access Date: 2025-05-16, Confidence: `VERIFIED`); Factory Images for Nexus and Pixel Devices (`https://developers.google.com/android/images#shiba`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Support Status**: Original shipping OS version for Pixel 8 (`shiba`). Active security maintenance release.
- **CDD & CTS Availability**: Official Android 14 CDD and CTS v14 test suites are fully published and mature (`https://source.android.com/docs/compatibility/14/android-14-cdd`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Hardware & Driver Availability**: Vendor driver binaries and vendor image blobs (`vendor_boot`, `vendor_dlkm`) are published by Google for `shiba` across all Android 14 quarterly platform releases (QPRs).
- **Security Features**: Full support for Android Verified Boot 2.0 (AVB) with custom root key embedding (`fastboot flash avb_custom_key`), Titan M2 StrongBox KeyMint HAL, File-Based Encryption (FBE) v2 with metadata encryption, and multi-user framework.

### Candidate 2: Android 15 (`android-15.0.0_r...` / `android-15.0.0_r1` / `AP3A.241005.015`)
- **Primary Source Evidence**: Official AOSP Git Manifest Tags (`https://android.googlesource.com/platform/manifest`, Access Date: 2025-05-16, Confidence: `VERIFIED`); Pixel Factory Images (`https://developers.google.com/android/images#shiba`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Support Status**: Current primary AOSP major release. Google Pixel 8 is fully supported with official AOSP target tree (`aosp_shiba-userdebug`).
- **CDD & CTS Availability**: Official Android 15 CDD and CTS v15 test suites published (`https://source.android.com/docs/compatibility/15/android-15-cdd`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Hardware & Driver Availability**: Driver binaries published for Pixel 8 (`shiba`) on Android 15 (`https://developers.google.com/android/drivers#shiba`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Security Features**: Advanced security controls, updated Linux 6.1 LTS kernel baseline, AVB 2.0 with custom key relocking, Titan M2 StrongBox KeyMint 3.0, FBE v2, metadata encryption, and multi-user isolation APIs.

## Comparison Against DeeX Requirements

| Feature / Requirement | Android 14 Baseline | Android 15 Baseline | DeeX Requirement / Alignment |
|---|---|---|---|
| **AOSP Target Build** | `aosp_shiba-userdebug` | `aosp_shiba-userdebug` | Required for building baseline Pixel 8 system images |
| **Titan M2 StrongBox** | KeyMint 2.0 / 3.0 | KeyMint 3.0 | Hardware root of trust for DeeX Vault (Master Plan 5.3) |
| **Verified Boot (AVB)** | Custom key relock supported | Custom key relock supported | Required for custom key chain of trust (Master Plan 3) |
| **Storage Encryption** | FBE v2 + Metadata | FBE v2 + Metadata | Required for per-account encryption (Master Plan 5) |
| **Multi-User Isolation** | Native Multi-User | Native Multi-User | Foundation for DeeX Isolation (Master Plan 7) |
| **Kernel Baseline** | Linux 5.15 / 6.1 LTS | Linux 6.1 LTS | Kernel protection and resource accounting (Master Plan 4) |
| **Support Horizon** | Active | Active (7 years through Oct 2030) | Maximum long-term security maintenance |

## Recommendation

**Recommended Release**: **Android 15 (`android-15.0.0_r1` tag or latest stable release tag e.g. `android-15.0.0_r17`)**.

**Reasoning**:
1. **Longest Support Horizon**: Pixel 8 receives security updates through October 2030. Android 15 is the primary forward-looking base for Pixel 8 development.
2. **Kernel Baseline**: Ships with kernel 6.1 LTS baseline providing enhanced security hardening, BPF features, and memory isolation primitives required for multi-account resource accounting (Master Plan 4.3).
3. **First-Party Target**: `aosp_shiba` is a tier-1 first-party target in AOSP Android 15, simplifying driver, vendor HAL, and CTS compliance workflows.

**Risks & Mitigation**:
- *Risk*: Android 15 CDD/CTS requirements are stricter for background execution and multi-user service binding.
- *Mitigation*: Comprehensive CTS testing in Chunk 13 and modular isolation architecture under DeeX Isolation.

## Decision

`UNDECIDED — awaiting project owner`

The release selection is submitted as `PROPOSED`. The final choice belongs to the project owner. Until confirmed by the owner, repo manifests will use the `aosp-pinned.xml.template` format per Chunk 3 prompt specifications.

---

## Decision Record for Owner

The project owner must confirm the preferred AOSP release by completing the fields below:

```text
===================================================================
DECISION RECORD FOR OWNER
===================================================================
Confirmed AOSP Release: [ OWNER FILL IN: e.g. Android 15 (android-15.0.0_r1) ]
Exact Revision / Tag:   [ OWNER FILL IN: e.g. android-15.0.0_r1 (AP3A.241005.015) ]
Date of Decision:       [ OWNER FILL IN: YYYY-MM-DD ]
Owner Rationale:        [ OWNER FILL IN: Rationale for release choice ]
Owner Signer / Title:   [ OWNER FILL IN: Owner Name / Title ]
===================================================================
```
