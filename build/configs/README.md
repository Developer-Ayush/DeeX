# DeeX Build Configuration Policies

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 4.2, 16.2, 17.2

## Overview

This directory defines the operational build configuration policies for the DeeX operating system across three distinct build tiers: Development, Testing, and Release.

These documents establish strict policy rules regarding AOSP build variants, allowed debugging facilities, cryptographic key tiers, module stubbing prohibitions, logging safety, and required build success evidence.

## Configuration Index

| Configuration Document | AOSP Build Variant | Target Key Identifier | Purpose | Primary Rule |
|---|---|---|---|---|
| [`development.md`](development.md) | `eng` / `userdebug` | `deex-dev-key-01` | Active module engineering, driver bring-up, interactive debugging | Developer access; stubs permitted in early bring-up |
| [`testing.md`](testing.md) | `userdebug` | `deex-test-key-01` | Automated regression testing, CTS/CDD verification, security fuzzing | Test harness enabled; strict log secret filtering |
| [`release.md`](release.md) | `user` | `deex-release-key-01` | Production image creation for end-user smartphones | **No debug privileges; NO mock/stub security modules** |

## Primary Source Citation

- AOSP Build Variants Documentation: `https://source.android.com/docs/setup/build/building#choose-a-target` (Access Date: 2025-05-16, Confidence: `VERIFIED`).
  - `user`: Limited access; suited for production images.
  - `userdebug`: Same as `user`, but with root access and debuggability.
  - `eng`: Development configuration with additional debugging tools.
