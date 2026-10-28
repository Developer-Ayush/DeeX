Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.2, 5.2, 17.2

# DeeX Boot — Cryptographic Key Hierarchy & Signing Policy Design

## 1. Objectives and Scope

This document defines the architecture, operational roles, lifecycle rules, signing ceremony, and auditing policies for cryptographic keys used in **DeeX Boot** and OTA system update verification.

In accordance with Master Plan Sections 3.2, 5.2, and 17.2:
- Development keys, test keys, and production release keys MUST be strictly isolated from one another.
- Private key material MUST NEVER exist within Git repositories, Docker containers, CI output logs, or unencrypted local disks.
- No cryptographic key material (certificates, private keys, or keystores) is stored in this repository. Keys are referenced solely by logical identifiers.

---

## 2. Key Tier Roles & Technical Specifications

```text
+-----------------------------------------------------------------------------------+
|                            DEEX KEY HIERARCHY MAP                                 |
+--------------------------+------------------------------------+-------------------+
| Key Role Identifier      | Logical Purpose                    | Storage & Access  |
+--------------------------+------------------------------------+-------------------+
| deex-dev-key-*           | Local developer bringup & builds   | Git repo templates|
| deex-test-key-*          | Automated CI/CD & CTS test runs    | CI Secret Vault   |
| deex-release-key-avb     | Sign vbmeta & AVB partition hashes | Air-gapped OS     |
| deex-release-key-ota     | Sign OTA zip updates & packages    | Air-gapped OS     |
| deex-custom-root-key     | Enrolled on device Titan M2 NVRAM  | Air-gapped OS     |
+--------------------------+------------------------------------+-------------------+
```

### 2.1 Key Tier Details

| Key Identifier | Technical Role & Algorithm | Environment & Storage | Access Authorization | Compromise Response |
|---|---|---|---|---|
| **`deex-dev-key-*`** | RSA-2048 / SHA-256 (AVB & system) | Public test key checked into repo templates | All software developers | N/A (Publicly known test key; rejected by locked bootloader) |
| **`deex-test-key-*`** | RSA-4090 / SHA-256 (AVB & test OTAs) | CI/CD environment secrets vault | Automated CI runner pipeline | Revoke CI key secret, regenerate in CI vault, bump test rollback counter |
| **`deex-release-key-avb`** | RSA-4090 / SHA-256 (AVB `vbmeta`) | Air-gapped offline workstation with LUKS encrypted storage | Sole Project Owner | Immediate key revocation advisory, bump AVB rollback index, reissue release |
| **`deex-release-key-ota`** | RSA-4090 / SHA-256 (System OTA packages) | Air-gapped offline workstation with LUKS encrypted storage | Sole Project Owner | Revoke OTA update certificate, issue new OTA package signed by new key |
| **`deex-custom-root-key`** | Raw AVB public key digest (`pkmd.bin`) | Embedded in Pixel 8 Titan M2 NVRAM | Sole Project Owner | Flashing new custom AVB key requires bootloader unlock + full device wipe |

---

## 3. Owner Decisions & Operational Policy Incorporations

Per Project Owner directives:

1. **Key Storage Location**: Production release keys (`deex-release-key-*` and `deex-custom-root-key`) MUST reside on an **air-gapped offline workstation equipped with LUKS disk encryption** (Option B).
2. **Encrypted Offsite Backup**: An offline, AES-256 encrypted backup of release keys MUST be maintained in a physically separate, secure location (e.g. fireproof safe / offline physical vault).
3. **Loss of Key Risk**: Permanent loss or corruption of the release key material or backup passphrase constitutes a **CRITICAL RISK** that renders existing locked production hardware incapable of accepting official OTA updates without undergoing a full factory bootloader unlock and data wipe.
4. **Key Authorization**: Signing operations with production release keys are authorized **exclusively by the sole project owner**.
5. **Single-Person Dependency & Succession Plan**:
   - *Risk*: Single-person authorization introduces a critical operational bottleneck and single point of failure.
   - *Placeholder Succession Plan*: In a future multi-maintainer phase, a threshold M-of-N secret sharing scheme (e.g. Shamir's Secret Sharing) or multi-signature signing ceremony will be defined to govern key usage and emergency recovery.

---

## 4. Draft Signing Ceremony Framework

When signing an official DeeX production release image (`user` variant), the Project Owner executes a formal offline signing ceremony:

1. **Preparation Phase**:
   - Verify that the target build commit hash matches the pinned manifest in `build/manifests/aosp-pinned.xml`.
   - Confirm all automated CTS and regression tests passed in CI.
   - Boot air-gapped offline signing workstation from read-only media.
2. **Key Unlocking Phase**:
   - Mount encrypted release key volume using master passphrase.
   - Verify cryptographic integrity of private key files (`*.pem`, `*.pk8`).
3. **Image Signing Phase**:
   - Transfer unsigned release artifacts (`boot.img`, `system.img`, `vbmeta.img`, OTA zip) to offline host via clean, dedicated USB media.
   - Run AOSP `sign_target_files_apks` and `avbtool` signing scripts:
     ```bash
     # Concept illustration of signing command (executed offline)
     avbtool add_hash_footer --image boot.img --partition_name boot --key deex-release-key-avb.pem
     ```
   - Calculate SHA-256 hashes of un-signed vs. signed artifacts.
4. **Audit Logging & Cleanup**:
   - Append ceremony log record (commit hash, output hashes, timestamp, owner signature) to `build/templates/release-manifest.md`.
   - Unmount and lock encrypted key storage volume.
   - Power down air-gapped host.

---

## 5. Audit Logging & Anti-Leakage Rules

- **Zero Key Leakage Guarantee**: Private keys, passphrases, or raw key bytes MUST NEVER appear in repository files, build logs, terminal stdout, container layers, or CI output artifacts.
- **Audit Logging Requirements**: Every signed release manifest MUST record:
  1. Full Git commit SHA1 of the source tree.
  2. SHA256 checksums of signed partition images (`boot.img`, `system.img`, `vbmeta.img`).
  3. Public key fingerprint (SHA256 of public key metadata).
  4. Date, timestamp, and Project Owner cryptographic signature over the manifest record.

---

## 6. Policy Cross-Reference Update

This design expands and enforces the rules established in `docs/specifications/key-and-signing-policy.md`. See cross-reference in Section 7 of that file.
