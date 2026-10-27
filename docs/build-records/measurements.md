Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.5, 15.7, 16.3

# DeeX Baseline System Measurements & Performance Log

This document records the official baseline OS measurements for Google Pixel 8 (`shiba`) on Android 15 (`android-15.0.0_r1`).

Per Master Plan Section 16.3, all values below must report **real measured numbers** obtained from verified build outputs and device testing. All entries remain initialized to `NOT MEASURED` until the project owner runs the baseline build and flash steps and reports the real values via the intake form (`docs/build-records/results-intake-template.md`).

---

## 1. Source & Build Environment Metrics

| Metric | Measured Value | Target / Requirement | Status |
|---|---|---|---|
| **AOSP Release Tag** | `android-15.0.0_r1` | Pinned AOSP tag | ACCEPTED |
| **Target Build Target** | `aosp_shiba-userdebug` | Google Pixel 8 | ACCEPTED |
| **Pinned Manifest SHA-256** | `NOT MEASURED` | Exact hash of `aosp-pinned.xml` | PENDING OWNER BUILD |
| **Sync Source Disk Usage** | `NOT MEASURED` | Estimated 180-250 GB | PENDING OWNER BUILD |
| **Sync Duration** | `NOT MEASURED` | Measured duration | PENDING OWNER BUILD |
| **Build Duration** | `NOT MEASURED` | Measured duration | PENDING OWNER BUILD |
| **Peak RAM During Build** | `NOT MEASURED` | Minimum 32 GB host RAM | PENDING OWNER BUILD |
| **Peak Disk Usage During Build** | `NOT MEASURED` | Maximum 400 GB allocation | PENDING OWNER BUILD |
| **Build Warning Count** | `NOT MEASURED` | Tracked build warnings | PENDING OWNER BUILD |
| **Toolchain Versions** | `NOT MEASURED` | Repo, Git, Python, OpenJDK | PENDING OWNER BUILD |

---

## 2. Image & Partition Storage Measurements

| Artifact Name | Partition | File Size | SHA-256 Checksum |
|---|---|---|---|
| `boot.img` | Boot Partition | `NOT MEASURED` | `NOT MEASURED` |
| `system.img` | System Logical Partition | `NOT MEASURED` | `NOT MEASURED` |
| `vendor.img` | Vendor Logical Partition | `NOT MEASURED` | `NOT MEASURED` |
| `product.img` | Product Logical Partition | `NOT MEASURED` | `NOT MEASURED` |
| `system_ext.img` | System Ext Partition | `NOT MEASURED` | `NOT MEASURED` |
| `vbmeta.img` | Verified Boot Metadata | `NOT MEASURED` | `NOT MEASURED` |
| `super.img` | Dynamic Super Partition | `NOT MEASURED` | `NOT MEASURED` |

---

## 3. Runtime & Hardware Performance Measurements (Master Plan 15.7 & 16.3)

| Performance Category | Metric Description | Measured Value | Master Plan Target | Status |
|---|---|---|---|---|
| **Boot Metrics** | Cold Boot Time (Power on to Lock Screen) | `NOT MEASURED` | Baseline benchmark | PENDING CHUNK 5 |
| **Storage Usage** | Installed System Partition Usage | `NOT MEASURED` | Baseline OS footprint | PENDING CHUNK 5 |
| **Storage Usage** | Minimum Usable Userdata Allocation | `NOT MEASURED` | Per-account storage | PENDING CHUNK 5 |
| **Memory Usage** | Idle RAM Usage (System Services Only) | `NOT MEASURED` | 10–20% RAM reserved | PENDING CHUNK 5 |
| **Memory Usage** | Active RAM Usage (Concurrent Accounts) | `NOT MEASURED` | Multi-account load | PENDING CHUNK 5 |
| **CPU Usage** | Idle CPU Load | `NOT MEASURED` | Baseline CPU utilization | PENDING CHUNK 5 |
| **CPU Usage** | CPU Load Under Concurrent Accounts | `NOT MEASURED` | 80–90% utilization limit | PENDING CHUNK 5 |
| **Storage Overhead** | FBE v2 Storage Encryption Throughput | `NOT MEASURED` | Cryptographic overhead | PENDING CHUNK 5 |
| **Battery Life** | Idle Battery Drain (24-hour baseline) | `NOT MEASURED` | Baseline battery draw | PENDING CHUNK 5 |
| **Sanitization** | Background Storage Sanitization Speed | `NOT MEASURED` | Target 5-6 day cycle | PENDING CHUNK 5 |
