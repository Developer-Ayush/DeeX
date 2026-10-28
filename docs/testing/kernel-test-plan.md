# DeeX Kernel Test Plan

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 1.3, 4, 4.1, 4.2, 4.3, 4.4, 5.2, 7.3, 7.5, 7.6, 9.6, 9.7, 14.5, 15.7, 17

---

## 1. Scope & Execution Rules

This test plan defines verification procedures for all DeeX Kernel requirements (`KERN-001` through `KERN-012`) on Google Pixel 8 (`shiba` on Android 15 / Google Tensor G3 `zuma`).

### Physical Hardware Execution Precondition
Because baseline hardware testing is `NOT YET EVIDENCED` (not yet built, flashed, or executed on physical hardware), **all test results in this plan are recorded as `NOT RUN`**. Device command execution details are outlined based on official AOSP and Linux kernel documentation [Primary Source: AOSP Testing Documentation, `https://source.android.com/docs/core/tests`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

---

## 2. Kernel Test Cases (`TEST-KERN-` Series)

### TEST-KERN-001: Platform Architecture & Hardware Driver Retention
- **Requirement Mapped**: `KERN-001`
- **Objective**: Verify that all hardware subsystems (display, touchscreen, audio, camera, cellular modem, UFS storage, Wi-Fi, Bluetooth, GPS, NFC, fingerprint sensor, ambient sensors, USB, power/thermal, Titan M2) initialize successfully without driver probe failures.
- **Preconditions**: Target Pixel 8 flashed with DeeX build image (`userdebug` or `release`); connected via USB debugging interface.
- **Procedure Outline**:
  1. Boot target device into Android OS.
  2. Inspect kernel dmesg log for driver initialization failures or missing firmware errors.
  3. Query sysctl and hardware HAL service statuses for all driver nodes.
- **Expected Result**: All target drivers report successful probe and registration; zero kernel panic or missing vendor firmware errors.
- **Evidence to Capture**: `dmesg` log, `getprop` HAL status output, `/proc/interrupts` dump.
- **Status**: `NOT RUN`

### TEST-KERN-002: Kernel Memory Protections & Process Isolation Verification
- **Requirement Mapped**: `KERN-002`
- **Objective**: Verify active status of KASLR, Clang CFI, ShadowCallStack, PAN/PXN, and Yama ptrace restrictions.
- **Preconditions**: DeeX kernel image booted on target device.
- **Procedure Outline**:
  1. Query `/proc/sys/kernel/yama/ptrace_scope`.
  2. Attempt unprivileged `ptrace` attach across process boundaries.
  3. Compare kernel base memory address across three consecutive reboots to confirm KASLR.
- **Expected Result**: `ptrace_scope` equals `1` or higher; cross-process `ptrace` attach rejected with `EPERM`; kernel base address differs on every boot.
- **Evidence to Capture**: Sysctl outputs, `ptrace` test binary execution log, kernel base memory log across reboots.
- **Status**: `NOT RUN`

### TEST-KERN-003: SELinux Enforcing Mode & Permissive Domain Absence
- **Requirement Mapped**: `KERN-003`
- **Objective**: Verify SELinux is in `enforcing` mode in release builds with zero permissive domains.
- **Preconditions**: DeeX `release` build variant flashed on target device.
- **Procedure Outline**:
  1. Execute `getenforce` via shell.
  2. Inspect loaded SELinux policy for permissive domain declarations.
- **Expected Result**: `getenforce` returns `Enforcing`; zero permissive SELinux domains found in policy.
- **Evidence to Capture**: Output of `getenforce`, `semanage` or policy dump log.
- **Status**: `NOT RUN`

### TEST-KERN-004: File-Based Encryption (fscrypt) Acceleration Check
- **Requirement Mapped**: `KERN-004`
- **Objective**: Verify kernel `fscrypt` support and hardware inline encryption on UFS storage partitions.
- **Preconditions**: Device booted with encrypted `/data` user partition.
- **Procedure Outline**:
  1. Execute `tune2fs -l /dev/block/by-name/userdata` or inspect `/sys/fs/ext4/` / `/sys/fs/f2fs/` sysfs entries.
  2. Verify active encryption flags and inline encryption crypto driver binding.
- **Expected Result**: Filesystem reports active `encrypt` feature with AES-256-XTS payload encryption acceleration.
- **Evidence to Capture**: Filesystem feature listing, `/proc/crypto` driver binding log.
- **Status**: `NOT RUN`

### TEST-KERN-005: Debug Interface Disablement in Release Variant
- **Requirement Mapped**: `KERN-005`
- **Objective**: Verify kernel debug interfaces (`kgdb`, `/proc/kcore`, `/proc/kallsyms` raw addresses) are absent or restricted in release builds.
- **Preconditions**: DeeX `release` build variant booted.
- **Procedure Outline**:
  1. Verify `/proc/kcore` file does not exist or is unreadable.
  2. Read `/proc/kallsyms` as non-root user and check address field.
  3. Verify `/sys/kernel/debug` permissions and mount options.
- **Expected Result**: `/proc/kallsyms` addresses displayed as all zeros (`0000000000000000`); `/proc/kcore` absent; debugfs unmounted or restricted.
- **Evidence to Capture**: Head of `/proc/kallsyms`, `ls -l /proc/kcore`, mount table output.
- **Status**: `NOT RUN`

### TEST-KERN-006: Kernel Secret Non-Disclosure in Logs & Panic Dumps
- **Requirement Mapped**: `KERN-006`
- **Objective**: Confirm kernel log buffers (`dmesg`, `pstore`, crash dumps) do not contain raw keys, credentials, or private account data.
- **Preconditions**: Device undergoing synthetic key derivation and disk encryption operations.
- **Procedure Outline**:
  1. Trigger key derivation and storage mounting tasks.
  2. Search dmesg buffer and `/sys/fs/pstore` for hexadecimal secret patterns or key strings.
- **Expected Result**: Zero occurrences of raw cryptographic keys or user credentials in kernel log outputs.
- **Evidence to Capture**: Filtered `dmesg` log search results, `pstore` directory inspection log.
- **Status**: `NOT RUN`

### TEST-KERN-007: Titan M2 Secure Hardware Device Node Exposure
- **Requirement Mapped**: `KERN-007`
- **Objective**: Verify character device node `/dev/citadel0` or `/dev/nos0` presence and permissions.
- **Preconditions**: Device booted into Android system.
- **Procedure Outline**:
  1. Inspect permissions and ownership on Titan M2 device node via `ls -l /dev/citadel0` or `/dev/nos0`.
  2. Verify KeyMint HAL process can open and communicate with device node.
- **Expected Result**: Node permissions are `0660`, owner `system`, group `keystore`; KeyMint HAL connects successfully.
- **Evidence to Capture**: `ls -l /dev/citadel0` or `/dev/nos0`, KeyMint daemon log output.
- **Status**: `NOT RUN`

### TEST-KERN-008: System-Wide Resource Accounting & Threshold Policy
- **Requirement Mapped**: `KERN-008`
- **Objective**: Verify cgroups v2 resource accounting and system CPU/RAM threshold enforcement.
- **Preconditions**: Device running under synthetic CPU and memory load.
- **Procedure Outline**:
  1. Inspect `/sys/fs/cgroup/cgroup.controllers`.
  2. Generate heavy background CPU load in ordinary account cgroup slice.
  3. Measure CPU allocation to `system.slice` versus `account.slice`.
- **Expected Result**: Cgroup v2 controllers active; `system.slice` maintains reserved CPU bandwidth; background account slice throttled when total system CPU exceeds 85%.
- **Evidence to Capture**: Cgroup controller dump, CPU utilization monitor log under load.
- **Status**: `NOT RUN`

### TEST-KERN-009: Background Sanitization Resource Throttling
- **Requirement Mapped**: `KERN-009`
- **Objective**: Verify background storage sanitization process pauses or throttles when system CPU utilization exceeds 50%.
- **Preconditions**: Storage sanitization task active in `/sys/fs/cgroup/sanitization.slice`.
- **Procedure Outline**:
  1. Start background sanitization task.
  2. Introduce foreground CPU load increasing total utilization above 50%.
  3. Observe sanitization process state and CPU bandwidth allocation.
- **Expected Result**: Sanitization task automatically throttled or paused when system CPU exceeds 50%.
- **Evidence to Capture**: Sanitization process state log, CPU utilization timeline.
- **Status**: `NOT RUN`

### TEST-KERN-010: Inter-Module Service Kernel Interfaces
- **Requirement Mapped**: `KERN-010`
- **Objective**: Verify kernel availability of RFKILL, USB ConfigFS gadget, eBPF socket filters, and `fscrypt` ioctls.
- **Preconditions**: Device booted with test suite harness.
- **Procedure Outline**:
  1. Test RFKILL sysfs radio state toggling for Wi-Fi and Bluetooth.
  2. Verify USB ConfigFS gadget composition creation.
  3. Execute eBPF socket filter load test.
- **Expected Result**: All interfaces respond according to driver specification without kernel exceptions.
- **Evidence to Capture**: RFKILL state logs, USB gadget ConfigFS directory dump, eBPF loader log.
- **Status**: `NOT RUN`

### TEST-KERN-011: Build-Variant Kernel Configuration Differences
- **Requirement Mapped**: `KERN-011`
- **Objective**: Verify exact configuration differences across `development`, `testing`, and `release` build variants.
- **Preconditions**: Build artifacts compiled for all three variants.
- **Procedure Outline**:
  1. Compare generated `.config` files across `development`, `testing`, and `release` builds.
  2. Verify debug symbol and tracing flag states in each variant config.
- **Expected Result**: `development` contains debug hooks; `testing` contains automated test hooks; `release` has all debug and tracing options disabled.
- **Evidence to Capture**: `.config` diff report across variants.
- **Status**: `NOT RUN`

### TEST-KERN-012: Protection Boundary & Non-Goal Verification
- **Requirement Mapped**: `KERN-012`
- **Objective**: Confirm kernel documentation and system behavior explicitly reflect non-goals (no thermal override, no protection against full kernel compromise).
- **Preconditions**: Thermal stress test environment prepared.
- **Procedure Outline**:
  1. Apply thermal load to device while monitoring junction temperature sensors and CPU DVFS frequency.
  2. Confirm hardware thermal zone governors throttle CPU frequency independently of DeeX resource accounting.
- **Expected Result**: Hardware thermal throttling engages automatically at vendor trip points; DeeX software policies do not interfere with hardware thermal protection.
- **Evidence to Capture**: Thermal zone sensor logs and CPU frequency curves under thermal stress.
- **Status**: `NOT RUN`

---

## 3. Requirement Traceability Matrix

| Test Plan ID | Target Requirement ID | Objective Summary | Expected Outcome | Status |
|---|---|---|---|---|
| `TEST-KERN-001` | `KERN-001` | Hardware driver initialization | All drivers probe successfully | `NOT RUN` |
| `TEST-KERN-002` | `KERN-002` | Memory protections (KASLR, CFI, SCS) | Protections active; ptrace restricted | `NOT RUN` |
| `TEST-KERN-003` | `KERN-003` | SELinux enforcing mode | SELinux enforcing; zero permissive domains | `NOT RUN` |
| `TEST-KERN-004` | `KERN-004` | File-Based Encryption (fscrypt) | FBE enabled with hardware acceleration | `NOT RUN` |
| `TEST-KERN-005` | `KERN-005` | Debug interface restriction | Debug facilities disabled in release | `NOT RUN` |
| `TEST-KERN-006` | `KERN-006` | Kernel secret non-disclosure | Zero secrets in dmesg/crash logs | `NOT RUN` |
| `TEST-KERN-007` | `KERN-007` | Titan M2 device node exposure | Device node present with 0660 permissions | `NOT RUN` |
| `TEST-KERN-008` | `KERN-008` | Resource accounting & thresholds | System slice protected; thresholds enforced | `NOT RUN` |
| `TEST-KERN-009` | `KERN-009` | Background sanitization throttling | Sanitization yields when CPU > 50% | `NOT RUN` |
| `TEST-KERN-010` | `KERN-010` | Inter-module service interfaces | RFKILL, USB ConfigFS, eBPF operational | `NOT RUN` |
| `TEST-KERN-011` | `KERN-011` | Build variant config separation | Build variants strictly differentiated | `NOT RUN` |
| `TEST-KERN-012` | `KERN-012` | Protection boundary & non-goals | Thermal hardware protection untouched | `NOT RUN` |
