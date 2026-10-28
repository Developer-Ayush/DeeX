# Android Kernel Architecture and Pixel 8 Kernel Research Note

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Kernel
- **Master Plan Sections**: 1.3, 4, 4.1, 4.2, 4.3, 4.4, 5.2, 7.3, 7.5, 7.6, 9.6, 9.7, 14.5, 15.7, 17

---

## 1. Executive Summary & SoC Codename Correction

This research note documents the Android kernel architecture for Android 15 (`android-15.0.0_r1`) on the selected target hardware, **Google Pixel 8 (`shiba`)**.

### SoC Codename Resolution (`zuma` vs. `gs201`)
- **Correction Finding**: Reference to `gs201` for Google Pixel 8 was **INCORRECT**. `gs201` is the SoC codename for Google Tensor G2 (used in Google Pixel 7 series / `lynx`, `cheetah`, `panther`).
- **Correct Target Hardware Codename**: Google Pixel 8 (`shiba`) is powered by **Google Tensor G3**, whose official SoC codename across AOSP and Google Android Kernel repositories is **`zuma`**.
- **Primary Source**: Google Android Open Source Project Building Kernels Documentation (`https://source.android.com/docs/setup/build/building-kernels`, Access Date: 2025-05-16, Confidence: `VERIFIED`).

---

## 2. Android Kernel Model Structure (GKI Architecture)

Starting with Android 12 and continued in Android 15 (Kernel version 6.1 LTS), Android uses the **Generic Kernel Image (GKI)** architecture [Primary Source: AOSP Generic Kernel Image Architecture, `https://source.android.com/docs/core/architecture/kernel/generic-kernel-image`, Access Date: 2025-05-16, Confidence: `VERIFIED`].

### 2.1 Component Separation
1. **Android Common Kernel (ACK) / Core GKI**:
   - Contains generic Linux core kernel subsystems, process management, memory management, filesystems, SELinux LSM, networking, cgroups v2, and eBPF.
   - Built directly from `kernel/common` at Linux 6.1 LTS branch.
   - Delivered as a unified `boot.img` containing the core `Image.lz4` binary without vendor driver code.
2. **Vendor Kernel Modules (`vendor_dlkm` / `system_dlkm`)**:
   - Vendor-specific drivers (Google Tensor G3 GPU, display, audio, camera, Wi-Fi, Bluetooth, Titan M2 drivers, modem IPC) are decoupled from core GKI.
   - Compiled out-of-tree as Dynamically Loaded Kernel Modules (`.ko`).
   - Delivered via `vendor_boot.img`, `vendor_dlkm.img`, and `system_dlkm.img` partitions.
3. **Vendor Board Config & Bootloader Hooks**:
   - Module loading strictly ordered via `modules.load` configuration files packaged into early ramdisk (`vendor_boot`) and `vendor_dlkm`.

---

## 3. Google Pixel 8 Kernel Source Publication & Licensing

### 3.1 Repository Locations & Branches
Google publishes the complete kernel source code for Google Pixel 8 (`shiba`) under the official Android kernel repository manifest [Primary Source: AOSP Kernel Source Repositories, `https://android.googlesource.com/kernel/manifest`, Access Date: 2025-05-16, Confidence: `VERIFIED`]:
- **Kernel Manifest Branch**: `android-gs-zuma-6.1`
- **Core Kernel Source**: `kernel/common` (Linux 6.1 LTS baseline)
- **Tensor G3 SoC Driver Source**: `kernel/google-modules/soc/zuma`
- **GPU Driver Source**: `kernel/google-modules/gpu/mali`
- **Wi-Fi / Bluetooth Drivers**: `kernel/google-modules/wlan/bcm4389`, `kernel/google-modules/bluetooth`
- **Titan M2 Secure Element Interface**: `kernel/google-modules/edgetpu` / `nos` (Citadel/Titan driver interface)

### 3.2 License Terms
- **Core Kernel (`kernel/common`)**: GNU General Public License version 2 (GPLv2).
- **Vendor Kernel Modules (`google-modules`)**: Dual GPLv2 / BSD or open-source Apache 2.0 where applicable.
- **GPL Implications for DeeX**:
  - Any modifications to GPLv2 kernel code require source availability upon distribution.
  - Per project owner direction, DeeX avoids out-of-tree/patched kernel code, relying strictly on standard kernel interfaces, eBPF, and configuration settings.

---

## 4. Android Verified Boot (AVB) Coverage over Kernel

AVB 2.0 cryptographically verifies all kernel binaries and kernel module partitions before execution [Primary Source: AOSP Boot Overview & AVB, `https://source.android.com/docs/security/features/verifiedboot`, Access Date: 2025-05-16, Confidence: `VERIFIED`; reference `docs/specifications/boot-specification.md`]:
- **`boot.img`**: Contains core GKI kernel image (`Image.lz4`). Signed with AVB boot signature verified by bootloader (`abl`) during Stage 2 boot.
- **`vendor_boot.img`**: Contains vendor ramdisk and stage-1 vendor modules (`modules.load.recovery`, early storage/display drivers). Verified by AVB bootloader stage.
- **`vendor_dlkm.img`**: Contains main runtime vendor kernel modules (`.ko`). Verified by `dm-verity` tree embedded in header, checked at system mount.
- **`system_dlkm.img`**: Contains GKI-signed system kernel modules. Verified via `dm-verity`.

---

## 5. Mandatory Kernel Features for Android 15

Per Android 15 Compatibility Definition Document (CDD) [Primary Source: Android 15 CDD, `https://source.android.com/docs/compatibility/15/android-15-cdd`, Access Date: 2025-05-16, Confidence: `VERIFIED`], the kernel must support:

1. **File-Based Encryption (FBE / fscrypt)**:
   - Kernel native `fscrypt` filesystem-level encryption with AES-256-XTS for payload and AES-256-CTS for filenames, or inline encryption hardware acceleration.
2. **Mandatory Access Control (SELinux)**:
   - SELinux LSM enabled in `enforcing` mode; support for multi-category security (MCS) and Android type enforcement policy.
3. **Cgroups v2 & Process Resource Control**:
   - Single-hierarchy cgroups v2 for CPU, memory, freezer, and io controllers. Required for Android process freezing and resource limits.
4. **eBPF (Extended Berkeley Packet Filter)**:
   - Kernel eBPF loader and JIT compiler for network accounting (`bpfloader`), traffic shaping, and socket filtering.
5. **Memory Protections**:
   - **KASLR**: Kernel Address Space Layout Randomization.
   - **CFI**: Clang Control Flow Integrity (Forward-edge protection).
   - **SCS**: ShadowCallStack (Backward-edge stack protection for ARM64).
   - **PAN / PXN**: Privileged Access Never / Privileged Execute Never (ARMv8.1+ hardware memory access isolation).

---

## 6. Kernel Debugging & Tracing Facilities Control

In Android production (`user`) builds, privileged debugging and tracing interfaces are disabled or heavily restricted [Primary Source: AOSP Kernel Security Features, `https://source.android.com/docs/security/bulletin/kernel-selections`, Access Date: 2025-05-16, Confidence: `VERIFIED`]:
- **`kgdb` / Kernel Debugger**: Disabled in release kernel configs.
- **`ftrace` / `tracefs`**: Restricted to `root` or `logd`/`shell` in `userdebug` variants; mounted `nodev,noexec,nosuid` and restricted via SELinux in `user` builds.
- **`ptrace`**: Restricted via `sysctl kernel.yama.ptrace_scope` and SELinux policies preventing unprivileged processes from attaching to system tasks.
- **`sysfs` / `procfs` debug nodes**: `/proc/kallsyms` restricted via `kptr_restrict=2` (zeroing kernel addresses for non-root users); `/proc/kcore` disabled.

---

## 7. Thermal and Power Management Framework

### 7.1 Framework Architecture
Google Tensor G3 on Pixel 8 uses an integrated hardware and software thermal management framework [Primary Source: AOSP Thermal Mitigation, `https://source.android.com/docs/core/power/thermal-mitigation`, Access Date: 2025-05-16, Confidence: `VERIFIED`]:
- **Hardware Thermal Diodes & Vendor Firmware**: Embedded hardware thermal sensors on SoC compute clusters, GPU, modem, and Titan M2 monitor physical junction temperatures.
- **Thermal Governors (`cpufreq` / `thermal_zone`)**: Linux kernel thermal subsystem reads sensor zone values and triggers automatic CPU/GPU DVFS throttling without user-space intervention.
- **Vendor Thermal HAL (`android.hardware.thermal-service.pixel`)**: User-space daemon receiving sensor updates, providing thermal headroom estimation, and triggering system throttling policies.

### 7.2 Safety Boundary Assertion
Per Master Plan Section 4.3 and project owner confirmation, **hardware thermal protection remains entirely managed by hardware, vendor firmware, and kernel thermal governors**. DeeX resource accounting functions operate purely as high-level resource management policies and **must never override or disable hardware thermal protection limits**.

---

## 8. Gaps Requiring Physical Testing

Because physical hardware test results are not yet available (`NOT YET EVIDENCED`), the following items are marked as requiring physical verification once target hardware is available:
1. Exact runtime kernel log outputs during boot under release configuration.
2. Verified loading sequence of `vendor_dlkm` modules on Tensor G3 `zuma` under custom AVB keys.
3. Physical thermal throttle response curves under sustained multi-account CPU/RAM load.
4. Exact driver node permissions and SELinux label assignments for Titan M2 (`/dev/citadel0` or `/dev/nos0`).

---

## 9. Primary Claims Table

| Claim ID | Claim Summary | Primary Source URL / Reference | Access Date | Confidence | Needs Physical Verification |
|---|---|---|---|---|---|
| `CLM-KERN-001` | Pixel 8 SoC codename is Tensor G3 (`zuma`), not `gs201`. | `https://source.android.com/docs/setup/build/building-kernels` | 2025-05-16 | `VERIFIED` | No |
| `CLM-KERN-002` | Android 15 uses Generic Kernel Image (GKI) architecture on Linux 6.1 LTS baseline. | `https://source.android.com/docs/core/architecture/kernel/generic-kernel-image` | 2025-05-16 | `VERIFIED` | No |
| `CLM-KERN-003` | Pixel 8 kernel source branch is `android-gs-zuma-6.1`. | `https://android.googlesource.com/kernel/manifest` | 2025-05-16 | `VERIFIED` | No |
| `CLM-KERN-004` | Kernel core is licensed under GPLv2; vendor modules under dual GPLv2/BSD or Apache 2.0. | `https://android.googlesource.com/kernel/common` | 2025-05-16 | `VERIFIED` | No |
| `CLM-KERN-005` | AVB 2.0 and `dm-verity` verify `boot.img`, `vendor_boot.img`, and `vendor_dlkm.img`. | `https://source.android.com/docs/security/features/verifiedboot` | 2025-05-16 | `VERIFIED` | Yes (physical flash check) |
| `CLM-KERN-006` | Android 15 CDD mandates FBE (fscrypt), SELinux enforcing, cgroups v2, and eBPF. | `https://source.android.com/docs/compatibility/15/android-15-cdd` | 2025-05-16 | `VERIFIED` | No |
| `CLM-KERN-007` | ARM64 hardware memory protections include KASLR, CFI, ShadowCallStack, and PAN/PXN. | `https://source.android.com/docs/security/bulletin/kernel-selections` | 2025-05-16 | `VERIFIED` | No |
| `CLM-KERN-008` | `kptr_restrict=2` zeros `/proc/kallsyms` kernel addresses for non-root users. | `https://source.android.com/docs/security/bulletin/kernel-selections` | 2025-05-16 | `VERIFIED` | Yes (runtime verification) |
| `CLM-KERN-009` | Hardware and kernel thermal zone governors automatically throttle CPU/GPU under thermal load. | `https://source.android.com/docs/core/power/thermal-mitigation` | 2025-05-16 | `VERIFIED` | Yes (physical thermal test) |
