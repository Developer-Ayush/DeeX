# DeeX Build Configuration: Development

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 4.2, 17.2

## 1. Purpose

The Development configuration is designed exclusively for active system software engineering, driver bring-up, HAL integration, and interactive debugging of DeeX modules on target hardware or emulation environments.

## 2. AOSP Build Variant & Target

- **AOSP Build Variant**: `eng` or `userdebug`
  - Citation: `https://source.android.com/docs/setup/build/building#choose-a-target` (Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Target `lunch` Specifier**: `UNKNOWN — decision required` (Pending project owner confirmation of AOSP release tag in `ADR-0003`; target template `aosp_shiba-userdebug`).

## 3. Allowed Debugging Facilities

- ADB root daemon access enabled (`adb root`, `adb shell` running as UID 0).
- System properties `ro.debuggable=1` and `ro.secure=0` permitted.
- SELinux Permissive mode permitted (`setenforce 0`) during driver bring-up phase only.
- Kernel tracing tools (`ftrace`, `simpleperf`, `gdbserver`, `systrace`) enabled.
- Serial console logging and Kernel printk enabled.

## 4. Cryptographic Key Identifiers

- **Key Tier**: Development Keys (`deex-dev-key-01`).
- Development keys are public test keys checked into AOSP test trees or generated locally for dev builds.
- **Restriction**: Development keys must NEVER be used to sign production system partitions or bootloaders.

## 5. Custom DeeX Module Stubbing Policy

- Non-security modules may use mock/stub implementations during early development bring-up.
- **Restriction**: Security-critical modules (DeeX Vault, DeeX Isolation, AVB chain) must explicitly log when running with stubbed dependencies.

## 6. Logging and Secret Policy

- Verbosely logged system traces permitted for diagnostic purposes.
- **Strict Prohibition (Master Plan 4.2, 17.2)**: User passwords, salted verifier hashes, plaintext encryption keys, biometric templates, and credential verifiers must NEVER be output to `logcat`, serial console, or build logs under any circumstances.

## 7. Required Build Evidence for Success

Before a build in the Development configuration is recorded as successful:
1. Ninja build completes with zero errors (`build.log`).
2. Boot image (`boot.img`), vendor boot (`vendor_boot.img`), and system image (`system.img`) are generated in `out/target/product/shiba/`.
3. Image SHA256 hashes recorded in build record template.
