# DeeX Kernel Configuration Requirements Catalogue

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 2.4, 4.1, 4.2, 4.3, 5.2, 7.3, 17.2

---

## 1. Overview & Verification Rules

This catalogue specifies the mandatory kernel configuration requirements for DeeX builds on Google Pixel 8 (`shiba` on Android 15 / Tensor G3 `zuma`). Each requirement describes the intended functional behavior, rationale, primary source citation, build variant applicability, and verification method.

### Strict Citation Rule for Kernel Configuration Symbols
To prevent unverified options from memory, any explicit `CONFIG_` option name or kernel command-line parameter included in this document MUST have a primary source citation on the exact same line [Primary Source: AOSP Hardened Kernel Selections, `https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

---

## 2. Kernel Configuration Requirements Catalogue (`KCFG-` Series)

### KCFG-001: File-Based Encryption (fscrypt) File System Support
- **Intent**: Enable kernel native file-based encryption (`fscrypt`) and hardware inline encryption drivers for UFS storage, supporting per-directory encryption policies required for multi-account storage isolation in DeeX Vault.
- **Rationale**: Master Plan Section 4.1, 4.2, 5.2 (`REQ-005`, `KERN-004`).
- **Primary Citation**: `CONFIG_FS_ENCRYPTION=y` [Primary Source: AOSP File-Based Encryption Documentation, `https://source.android.com/docs/security/features/encryption/file-based`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Inspect kernel configuration build artifact for the filesystem encryption parameter [Primary Source: AOSP File-Based Encryption Documentation, `https://source.android.com/docs/security/features/encryption/file-based`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

### KCFG-002: Mandatory Access Control via SELinux LSM
- **Intent**: Enable Security-Enhanced Linux (SELinux) Linux Security Module with default enforcing mode support and Multi-Category Security (MCS) labeling for multi-account process separation.
- **Rationale**: Master Plan Section 4.1, 4.2, 7.3 (`REQ-004`, `REQ-006`, `KERN-003`).
- **Primary Citation**: `CONFIG_SECURITY_SELINUX=y` [Primary Source: AOSP SELinux Documentation, `https://source.android.com/docs/security/features/selinux`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Verify `/sys/fs/selinux` filesystem present and SELinux status enforcing.

### KCFG-003: Control Groups v2 Single Hierarchy & Resource Controllers
- **Intent**: Enable cgroups v2 unified single hierarchy with CPU, memory, and IO controllers enabled for resource accounting and multi-account resource throttling.
- **Rationale**: Master Plan Section 4.3, 4.4, 7.5 (`RULE-001`, `RULE-002`, `KERN-008`).
- **Primary Citation**: `CONFIG_CGROUPS=y` [Primary Source: Linux Kernel Cgroup v2 Documentation, `https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Inspect `/sys/fs/cgroup/cgroup.controllers` for `cpu memory io`.

### KCFG-004: eBPF Subsystem & BPF Loader Support
- **Intent**: Enable kernel extended Berkeley Packet Filter (eBPF) loader, socket filtering, and cgroup socket probes required for system resource accounting and network isolation.
- **Rationale**: Master Plan Section 4.3, 9.6, 9.7 (`KERN-008`, `KERN-010`).
- **Primary Citation**: `CONFIG_BPF_SYSCALL=y` [Primary Source: AOSP eBPF Architecture, `https://source.android.com/docs/core/architecture/kernel/bpf`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Verify `bpfloader` daemon loads eBPF programs without kernel rejection.

### KCFG-005: Clang Control Flow Integrity (CFI) Forward-Edge Protection
- **Intent**: Enable kernel Clang Control Flow Integrity (CFI) to restrict indirect function call targets and prevent Return/Jump-Oriented Programming (ROP/JOP) attacks.
- **Rationale**: Master Plan Section 4.1, 4.2 (`REQ-004`, `KERN-002`).
- **Primary Citation**: `CONFIG_CFI_CLANG=y` [Primary Source: AOSP Control Flow Integrity, `https://source.android.com/docs/security/test/cfi`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Verify Clang CFI compiler flags active during kernel build.

### KCFG-006: Kernel Address Space Layout Randomization (KASLR)
- **Intent**: Enable kernel code and data placement randomization at boot time to prevent hardcoded address exploitation.
- **Rationale**: Master Plan Section 4.1, 4.2 (`REQ-004`, `KERN-002`).
- **Primary Citation**: `CONFIG_RANDOMIZE_BASE=y` [Primary Source: AOSP Hardened Kernel Selections, `https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Confirm kernel text base address changes across successive reboots.

### KCFG-007: ShadowCallStack (SCS) Stack Protection for ARM64
- **Intent**: Allocate a separate, non-executable shadow call stack for return addresses to prevent stack buffer overflow return address overwrites on ARM64.
- **Rationale**: Master Plan Section 4.1, 4.2 (`REQ-004`, `KERN-002`).
- **Primary Citation**: `CONFIG_SHADOW_CALL_STACK=y` [Primary Source: AOSP ShadowCallStack Documentation, `https://source.android.com/docs/security/test/shadow-call-stack`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Verify shadow call stack configuration in kernel config [Primary Source: AOSP ShadowCallStack Documentation, `https://source.android.com/docs/security/test/shadow-call-stack`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

### KCFG-008: Restricted Kernel Address Pointer Display (kptr_restrict)
- **Intent**: Restrict printing of kernel raw pointers in `/proc/kallsyms` and `/proc/modules` to zero for non-privileged users to prevent address leaks.
- **Rationale**: Master Plan Section 4.2, 17.2 (`REQ-004`, `KERN-005`).
- **Primary Citation**: `kptr_restrict=2` sysctl setting [Primary Source: AOSP Hardened Kernel Selections, `https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Testing, Release.
- **Verification Method**: Check runtime sysctl `cat /proc/sys/kernel/kptr_restrict` returns `2`.

### KCFG-009: Prohibition of Kernel Debugging Interfaces in Release Builds
- **Intent**: Disable kernel interactive debugging facilities (`kgdb`, `/proc/kcore`) and restrict kernel tracing (`ftrace`) in release builds.
- **Rationale**: Master Plan Section 4.2, 17.2 (`REQ-004`, `BOOT-007`, `KERN-005`).
- **Primary Citation**: Disable `CONFIG_KGDB` in release builds [Primary Source: AOSP Hardened Kernel Selections, `https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Release (Disabled); Development/Testing (Restricted).
- **Verification Method**: Verify kernel debugger option is unset in release build config [Primary Source: AOSP Hardened Kernel Selections, `https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

### KCFG-010: Titan M2 Secure Hardware Device Driver Configuration
- **Intent**: Enable character device driver support for the Titan M2 Citadel/Nos secure hardware element (`/dev/citadel0` or `/dev/nos0`).
- **Rationale**: Master Plan Section 4.2, 5.2, 6.3 (`REQ-004`, `KERN-007`).
- **Primary Citation**: `CONFIG_GOOGLE_NOS=m` [Primary Source: AOSP Pixel Kernel Source Tree, `https://android.googlesource.com/kernel/manifest`, Access Date: 2025-05-16, Confidence: `VERIFIED`].
- **Build Variant Applicability**: Development, Testing, Release.
- **Verification Method**: Confirm presence of `/dev/citadel0` or `/dev/nos0` device node with permissions `0660 system keystore`.

---

## 3. Configuration Catalogue Summary Table

| Requirement ID | Configuration Intent / Symbol | Primary Source Citation | Variant Applicability | Verification Method |
|---|---|---|---|---|
| `KCFG-001` | `CONFIG_FS_ENCRYPTION=y` | `https://source.android.com/docs/security/features/encryption/file-based` | All | Config check |
| `KCFG-002` | `CONFIG_SECURITY_SELINUX=y` | `https://source.android.com/docs/security/features/selinux` | All | `/sys/fs/selinux` check |
| `KCFG-003` | `CONFIG_CGROUPS=y` | `https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html` | All | `/sys/fs/cgroup` check |
| `KCFG-004` | `CONFIG_BPF_SYSCALL=y` | `https://source.android.com/docs/core/architecture/kernel/bpf` | All | eBPF loader check |
| `KCFG-005` | `CONFIG_CFI_CLANG=y` | `https://source.android.com/docs/security/test/cfi` | All | Compiler flags check |
| `KCFG-006` | `CONFIG_RANDOMIZE_BASE=y` | `https://source.android.com/docs/security/bulletin/kernel-selections` | All | Reboot address check |
| `KCFG-007` | `CONFIG_SHADOW_CALL_STACK=y` | `https://source.android.com/docs/security/test/shadow-call-stack` | All | Config check |
| `KCFG-008` | `kptr_restrict=2` | `https://source.android.com/docs/security/bulletin/kernel-selections` | Testing, Release | Sysctl check |
| `KCFG-009` | Disable `CONFIG_KGDB` | `https://source.android.com/docs/security/bulletin/kernel-selections` | Release | Config check |
| `KCFG-010` | `CONFIG_GOOGLE_NOS=m` | `https://android.googlesource.com/kernel/manifest` | All | Character device node check |
