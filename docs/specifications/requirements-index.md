# Requirements Index

This document provides a complete index of all mandatory requirements, numeric behavioral rules, and module-specific specification requirements from the DeeX Master Development Plan v1.0.

## Mandatory Requirements Index

| Requirement ID | Description | Source Section | Owning Module | Status |
|---|---|---|---|---|
| `REQ-001` | Run on the selected ARM64 smartphone hardware. | Section 1.2 | Base | Not started |
| `REQ-002` | Preserve the required Android framework and hardware interfaces. | Section 1.2 | Android | Not started |
| `REQ-003` | Pursue official Android compatibility, Google Mobile Services licensing, and Google Play access. | Section 1.2 | Google | Not started |
| `REQ-004` | Keep system code protected from ordinary users and external devices. | Section 1.2 | Vault / Boot | Not started |
| `REQ-005` | Provide separate, encrypted storage for every ordinary account. | Section 1.2 | Vault | Not started |
| `REQ-006` | Prevent cross-account access by applications, processes, and external devices. | Section 1.2 | Isolation | Not started |
| `REQ-007` | Support the specified root-account responsibilities without exposing ordinary account credentials. | Section 1.2 | Identity | Not started |
| `REQ-008` | Implement the defined authentication, failed-attempt, and lockout policies. | Section 1.2 | Identity | Not started |
| `REQ-009` | Provide controlled USB and wireless file access. | Section 1.2 | Bridge / Connect | Not started |
| `REQ-010` | Support the complete external-isolation switch. | Section 1.2 | Connect | Not started |
| `REQ-011` | Retain the Android and Windows compatibility toggles. | Section 1.2 | Android / Windows | Not started |
| `REQ-012` | Recover safely from power loss, interrupted updates, and interrupted account deletion. | Section 1.2 | Lifecycle | Not started |
| `REQ-013` | Test security properties rather than assuming that the design alone guarantees security. | Section 1.2 | Validation | Not started |
| `REQ-014` | Measure the actual installed size and resource usage from successful builds. | Section 1.2 | Release | Not started |

## Behavioral Rules and Numeric Thresholds Index

| Rule ID | Rule / Threshold | Exact Value | Source Section | Owning Module |
|---|---|---|---|---|
| `RULE-001` | System CPU safety threshold | Approximate 80–90% utilization range | Section 4.3 | Kernel |
| `RULE-002` | Reserved RAM reserve for kernel & essential system services | Approximately 10–20% of RAM | Section 4.3 | Kernel |
| `RULE-003` | Incorrect user ID attempts trigger for root prompt | 3 incorrect user ID attempts | Section 6.3 | Identity |
| `RULE-004` | Ordinary account 1st group of 3 failed passwords lockout | 30 seconds | Section 6.4 | Identity |
| `RULE-005` | Ordinary account 2nd group of 3 failed passwords lockout | 1 minute | Section 6.4 | Identity |
| `RULE-006` | Ordinary account 3rd group of 3 failed passwords lockout | 2 minutes | Section 6.4 | Identity |
| `RULE-007` | Ordinary account 4th group of 3 failed passwords lockout | 4 minutes | Section 6.4 | Identity |
| `RULE-008` | Ordinary account 5th group of 3 failed passwords lockout | 8 minutes | Section 6.4 | Identity |
| `RULE-009` | Ordinary account additional failed password groups scaling | Every additional group of three failures doubles previous duration | Section 6.4 | Identity |
| `RULE-010` | Root password 1st group of 3 failures lockout | 30 seconds | Section 6.5 | Identity |
| `RULE-011` | Root password 2nd group of 3 failures lockout | 1 minute | Section 6.5 | Identity |
| `RULE-012` | Root password 3rd group of 3 failures lockout | 2 minutes | Section 6.5 | Identity |
| `RULE-013` | Root password additional failed groups scaling | Subsequent groups of three double previous duration | Section 6.5 | Identity |
| `RULE-014` | Fingerprint failure disablement threshold | 11 failed fingerprint verifications permanently disable fingerprint login until successful password auth | Section 6.7 | Identity |
| `RULE-015` | USB authentication 1st group of 3 failures lockout | 30 seconds | Section 10.6 | Bridge |
| `RULE-016` | USB authentication 2nd group of 3 failures lockout | 1 minute | Section 10.6 | Bridge |
| `RULE-017` | USB authentication 3rd group of 3 failures lockout | 2 minutes | Section 10.6 | Bridge |
| `RULE-018` | USB authentication additional failed groups scaling | Every further group of three doubles previous duration | Section 10.6 | Bridge |
| `RULE-019` | Background sanitization CPU execution threshold | Below approximately 40–50% (pausing or reducing work above that range) | Section 14.5 | Lifecycle / Vault |
| `RULE-020` | Background sanitization target completion duration | Approximately 5 to 6 days (target rather than guaranteed deadline) | Section 14.5 | Lifecycle / Vault |

## DeeX Boot Specification Requirements (`BOOT-` Series)

| Boot Requirement ID | Description | Source Section | Owning Module | Derived Master Plan Mapping | Verification Test ID |
|---|---|---|---|---|---|
| `BOOT-001` | Hardware Root of Trust Chain Verification | MP 3.1, 3.2 | Boot | `REQ-004` / `RULE-SEC-001` | `TEST-BOOT-001`, `TEST-BOOT-008` |
| `BOOT-002` | Pre-Execution Kernel & RAM Disk Verification | MP 3.2 | Boot | `REQ-004` | `TEST-BOOT-002` |
| `BOOT-003` | Runtime Filesystem Verification (`dm-verity`) | MP 3.2, 17.3 | Boot | `REQ-004` | `TEST-BOOT-003` |
| `BOOT-004` | Mandatory Partition Coverage | MP 3.2 | Boot | `REQ-004` | `TEST-BOOT-004` |
| `BOOT-005` | AVB Boot State Reporting (`GREEN`/`ORANGE`/`RED`) | MP 3.2, 3.3 | Boot | `REQ-004` | `TEST-BOOT-005` |
| `BOOT-006` | Boot Failure Response Policy Enforcement (Option B) | MP 3.2, 3.3, 17.3 | Boot | `REQ-004` / `RULE-SEC-002` | `TEST-BOOT-006` |
| `BOOT-007` | Debug Privilege Absence in Production Builds | MP 2.4, 3.2 | Boot | `REQ-004` | `TEST-BOOT-007` |
| `BOOT-008` | Key Tier Isolation Enforcement | MP 3.2, 5.2 | Boot | `REQ-004` / `RULE-SEC-003` | `TEST-BOOT-008` |
| `BOOT-009` | DeeX Security Services Partition Protection | MP 3.2, 17.1 | Boot | `REQ-004` | `TEST-BOOT-009` |
| `BOOT-010` | Verified Boot Protection Boundary Verification | MP 3.4, 17.7 | Boot | `REQ-004` | `TEST-BOOT-010` |
| `BOOT-011` | Explicit Non-Goals Verification | MP 3.4, 17.7 | Boot | `REQ-004` | `TEST-BOOT-011` |

## DeeX Kernel Specification Requirements (`KERN-` Series)

| Requirement ID | Description | Source Section | Owning Module | Derived Master Plan Mapping | Verification Test ID |
|---|---|---|---|---|---|
| `KERN-001` | Platform Architecture and Hardware Driver Retention | MP 4.1, 4.2 | Kernel | `REQ-001`, `REQ-002` | `TEST-KERN-001` |
| `KERN-002` | Kernel Memory Protections & Process Isolation | MP 4.1, 4.2, 7.3 | Kernel | `REQ-004`, `REQ-006` | `TEST-KERN-002` |
| `KERN-003` | Mandatory Access Control (SELinux Enforcing) | MP 4.1, 4.2, 7.3 | Kernel | `REQ-004`, `REQ-006` | `TEST-KERN-003` |
| `KERN-004` | File-Based Encryption (FBE / fscrypt) Support | MP 4.1, 4.2, 5.2 | Kernel | `REQ-004`, `REQ-005` | `TEST-KERN-004` |
| `KERN-005` | Restricted Debugging & Privileged Interfaces | MP 4.1, 4.2, 17.2 | Kernel | `REQ-004`, `BOOT-007` | `TEST-KERN-005` |
| `KERN-006` | Kernel Logging Rules & Secret Non-Disclosure | MP 4.2, 17.2 | Kernel | `REQ-004` | `TEST-KERN-006` |
| `KERN-007` | Titan M2 Secure Hardware Interface Exposure | MP 4.2, 5.2, 6.3 | Kernel | `REQ-004`, `REQ-005` | `TEST-KERN-007` |
| `KERN-008` | System-Wide Resource Accounting & Threshold Policy | MP 4.3, 4.4, 7.5, 7.6 | Kernel | `RULE-001`, `RULE-002` | `TEST-KERN-008` |
| `KERN-009` | Background Sanitization Resource Throttling Interface | MP 4.4, 14.5 | Kernel | `RULE-019` | `TEST-KERN-009` |
| `KERN-010` | Inter-Module Service Interface Support | MP 4.1, 5.2, 7.3, 9.6, 10.2, 14.5 | Kernel | `REQ-005`, `REQ-006`, `REQ-009`, `REQ-010` | `TEST-KERN-010` |
| `KERN-011` | Build-Variant Kernel Configuration Separation | MP 2.4, 4.1, 4.2 | Kernel | `REQ-004`, `BOOT-007` | `TEST-KERN-011` |
| `KERN-012` | Explicit Non-Goals & Protection Boundaries | MP 4.3, 17.7 | Kernel | `REQ-013` | `TEST-KERN-012` |

## DeeX Kernel Configuration Requirements (`KCFG-` Series)

| Configuration ID | Description / Option Intent | Primary Source Citation | Owning Module | Verification Test ID |
|---|---|---|---|---|
| `KCFG-001` | `CONFIG_FS_ENCRYPTION=y` (fscrypt support) | `https://source.android.com/docs/security/features/encryption/file-based` | Kernel | `TEST-KERN-004` |
| `KCFG-002` | `CONFIG_SECURITY_SELINUX=y` (SELinux LSM) | `https://source.android.com/docs/security/features/selinux` | Kernel | `TEST-KERN-003` |
| `KCFG-003` | `CONFIG_CGROUPS=y` (Cgroups v2 unified hierarchy) | `https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html` | Kernel | `TEST-KERN-008` |
| `KCFG-004` | `CONFIG_BPF_SYSCALL=y` (eBPF subsystem) | `https://source.android.com/docs/core/architecture/kernel/bpf` | Kernel | `TEST-KERN-010` |
| `KCFG-005` | `CONFIG_CFI_CLANG=y` (Clang CFI protection) | `https://source.android.com/docs/security/test/cfi` | Kernel | `TEST-KERN-002` |
| `KCFG-006` | `CONFIG_RANDOMIZE_BASE=y` (KASLR) | `https://source.android.com/docs/security/bulletin/kernel-selections` | Kernel | `TEST-KERN-002` |
| `KCFG-007` | `CONFIG_SHADOW_CALL_STACK=y` (ShadowCallStack) | `https://source.android.com/docs/security/test/shadow-call-stack` | Kernel | `TEST-KERN-002` |
| `KCFG-008` | `kptr_restrict=2` (Restricted kernel address display) | `https://source.android.com/docs/security/bulletin/kernel-selections` | Kernel | `TEST-KERN-005` |
| `KCFG-009` | Disable `CONFIG_KGDB` in release builds | `https://source.android.com/docs/security/bulletin/kernel-selections` | Kernel | `TEST-KERN-005` |
| `KCFG-010` | `CONFIG_GOOGLE_NOS=m` (Titan M2 driver) | `https://android.googlesource.com/kernel/manifest` | Kernel | `TEST-KERN-007` |
