# DeeX Kernel Threat Model Entries

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 4.1, 4.2, 4.3, 7.3, 17.2, 17.7

---

## 1. Overview

This document records threat model entries specific to the DeeX Kernel on Google Pixel 8 (`shiba` / Tensor G3 `zuma`). It details threat actors, targeted assets, attack vectors, design mitigations (mapped to `KERN-` and `KCFG-` requirements), residual risks, and physical verification dependencies.

---

## 2. Kernel Threat Entries (`TM-KERN-` Series)

### TM-KERN-001: Untrusted Application Kernel Memory Corruption
- **Actor**: Malicious or compromised user-space application.
- **Asset**: Kernel memory space, process memory boundaries, system privileges.
- **Attack Vector**: Exploiting zero-day or unpatched kernel memory corruption vulnerabilities (e.g. use-after-free, out-of-bounds write) via system calls to gain arbitrary kernel read/write execution.
- **Design Mitigation**: `KERN-002`, `KCFG-005` (Clang CFI), `KCFG-006` (KASLR), `KCFG-007` (ShadowCallStack), PAN/PXN ARM64 hardware memory isolation.
- **Residual Risk**: A successful kernel-level arbitrary code execution exploit bypasses user-space and kernel isolation mechanisms (Master Plan Section 17.7 explicit boundary).
- **Physical Verification Dependency**: None (architectural boundary).

### TM-KERN-002: Cross-Account Process Probing & Memory Extraction
- **Actor**: Compromised application in an active or background ordinary account session.
- **Asset**: Private filesystem data, process memory, and authentication tokens of another account.
- **Attack Vector**: Attempting `ptrace` attach, `/proc/<pid>/mem` reading, or Unix IPC socket probing across user account boundaries.
- **Design Mitigation**: `KERN-002`, `KERN-003`, `KCFG-002` (SELinux enforcing with MCS category labels), `KCFG-008` (`kptr_restrict=2`, Yama ptrace scope restriction).
- **Residual Risk**: Zero-day local privilege escalation to `root` bypassing SELinux policy.
- **Physical Verification Dependency**: Yes (requires physical runtime cross-account process probing test).

### TM-KERN-003: Physical Attacker Exploiting Debug & Tracing Interfaces
- **Actor**: Physical attacker with physical access to the device or USB host.
- **Asset**: Device storage keys, kernel memory, system state.
- **Attack Vector**: Attaching hardware debuggers (`kgdb`), extracting kernel symbols from `/proc/kallsyms`, or abusing kernel tracing (`ftrace`/`tracefs`) over USB/UART.
- **Design Mitigation**: `KERN-005`, `KCFG-008`, `KCFG-009` (Disabling `CONFIG_KGDB` and restricting debug tracing in release builds; `BOOT-007`).
- **Residual Risk**: Physical side-channel analysis or hardware-level fault injection on SoC pins.
- **Physical Verification Dependency**: Yes (requires physical USB and serial debug port verification).

### TM-KERN-004: Resource Exhaustion / Denial of Service Attack from Background Accounts
- **Actor**: Malicious application running in a background ordinary account session.
- **Asset**: System CPU, RAM, disk IO bandwidth, system availability.
- **Attack Vector**: Spawning infinite threads, allocating memory buffers, or executing high-frequency disk writes to starve foreground user tasks and essential system services.
- **Design Mitigation**: `KERN-008`, `KERN-009`, `KCFG-003` (cgroups v2 CPU weights, memory limits, and IO bandwidth throttling; `system.slice` protection via `memory.min`).
- **Residual Risk**: Excessive kernel lock contention in shared kernel subsystems (e.g. VFS) under extreme stress.
- **Physical Verification Dependency**: Yes (requires physical load stress testing).

### TM-KERN-005: Compromised or Vulnerable Closed Vendor Kernel Driver
- **Actor**: Remote attacker sending crafted radio packets (Wi-Fi, Bluetooth, Cellular Modem, NFC).
- **Asset**: Kernel memory space, vendor driver state.
- **Attack Vector**: Exploiting vulnerabilities in closed-source vendor kernel drivers (`vendor_dlkm`) via malicious over-the-air radio frames.
- **Design Mitigation**: `KERN-001`, `KERN-003`, SELinux restriction of vendor driver character device nodes, eBPF packet filtering.
- **Residual Risk**: Vendor driver code executes in kernel space; compromise of vendor driver yields kernel privileges.
- **Physical Verification Dependency**: Yes (requires physical radio packet testing).

### TM-KERN-006: Secret & Credential Leakage in Kernel Logs
- **Actor**: Unprivileged local app or diagnostic logging reader.
- **Asset**: Encryption keys, PINs, biometric templates, account secrets.
- **Attack Vector**: Reading `dmesg`, `/proc/kmsg`, `pstore`, or panic crash dumps following a system crash to extract residual secrets written by kernel drivers.
- **Design Mitigation**: `KERN-006` (Strict rule prohibiting secrets in kernel log buffers), `dmesg_restrict=1` kernel sysctl setting.
- **Residual Risk**: Debug logs enabled in non-release (`userdebug`) builds during developer testing.
- **Physical Verification Dependency**: Yes (requires physical log buffer inspection during crash dumps).

### TM-KERN-007: Malicious USB Host Device Connection
- **Actor**: Malicious USB host device (e.g. rogue charging station or automated USB exploit tool).
- **Asset**: Kernel USB subsystem, system security boundaries.
- **Attack Vector**: Exploiting USB descriptor parsing vulnerabilities in Linux kernel USB core or forcing unauthorized MTP/ADB protocol binding.
- **Design Mitigation**: `KERN-010`, DeeX Bridge USB ConfigFS gadget state machine, disabling auto-enumeration of data gadgets prior to USB user authentication.
- **Residual Risk**: Hardware-level USB PHY controller vulnerabilities.
- **Physical Verification Dependency**: Yes (requires physical USB host connection testing).
