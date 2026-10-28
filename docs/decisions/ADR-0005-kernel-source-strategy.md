# ADR-0005: DeeX Target Kernel Source Strategy for Google Pixel 8 (shiba)

- **Status**: PROPOSED
- **Date**: 2025-05-16
- **Authors**: Jules (AI Kernel & Security Architect)
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 1.3, 4.1, 4.2, 13.3, 13.4, 17.7

## Context

DeeX requires a defined kernel source strategy for the target hardware platform, **Google Pixel 8 (`shiba`)** on **Android 15 (`android-15.0.0_r1`)**.

The kernel source strategy directly affects system stability, hardware driver support (display, touchscreen, audio, camera, cellular modem, Titan M2 secure hardware element), verified boot chain integrity (ADR-0004), long-term security patch maintenance, GPLv2 license compliance, and Compatibility Test Suite (CTS) alignment (Master Plan Sections 4, 13.3, 13.4).

Three primary options exist for the kernel source strategy on Google Pixel 8:

1. **Option (a): Official Pixel Kernel Source Tree (`android-gs-zuma-6.1`)**
   - Use Google's published device-specific kernel source tree for Google Pixel 8 (`shiba` / Google Tensor G3 `zuma`), including first-party vendor module drivers.
2. **Option (b): Android Common Kernel (ACK) + Vendor GKI Modules**
   - Use the generic upstream Android Common Kernel (`kernel/common` at Linux 6.1 LTS) and dynamically load stock Google vendor modules (`vendor_dlkm.img`).
3. **Option (c): Staged Strategy**
   - Use Option (b) (generic ACK + stock vendor modules) for initial baseline bringup and testing; transition to Option (a) (rebuilding Pixel kernel tree with hardened DeeX configuration options) after physical hardware verification is complete.

---

## Options Evaluated

### Option (a): Official Pixel Kernel Source Tree (`android-gs-zuma-6.1`)
- **Description**: Rebuild the entire kernel (`boot.img` core kernel and `vendor_dlkm.img` vendor modules) directly from Google's `android-gs-zuma-6.1` source branch.
- **Consequences**:
  - *Pros*: Full control over kernel build configuration; permits custom `CONFIG_` hardening options across both core kernel and vendor modules.
  - *Cons*: High build complexity; requires vendor toolchain setup; requires AVB signing key coordination for both `boot.img` and `vendor_dlkm.img` under ADR-0004.
  - *GPL Compliance*: All modified GPLv2 core kernel sources must be published upon distribution.
  - *CTS Risk*: Rebuilt kernel modules could exhibit subtle timing or driver differences affecting CTS compatibility.

### Option (b): Android Common Kernel (ACK) + Stock Vendor Modules
- **Description**: Build only the generic AOSP GKI core kernel (`boot.img`) from `kernel/common`, while retaining prebuilt, Google-signed vendor modules in `vendor_dlkm.img`.
- **Consequences**:
  - *Pros*: Simplifies build process; ensures maximum vendor driver stability for cellular modem, Wi-Fi, and Titan M2.
  - *Cons*: Cannot alter configuration settings inside vendor modules; requires strict GKI KMI (Kernel Module Interface) ABI compatibility.
  - *CTS Risk*: Lower CTS risk for vendor drivers, but potential KMI version mismatch if generic ACK kernel diverges from vendor module ABI requirements.

### Option (c): Staged Approach (Generic ACK Bringup -> Official Tree Hardening)
- **Description**: Start with Option (b) during early bringup and testing to validate AOSP framework integration on physical hardware; transition to Option (a) for production release builds once custom AVB key flashing (`fastboot flash avb_custom_key`) is verified on physical hardware.
- **Consequences**:
  - *Pros*: Minimizes initial bricking risk; isolates OS build issues from kernel driver bugs during early development.
  - *Cons*: Deferred effort for custom kernel module builds.

---

## Strategic Considerations & Risks

1. **Interaction with ADR-0004 (Verified Boot Trust Model)**:
   - Modifying vendor modules (`vendor_dlkm.img`) requires re-signing the `vendor_dlkm` partition hash tree with custom AVB keys. This depends on successful execution of Phase 2 in ADR-0004 (physical custom key enrollment verification).
2. **GPLv2 Licensing Implications**:
   - The Linux kernel core is licensed under GPLv2. If DeeX distributes kernel binary modifications, corresponding source code modifications must be made available. Per project owner direction, DeeX avoids out-of-tree kernel patches and relies strictly on configuration settings, eBPF, and user-space policy.
3. **Upstream Maintenance & Security Patch Burden**:
   - Google releases monthly security patches for `android-gs-zuma-6.1`. Selecting Option (a) or (c) requires ingesting monthly Google kernel security updates into the DeeX build tree.

---

## Decision Record for Owner

Per project owner direction, this ADR remains in **PROPOSED** status with decision **UNDECIDED — awaiting project owner**.

```text
===================================================================
DECISION RECORD FOR OWNER
===================================================================
Selected Kernel Source Strategy: UNDECIDED — awaiting project owner
Status:                         PROPOSED
Date of Decision:              2025-05-16
Owner Choice:                  [Option (a) Official Pixel Tree / Option (b) Generic ACK + Vendor Modules / Option (c) Staged Approach]
Owner Rationale:               Pending owner formal selection upon physical hardware test completion.
Owner Signer / Title:          Project Owner
===================================================================
```
