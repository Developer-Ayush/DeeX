# DeeX Cryptographic Key and Signing Policy

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 3.2, 5.2, 16.2, 17.2

## 1. Overview and Core Objectives

This policy defines the governance, separation, storage, usage tracking, and lifecycle management for cryptographic signing keys within the DeeX operating system project.

This document is strictly a policy definition. In accordance with Master Plan Section 5.2, no private keys, certificates, keystores, or key-generating tool scripts are contained within this repository.

## 2. Key Tier Separation

To guarantee system image integrity and prevent development artifacts from being accepted as production firmware, DeeX strictly segregates signing keys into three isolated tiers (Master Plan 3.2):

```text
+-------------------------------------------------------------------+
|                        KEY TIER SEPARATION                        |
+--------------------------+----------------------------------------+
| Key Tier                 | Intended Scope & Environment           |
+--------------------------+----------------------------------------+
| 1. Development Keys      | Local developer bring-up & debugging   |
| 2. Testing Keys          | Automated CI/CD & CTS test harnesses   |
| 3. Production Release    | Official release builds for target HW  |
+--------------------------+----------------------------------------+
```

1. **Development Keys (`deex-dev-key-*`)**:
   - Used exclusively for local developer engineering builds (`eng` / `userdebug`).
   - Public test keys may be checked into build environment templates for local compilation.
   - Bootloaders on production devices MUST reject system partitions signed with development keys unless explicitly unlocked in developer mode.

2. **Testing Keys (`deex-test-key-*`)**:
   - Used for automated regression testing, CTS test harness runs, and nightly builds.
   - Stored in protected CI environment secret vaults.

3. **Production Release Keys (`deex-release-key-*`)**:
   - Used exclusively to sign production release images (`user`), OTA update packages, and Android Verified Boot (AVB 2.0) root metadata.
   - Release keys are strictly isolated from development environment trees.

## 3. Storage Rules for Production Release Keys

Per Master Plan Section 3.2 and 5.2:

- **Offline / Hardware Protection**: Production release keys must reside exclusively on air-gapped, hardware-protected security modules (HSM / Hardware Security Key / FIPS 140-3 validated cryptographic token).
- **Exact Storage Mechanism**: `UNKNOWN — decision required` (Pending project owner infrastructure setup).
- **Strict Repository Prohibition**: Private keys, keystore files (`*.keystore`, `*.jks`), PEM key files (`*.pem`, `*.key`), and API tokens must **NEVER** be committed to Git repositories, docker container layers, CI runner storage, or build output logs.
- `.gitignore` rules enforces exclusion patterns for `*.key`, `*.pem`, `*.keystore`, and `*.pk8`.

## 4. Key Usage Authorization and Logging

- **Authorized Personnel**: Only designated Release Engineers authorized by the project owner may initiate signing operations with production release keys.
- **Audit Logging**: Every release-signing operation must generate an immutable audit log entry containing:
  1. Release build version and source manifest commit hash (SHA1).
  2. SHA256 hashes of un-signed output artifacts.
  3. SHA256 hashes of signed release images.
  4. Timestamp and identity of authorizing release engineer.
  5. Cryptographic signature verification output.

## 5. Android Verified Boot (AVB 2.0) Key Handling

- **Device AVB Support**: AVB key handling depends on the target device's hardware root of trust and bootloader firmware capabilities, as evaluated in Chunk 2 (`device/target-device/candidates/google-pixel-8.md` and `device/target-device/hardware-facts-worksheet.md`).
- **Google Pixel 8 (`shiba`) Custom AVB Key**:
  - Pixel 8 bootloader firmware supports custom AVB root public key flashing via `fastboot flash avb_custom_key <public_key_pkmd.bin>`.
  - The custom AVB root public key digest is stored in Titan M2 secure element OTP memory upon bootloader relocking (`fastboot flashing lock`).
  - The corresponding AVB private signing key (`avb_release.pem`) is subject to the offline HSM storage rules defined in Section 3 above.

## 6. Draft Framework: Key Rotation and Compromise Response

In the event of suspected key compromise or routine lifecycle expiration:

1. **Compromise Declaration**: Immediately revoke the compromised key identifier in `docs/decisions/open-decisions.md` and security advisories.
2. **Key Revocation & Rollback Index Bump**:
   - Increment the AVB Rollback Index in `build/make/core/` and system manifest.
   - Prevent devices running signed firmware from downgrading or accepting images signed by the revoked key tier.
3. **Emergency Key Generation**: Generate a replacement key pair in offline HSM storage and update public key digests in the device target tree (`device/target-device/`).
4. **Post-Mortem**: Document root cause, affected build artifacts, and mitigation steps in `docs/build-records/`.

## 7. DeeX Boot Key Hierarchy Specification Cross-Reference

For detailed key hierarchy design, role specifications, air-gapped LUKS key storage rules, single-person authorization policies, and signing ceremony procedures, see:
`docs/specifications/boot-key-hierarchy.md`
