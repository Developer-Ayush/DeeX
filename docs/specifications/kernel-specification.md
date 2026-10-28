# DeeX Kernel Specification

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 1.3, 4, 4.1, 4.2, 4.3, 4.4, 5.2, 7.3, 7.5, 7.6, 9.6, 9.7, 14.5, 15.7, 17

---

## 1. Scope & System Overview

This specification establishes the mandatory technical requirements for the **DeeX Kernel** on the selected target platform, **Google Pixel 8 (`shiba`)** running Android 15 (`android-15.0.0_r1` on Google Tensor G3 / `zuma`).

The kernel provides the baseline hardware abstraction, process isolation boundaries, mandatory access control enforcement, encrypted filesystem acceleration, device interface retention, resource accounting, and security interface exposure required by higher-level DeeX system services (DeeX Vault, Identity, Isolation, Connect, Bridge, and Lifecycle).

---

## 2. Requirement Definitions (`KERN-` Series)

### KERN-001: Platform Architecture and Hardware Driver Retention
- **Description**: The kernel MUST support the ARM64 target architecture (ARMv8.2+ / Google Tensor G3 `zuma`) and retain full hardware driver functionality for all physical subsystems specified in Master Plan Section 4.2: display, touchscreen, audio, camera, cellular modem, UFS storage, Wi-Fi, Bluetooth, GPS, NFC, fingerprint sensor, ambient sensors, USB controller, power management, and Titan M2 secure hardware element.
- **Traceability**: Master Plan 4.1, 4.2; `REQ-001`, `REQ-002`.
- **Primary Source Citation**: AOSP Kernel Source Repositories (`https://android.googlesource.com/kernel/manifest`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-002: Kernel-Level Memory Protections & Process Isolation
- **Description**: The kernel MUST enforce documented ARM64 hardware and software memory protections, including KASLR (Kernel Address Space Layout Randomization), Clang CFI (Control Flow Integrity), SCS (ShadowCallStack for backward-edge stack protection), Privileged Access Never / Privileged Execute Never (PAN/PXN), and Yama ptrace restriction (`kernel.yama.ptrace_scope = 1` or higher).
- **Traceability**: Master Plan 4.1, 4.2, 7.3; `REQ-004`, `REQ-006`.
- **Primary Source Citation**: AOSP Kernel Security Features (`https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-003: Mandatory Access Control (SELinux Enforcing)
- **Description**: The kernel MUST execute SELinux LSM in strict `enforcing` mode in release builds. Permissive SELinux domains MUST NOT be present in production release builds. The kernel MUST support Multi-Category Security (MCS) labels required for multi-account process separation in the Isolation module.
- **Traceability**: Master Plan 4.1, 4.2, 7.3; `REQ-004`, `REQ-006`.
- **Primary Source Citation**: AOSP SELinux Documentation (`https://source.android.com/docs/security/features/selinux`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Testing (enforcing with audit logs), Release (enforcing strict).

### KERN-004: File-Based Encryption (FBE / fscrypt) Support
- **Description**: The kernel MUST enable native Linux `fscrypt` support and hardware-accelerated inline encryption for UFS storage, supporting per-directory encryption policies required by DeeX Vault for multi-account filesystem isolation (AES-256-XTS for payload encryption, AES-256-CTS for filename encryption).
- **Traceability**: Master Plan 4.1, 4.2, 5.2; `REQ-004`, `REQ-005`.
- **Primary Source Citation**: AOSP Storage Encryption (`https://source.android.com/docs/security/features/encryption/file-based`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-005: Restricted Debugging and Privileged Interfaces
- **Description**: Production release kernel configurations MUST disable kernel debugging and tracing facilities, including `CONFIG_KGDB`, `CONFIG_FTRACE`, `/proc/kcore`, and unprivileged access to `/proc/kallsyms` (`kptr_restrict = 2`). Privileged debugging facilities required during bringup MUST be restricted to development and testing build variants only.
- **Traceability**: Master Plan 4.1, 4.2, 17.2; `REQ-004`; `BOOT-007`.
- **Primary Source Citation**: AOSP Hardened Kernel Configs (`https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Release (fully restricted); Development/Testing (restricted with debug logging).

### KERN-006: Kernel Logging Rules & Secret Non-Disclosure
- **Description**: The kernel logging subsystem (`dmesg`, `pstore`, crash dumps, panic logs) MUST NOT output sensitive security assets, including passwords, raw encryption keys, key derivation material, biometric templates, PINs, or private account data.
- **Traceability**: Master Plan 4.2, 17.2; `REQ-004`.
- **Primary Source Citation**: AOSP Logging Practices (`https://source.android.com/docs/core/tests/debug/evaluating-logs`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-007: Titan M2 Secure Hardware Interface Exposure
- **Description**: The kernel MUST correctly load and expose the vendor secure element character device driver interface (`/dev/citadel0` or `/dev/nos0`) with strict file permissions (`0660`, owner `system`, group `keystore`) to allow DeeX Vault and Identity services to interact with Titan M2 StrongBox KeyMint and Weaver hardware.
- **Traceability**: Master Plan 4.2, 5.2, 6.3; `REQ-004`, `REQ-005`.
- **Primary Source Citation**: AOSP KeyMint & StrongBox Overview (`https://source.android.com/docs/security/features/keystore`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-008: System-Wide Resource Accounting & Threshold Policy
- **Description**: The kernel MUST provide system-wide CPU and RAM accounting using cgroups v2 single hierarchy and eBPF probes. Accounting MUST distinguish ordinary account processes from essential system processes. The kernel subsystem MUST enforce initial resource targets:
  - System CPU safety threshold: approximately 80–90% utilization limit (`RULE-001`).
  - System RAM reserve: approximately 10–20% memory reserve for kernel and essential system processes (`RULE-002`).
- **Traceability**: Master Plan 4.3, 4.4, 7.5, 7.6; `RULE-001`, `RULE-002`.
- **Primary Source Citation**: Linux Kernel Cgroup v2 Documentation (`https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-009: Background Sanitization Resource Throttling Interface
- **Description**: The kernel MUST expose cgroup v2 CPU and IO throttling controls to allow the DeeX Lifecycle module to execute background storage sanitization when system CPU utilization is below approximately 40–50% (`RULE-019`), and automatically pause or throttle sanitization tasks when CPU utilization exceeds that threshold.
- **Traceability**: Master Plan 4.4, 14.5; `RULE-019`.
- **Primary Source Citation**: Linux Kernel Cgroup v2 CPU Controller (`https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#cpu`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-010: Inter-Module Service Interface Support
- **Description**: The kernel MUST provide documented kernel interfaces for other DeeX modules:
  - **DeeX Vault**: `fscrypt` ioctls and Titan M2 character device.
  - **DeeX Isolation**: cgroups v2, namespaces (mnt, pid, net), SELinux MCS labels.
  - **DeeX Connect**: Radio kill-switch RFKILL subsystem, NFC subsystem control, eBPF socket filters (Master Plan 9.6, 9.7, 9.8).
  - **DeeX Bridge**: USB gadget ConfigFS interface for controlled USB access (Master Plan 10.2).
  - **DeeX Lifecycle**: Resource throttling interfaces for sanitization.
- **Traceability**: Master Plan 4.1, 5.2, 7.3, 9.6, 9.7, 10.2, 14.5; `REQ-005`, `REQ-006`, `REQ-009`, `REQ-010`.
- **Primary Source Citation**: Linux Kernel USB ConfigFS & RFKILL Documentation (`https://www.kernel.org/doc/html/latest/driver-api/usb/gadget.html`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Development, Testing, Release.

### KERN-011: Build-Variant Kernel Configuration Separation
- **Description**: Kernel build configurations MUST strictly differentiate between `development`, `testing`, and `release` build variants:
  - **Development**: Debugging enabled (`ftrace`, ADB enabled, UART/console logging active, SELinux enforcing/permissive logging).
  - **Testing**: Automated test hooks enabled, SELinux enforcing, restricted debug tracing with audit logging.
  - **Release**: Debugging completely disabled, SELinux enforcing strict, console logging silenced, ADB disabled by default, full security restrictions enforced.
- **Traceability**: Master Plan 2.4, 4.1, 4.2; `REQ-004`; `BOOT-007`.
- **Primary Source Citation**: AOSP Build Variants (`https://source.android.com/docs/setup/build/building`, Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Build Variant Applicability**: Meta-requirement governing all variants.

### KERN-012: Explicit Non-Goals & Protection Boundaries
- **Description**: The kernel design MUST explicitly record its protection boundaries and non-goals:
  - **No Protection Against Core Kernel Compromise**: If an attacker gains arbitrary kernel read/write execution (e.g. via a zero-day kernel memory corruption exploit), kernel-level isolation guarantees are invalidated.
  - **No Thermal Protection Override**: Kernel resource accounting thresholds operate purely as high-level management policies and DO NOT replace or override hardware/firmware thermal safety governors.
- **Traceability**: Master Plan 4.3, 17.7; `REQ-013`.
- **Primary Source Citation**: Master Plan 4.3, 17.7.
- **Build Variant Applicability**: Development, Testing, Release.

---

## 3. Requirements Mapping Matrix

| Requirement ID | Master Plan Section | Derived REQ / RULE ID | Target Release | Test Plan ID |
|---|---|---|---|---|
| `KERN-001` | MP 4.1, 4.2 | `REQ-001`, `REQ-002` | All Variants | `TEST-KERN-001` |
| `KERN-002` | MP 4.1, 4.2, 7.3 | `REQ-004`, `REQ-006` | All Variants | `TEST-KERN-002` |
| `KERN-003` | MP 4.1, 4.2, 7.3 | `REQ-004`, `REQ-006` | Testing, Release | `TEST-KERN-003` |
| `KERN-004` | MP 4.1, 4.2, 5.2 | `REQ-004`, `REQ-005` | All Variants | `TEST-KERN-004` |
| `KERN-005` | MP 4.1, 4.2, 17.2 | `REQ-004`, `BOOT-007` | Release | `TEST-KERN-005` |
| `KERN-006` | MP 4.2, 17.2 | `REQ-004` | All Variants | `TEST-KERN-006` |
| `KERN-007` | MP 4.2, 5.2, 6.3 | `REQ-004`, `REQ-005` | All Variants | `TEST-KERN-007` |
| `KERN-008` | MP 4.3, 4.4, 7.5, 7.6 | `RULE-001`, `RULE-002` | All Variants | `TEST-KERN-008` |
| `KERN-009` | MP 4.4, 14.5 | `RULE-019` | All Variants | `TEST-KERN-009` |
| `KERN-010` | MP 4.1, 5.2, 7.3, 9.6, 10.2, 14.5 | `REQ-005`, `REQ-006`, `REQ-009`, `REQ-010` | All Variants | `TEST-KERN-010` |
| `KERN-011` | MP 2.4, 4.1, 4.2 | `REQ-004`, `BOOT-007` | All Variants | `TEST-KERN-011` |
| `KERN-012` | MP 4.3, 17.7 | `REQ-013` | All Variants | `TEST-KERN-012` |
