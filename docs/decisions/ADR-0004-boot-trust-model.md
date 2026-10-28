# ADR-0004: Verified Boot Trust Model and Custom Key Transition Strategy

- **Status**: PROPOSED
- **Date**: 2025-05-16
- **Authors**: Jules (AI Security Architect)
- **Owning Module**: DeeX Boot
- **Master Plan Sections**: 3.1, 3.2, 3.3, 13.3, 13.4, 17.7

## Context

DeeX requires a verified chain of trust from hardware root to the running OS (Master Plan Section 3). For the Google Pixel 8 (`shiba`), two primary options exist for managing the Android Verified Boot (AVB 2.0) root key:
1. Retaining Google's factory manufacturing trust model (device signed with AOSP/Google public keys, running in unlocked or Google-signed state).
2. Transitioning to owner-controlled custom AVB root keys embedded directly into Titan M2 secure element NVRAM via `fastboot flash avb_custom_key` and relocking the bootloader (`fastboot flashing lock`).

## Decision Options Evaluated

### Option A: Staged Transition Approach (RECOMMENDED BY ARCHITECT)
- **Phase 1 (Base & Early Bringup)**: Keep the manufacturer's stock trust model during initial baseline bringup and testing (`userdebug` variant, bootloader UNLOCKED / ORANGE state).
- **Phase 2 (Physical Verification)**: Execute physical hardware tests on target Pixel 8 to confirm that custom key enrollment (`fastboot flash avb_custom_key`) and bootloader relocking (`fastboot flashing lock`) succeed without bricking or triggering immutable boot loops.
- **Phase 3 (Production Enrolment)**: Transition to owner-controlled custom AVB root keys for official release images (`user` variant) and relock the device into `GREEN` state.

**Consequences**:
- *Pros*: Minimizes risk of bricking hardware during early development; permits iterative testing before locking hardware state.
- *Cons*: Temporarily leaves early bringup images in ORANGE state (unlocked bootloader).

### Option B: Immediate Transition to Owner-Controlled Custom AVB Keys
- Immediately generate production keys, flash custom AVB key, and relock bootloader in Chunk 6/7.

**Consequences**:
- *Pros*: Reaches final locked security posture immediately.
- *Cons*: High risk of hardware bricking if custom key handling or partition signing on Android 15 `shiba` exhibits unverified vendor firmware defects.

### Option C: Permanently Retain Manufacturer / Stock OEM Trust Model
- Rely on stock OEM root keys without custom key enrollment.

**Consequences**:
- *Pros*: No risk of custom key enrollment bricking.
- *Cons*: Violates DeeX core security requirement (Master Plan 3.3); system image changes could be signed by OEM keys or rejected.

## Proposed Recommendation

The architect recommends **Option A (Staged Approach)**. This matches the Project Owner's explicit requirement confirmation.

---

## Decision Record for Owner

```text
===================================================================
DECISION RECORD FOR OWNER
===================================================================
Selected Trust Model Strategy: UNDECIDED — awaiting project owner formal sign-off
Date of Decision:              2025-05-16
Owner Choice:                  [Option A (Staged) / Option B (Immediate) / Option C (Stock OEM)]
Owner Rationale:               Pending final owner signature upon physical hardware test completion.
Owner Signer / Title:          Project Owner
===================================================================
```
