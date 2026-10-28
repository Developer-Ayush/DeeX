# DeeX Kernel Feasibility and Risk Assessment

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 4, 4.1, 4.2, 4.3, 4.4, 13.3, 13.4, 17.7

---

## 1. Executive Feasibility Assessment

This assessment evaluates whether the selected target hardware, **Google Pixel 8 (`shiba`)** on **Android 15 (`android-15.0.0_r1` / Google Tensor G3 `zuma`)**, can satisfy each kernel requirement defined in Master Plan Section 4 using cited primary source documentation.

Because baseline hardware testing is currently `NOT YET EVIDENCED`, all physical runtime behaviors are assessed as `PROBABLY — needs physical verification`.

---

## 2. Requirement Assessment Headline Matrix

| Master Plan Requirement | Primary Source Evidence Citation | Feasibility Label | Key Technical Finding / Risk |
|---|---|---|---|
| **MP 4.1 Platform Architecture & ARM64 Support** | `https://android.googlesource.com/kernel/manifest` | `SUPPORTED (evidence)` | Tensor G3 (`zuma`) ARMv8.2+ 64-bit kernel baseline (`android-gs-zuma-6.1`). |
| **MP 4.2 Hardware Subsystem Driver Retention** | `https://store.google.com/product/pixel_8_specs` | `PROBABLY — needs physical verification` | Official Pixel kernel tree contains all drivers; physical probe verification required. |
| **MP 4.2 Memory Protection (KASLR, CFI, SCS, PAN)** | `https://source.android.com/docs/security/bulletin/kernel-selections` | `SUPPORTED (evidence)` | ARM64 KASLR, Clang CFI, ShadowCallStack, and PAN/PXN mandatory in GKI 6.1. |
| **MP 4.2 Mandatory Access Control (SELinux Enforcing)** | `https://source.android.com/docs/security/features/selinux` | `SUPPORTED (evidence)` | SELinux enforcing supported natively in AOSP Android 15. |
| **MP 4.2 File-Based Encryption (fscrypt) Support** | `https://source.android.com/docs/security/features/encryption/file-based` | `SUPPORTED (evidence)` | Native `fscrypt` with UFS inline hardware encryption. |
| **MP 4.2 Debug Interface Restrictions** | `https://source.android.com/docs/security/bulletin/kernel-selections` | `SUPPORTED (evidence)` | `kgdb` disabled and `kptr_restrict=2` standard in AOSP release builds. |
| **MP 4.2 Secret Non-Disclosure in Kernel Logs** | `https://source.android.com/docs/core/tests/debug/evaluating-logs` | `PROBABLY — needs physical verification` | Specification rule defined; requires physical crash dump log analysis. |
| **MP 4.2 Titan M2 Secure Hardware Interface** | `https://android.googlesource.com/kernel/manifest` | `SUPPORTED (evidence)` | Citadel/Nos driver (`CONFIG_GOOGLE_NOS`) exposes `/dev/citadel0` or `/dev/nos0`. |
| **MP 4.3 Resource Accounting & System Safety Thresholds** | `https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html` | `PROBABLY — needs physical verification` | Linux cgroups v2 single hierarchy natively available; load overhead needs physical test. |
| **MP 4.3 Hardware Thermal Protection Boundary** | `https://source.android.com/docs/core/power/thermal-mitigation` | `SUPPORTED (evidence)` | Thermal zone governors and hardware thermal diodes operate independently. |
| **MP 4.4 Account Process vs. System Process Accounting** | `https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html` | `SUPPORTED (evidence)` | System versus account cgroup slice hierarchy supported natively. |

---

## 3. Top Three Highest Technical Risks

### Risk 1: Verified Boot & Custom AVB Key Interaction with Kernel Modifications
- **Description**: Rebuilding or configuring vendor kernel modules (`vendor_dlkm.img`) requires re-signing partition headers. If custom AVB root key enrollment (`fastboot flash avb_custom_key`) on Android 15 Google Pixel 8 exhibits vendor firmware bugs, bootloader relocking will result in immediate ORANGE state warnings or boot loops.
- **Mitigation Strategy**: Follow Staged Transition Strategy in ADR-0004 Option A (keep `userdebug` unlocked bootloader during early bringup; verify custom key enrollment on physical hardware before locking).

### Risk 2: Closed-Source Vendor Driver Isolation Boundaries
- **Description**: Hardware functions for cellular radio kill-switch, Wi-Fi, Bluetooth, NFC, biometrics, and Titan M2 execute proprietary, closed-source vendor firmware blobs (`vendor_dlkm` / vendor binaries).
- **Mitigation Strategy**: DeeX interacts strictly via standard Android HAL/sysfs interfaces, enforces SELinux isolation around character device nodes, and performs physical RF shielding and test field verification during hardware testing.

### Risk 3: Resource Accounting Overhead under Multi-Account Load
- **Description**: Continuous eBPF socket tracing and cgroups v2 memory pressure monitoring across multiple concurrent ordinary account sessions could introduce CPU scheduling jitter or memory overhead on the Tensor G3 SoC.
- **Mitigation Strategy**: Enforce initial design targets as management policies (not guarantees), prioritize `system.slice` with high cgroup weights, and validate overhead during physical hardware load testing.
