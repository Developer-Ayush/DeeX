# DeeX Base — Partition Layout Record for Google Pixel 8 (shiba)

- **Status**: Draft
- **Date**: 2025-05-16
- **Owning Module**: DeeX Base
- **Target Device**: Google Pixel 8 (`shiba` / Google Tensor G3)
- **AOSP Baseline**: Android 15 (`android-15.0.0_r1`)
- **Master Plan Sections**: 2.5, 3.1, 4.1, 5.2, 16.3

---

## 1. Overview

The Google Pixel 8 (`shiba`) partition structure utilizes Android Virtual A/B (Seamless Updates) and Dynamic Partitions (Logical Partitions inside a physical `super` partition container). Verified Boot (AVB 2.0) protects system, boot, and vendor partitions using public key root structures anchored in the Titan M2 secure element.

The table below records the known hardware and logical partition layout documented by Google AOSP primary source documentation. Actual device block partition sizes and mount options must be confirmed by the project owner from the physical device during first hardware intake testing.

---

## 2. Partition Layout Table

| Partition Name | Purpose | Slotted (A/B) | AVB Protected | Dynamic / Logical | Confidence | Primary Source Citation |
|---|---|---|---|---|---|---|
| `boot` | Linux Kernel image and generic ramdisk | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — Boot Image Header, `https://source.android.com/docs/core/architecture/bootloader/boot-image-header`, Access Date: 2025-05-16] |
| `init_boot` | Generic ramdisk for first-stage init (Android 13+) | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — Generic Boot Image (GKI), `https://source.android.com/docs/core/architecture/bootloader/gki-boot-interface`, Access Date: 2025-05-16] |
| `vendor_boot` | Vendor-specific ramdisk, modules, device tree blobs (DTB) | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — Vendor Boot Header, `https://source.android.com/docs/core/architecture/bootloader/vendor-boot-header`, Access Date: 2025-05-16] |
| `dtbo` | Device Tree Overlay partition | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — DTBO Partitions, `https://source.android.com/docs/core/architecture/dto/partitions`, Access Date: 2025-05-16] |
| `pvmfw` | Protected Virtual Machine Firmware (pKVM hypervisor) | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — Android Virtualization Framework, `https://source.android.com/docs/core/virtualization`, Access Date: 2025-05-16] |
| `vbmeta` | AVB top-level metadata and signature structure | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — AVB 2.0 Overview, `https://android.googlesource.com/platform/external/avb/+/refs/heads/main/README.md`, Access Date: 2025-05-16] |
| `vbmeta_system` | AVB chained metadata for system partitions | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — AVB Chained Partitions, `https://android.googlesource.com/platform/external/avb/+/refs/heads/main/README.md`, Access Date: 2025-05-16] |
| `vbmeta_vendor` | AVB chained metadata for vendor partitions | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — AVB Chained Partitions, `https://android.googlesource.com/platform/external/avb/+/refs/heads/main/README.md`, Access Date: 2025-05-16] |
| `super` | Physical superpartition container hosting dynamic logical partitions | Yes | Yes (dm-verity) | Physical Container | `VERIFIED` | [Primary Source: Google Android Source — Dynamic Partitions, `https://source.android.com/docs/core/architecture/partitions/dynamic-partitions`, Access Date: 2025-05-16] |
| `system` | Core Android OS system framework and binaries | Yes | Yes (dm-verity) | Yes (Logical) | `VERIFIED` | [Primary Source: Google Android Source — Dynamic Partitions, `https://source.android.com/docs/core/architecture/partitions/dynamic-partitions`, Access Date: 2025-05-16] |
| `system_ext` | Extended system framework services | Yes | Yes (dm-verity) | Yes (Logical) | `VERIFIED` | [Primary Source: Google Android Source — System EXT Partition, `https://source.android.com/docs/core/architecture/partitions/system-ext-partition`, Access Date: 2025-05-16] |
| `vendor` | Vendor HALs, hardware drivers, and proprietary binaries | Yes | Yes (dm-verity) | Yes (Logical) | `VERIFIED` | [Primary Source: Google Android Source — Vendor Partitions, `https://source.android.com/docs/core/architecture/partitions/vendor-partitions`, Access Date: 2025-05-16] |
| `product` | Product-specific applications and configurations | Yes | Yes (dm-verity) | Yes (Logical) | `VERIFIED` | [Primary Source: Google Android Source — Product Partitions, `https://source.android.com/docs/core/architecture/partitions/product-partitions`, Access Date: 2025-05-16] |
| `userdata` | User data partition, encrypted via FBE (File-Based Encryption) | No | No (FBE Encrypted) | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — File-Based Encryption, `https://source.android.com/docs/security/features/encryption/file-based`, Access Date: 2025-05-16] |
| `metadata` | System metadata for Virtual A/B and FBE key storage | No | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — Metadata Partition, `https://source.android.com/docs/core/architecture/partitions/metadata`, Access Date: 2025-05-16] |
| `misc` | Bootloader message partition (`BCB` - Bootloader Control Block) | No | No | No (Physical) | `VERIFIED` | [Primary Source: Google Android Source — Rebooting into Recovery, `https://source.android.com/docs/core/architecture/bootloader`, Access Date: 2025-05-16] |
| `persist` | Calibration data, MAC addresses, persistent hardware flags | No | No | No (Physical) | `REPORTED` | [Primary Source: DeeX Master Plan Section 4.1 / Hardware Worksheet, Access Date: 2025-05-16] |
| `modem` / `radio` | Cellular modem firmware image | Yes | Yes | No (Physical) | `VERIFIED` | [Primary Source: Google Developers — Pixel Factory Firmware Structure, `https://developers.google.com/android/images`, Access Date: 2025-05-16] |

---

## 3. Physical Device Verification Questions

The following partition parameters cannot be determined solely from documentation and must be answered by the project owner from physical device output (`adb shell` / `fastboot`):

1. **Exact Block Sizes**: What are the exact byte sizes of physical `super`, `boot`, `userdata`, and `metadata` block devices (`ls -l /dev/block/by-name/`)? `NOT PROVIDED — owner device output required`.
2. **Dynamic Super Container Allocation**: What is the maximum logical capacity and active extent allocation in `super` reported by `lpmake` / `dmctl`? `NOT PROVIDED — owner device output required`.
3. **Mount Flags**: Are `system`, `vendor`, `product`, and `system_ext` mounted strictly read-only with `erofs` or `ext4` filesystems? `NOT PROVIDED — owner device output required`.
