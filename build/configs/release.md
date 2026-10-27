# DeeX Build Configuration: Release

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 3.2, 4.2, 5.2, 16.2, 17.2

## 1. Purpose

The Release configuration is designed exclusively for generating production, installation-ready system images for end-user ARM64 smartphone devices (Google Pixel 8 `shiba`).

## 2. AOSP Build Variant & Target

- **AOSP Build Variant**: `user`
  - Citation: `https://source.android.com/docs/setup/build/building#choose-a-target` (Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Target `lunch` Specifier**: `UNKNOWN — decision required` (Pending project owner confirmation of AOSP release tag in `ADR-0003`; target template `aosp_shiba-user`).

## 3. Mandatory Security & Debugging Prohibitions (Non-Negotiable Master Plan Rules)

Per Master Plan Sections 2.4, 3.2, and 16.2:

1. **NO Debugging Privileges**:
   - Production images must NEVER contain development-only debugging privileges.
   - `ro.debuggable=0` REQUIRED.
   - `ro.secure=1` REQUIRED.
   - `adb root` daemon disabled and uncompiled in production binaries.
   - Serial console debugging (`printk` serial output) disabled.
2. **SELinux Mandatory Enforcing**:
   - SELinux MUST be locked in `Enforcing` mode (`setenforce 1` enforced at kernel build time).
   - Permissive domain transitions are strictly forbidden in production release builds.
3. **NO Mock or Stub Security Modules**:
   - No security-critical module (DeeX Vault, DeeX Identity, DeeX Isolation, Android Verified Boot HAL, Titan M2 StrongBox KeyMint HAL) may be silently replaced with a mock or stub implementation.
   - A release build that links or compiles a mock security component MUST immediately fail the build.

## 4. Cryptographic Key Identifiers

- **Key Tier**: Production Release Keys (`deex-release-key-01`).
- Release keys reside exclusively in secure, air-gapped hardware keystores (HSM / hardware tokens) per Key and Signing Policy (`docs/specifications/key-and-signing-policy.md`).
- Release keys are NEVER committed to source repositories, docker container images, CI runners, or build output logs.

## 5. Custom DeeX Module Requirement

- All DeeX system services (Vault, Identity, Isolation, Bridge, Connect, Policy) MUST be compiled from complete, audited production source code.

## 6. Logging and Secret Policy

- Diagnostic system logging restricted to critical production errors only.
- **Strict Prohibition (Master Plan 4.2, 17.2)**: System logs must NEVER contain passwords, credential hashes, master encryption keys, biometric templates, or account tokens.

## 7. Required Build Evidence for Release Success

Before a build in the Release configuration is recorded as successful and eligible for distribution:
1. Complete, clean build execution from pinned manifest and container environment without warnings treated as errors.
2. Complete Software Bill of Materials (SBOM) and dependency inventory generated.
3. Verification of system image SHA256 hashes and AVB signatures.
4. Passage of full release verification test suite (Master Plan 15 & 16.2).
5. Signed build record logged in `docs/build-records/`.
