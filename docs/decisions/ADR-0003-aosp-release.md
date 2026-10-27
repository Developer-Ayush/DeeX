# ADR-0003: AOSP Baseline Release Selection for Google Pixel 8 (shiba)

- **Status**: ACCEPTED
- **Date**: 2025-05-16
- **Authors**: Jules (AI Build & Release Engineer)
- **Owning Module**: DeeX Base
- **Master Plan Sections**: 2.1, 2.2, 13.2, 16.2, 17

## Context

DeeX requires a pinned AOSP baseline release for the selected target device, **Google Pixel 8 (`shiba`)**. The chosen release serves as the upstream source foundation for all system framework modifications, kernel drivers, security services (DeeX Vault, Identity, Isolation, Bridge, Connect), Android Compatibility Definition Document (CDD) alignment, and Compatibility Test Suite (CTS) verification (Master Plan Sections 2, 13.2).

## Decision

**Android 15 (`android-15.0.0_r1` / Build ID `AP3A.240905.015.A2`)**

The project owner explicitly confirmed the Android 15 release decision for Google Pixel 8 (`shiba`) during Chunk 4 requirements confirmation ("I select Option A (CONFIRM). Android 15 for the Google Pixel 8 (shiba) is my decision as project owner. Update ADR-0003 to ACCEPTED citing this message.").

### Tag Selection & Security Patch Analysis
- **Selected Baseline Tag**: `android-15.0.0_r1` (Build ID `AP3A.240905.015.A2`, Security Patch Level `2024-09-05`, Primary Source: Google Official Codenames, Tags, and Build Numbers, `https://source.android.com/docs/setup/about/build-numbers`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Newer Tags / Patch Level Analysis**: Newer monthly security update tags exist in the `android-15.0.0` release family (up to `android-15.0.0_r36` / `BP1A.250505.005.D1` as of May 2025; specifically `android-15.0.0_r34` / `BP1A.250505.005.B1` for Pixel 8 `shiba`). `android-15.0.0_r1` is selected as the initial reproducible baseline tag for toolchain stabilization, with monthly security patches to be ingested via manifest pin updates in future maintenance chunks.

## Consequence & Manifest Instantiation

With this decision ACCEPTED, `build/manifests/aosp-pinned.xml` is instantiated from the upstream manifest at tag `android-15.0.0_r1`. Every upstream project (1,425 total repositories) is pinned to an exact 40-character hexadecimal commit hash. `tools/verify-manifest-pins.sh` confirms zero floating branches or unresolved entries.

---

## Decision Record for Owner

```text
===================================================================
DECISION RECORD FOR OWNER
===================================================================
Confirmed AOSP Release: Android 15
Exact Revision / Tag:   android-15.0.0_r1 (AP3A.240905.015.A2)
Date of Decision:       2025-05-16
Owner Rationale:        Confirmed by project owner in Chunk 4 prompt response ("I select Option A (CONFIRM). Android 15 for the Google Pixel 8 (shiba) is my decision as project owner. Update ADR-0003 to ACCEPTED citing this message."). Selected as forward-looking base supporting Google Pixel 8 Tensor G3, Titan M2 StrongBox KeyMint 3.0, Linux 6.1 LTS kernel baseline, and 7-year security update window through October 2030.
Owner Signer / Title:   Project Owner
===================================================================
```
