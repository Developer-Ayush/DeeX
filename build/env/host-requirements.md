# DeeX Build Host Requirements & Fit Analysis

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.1, 2.2, 2.4

## Baseline Host Requirements (Primary Source Guidelines)

The minimum and recommended hardware/OS specifications for building AOSP baseline images for Google Pixel 8 (`shiba`) are derived directly from official Android Open Source Project documentation:

- **Primary Source 1**: AOSP Establishing a Build Environment (`https://source.android.com/docs/setup/start/initializing`, Access Date: 2025-05-16, Confidence: `VERIFIED`)
- **Primary Source 2**: AOSP Requirements (`https://source.android.com/docs/setup/start/requirements`, Access Date: 2025-05-16, Confidence: `VERIFIED`)

### Documented Requirements Table

| Resource Dimension | Minimum Threshold | Recommended Target | Primary Source Citation |
|---|---|---|---|
| **Operating System** | Ubuntu 22.04 LTS 64-bit (x86_64 or ARM64) | Ubuntu 22.04 LTS 64-bit | `source.android.com/docs/setup/start/initializing` |
| **CPU Cores** | 8 logical CPU cores | 16+ CPU cores (`nproc >= 16`) | `source.android.com/docs/setup/start/requirements` |
| **System RAM** | 32 GB RAM (16 GB with swap) | 64 GB+ RAM | `source.android.com/docs/setup/start/requirements` |
| **Free Storage Space** | 400 GB free disk space | 500 GB+ NVMe SSD storage | `source.android.com/docs/setup/start/requirements` |
| **Container / Virtualization** | Docker v20.10+ / OCI runtime | Docker v24.0+ container engine | `source.android.com/docs/setup/start/initializing` |

## Project Owner Build Host Specification & Fit Evaluation

The project owner provided the following build host parameter inputs in Chunk 3 prompt communications:

| Parameter | Owner Provided Input | Minimum Requirement | Fit Assessment |
|---|---|---|---|
| **Build Host OS & Version** | `UNKNOWN — decision required` | Ubuntu 22.04 LTS 64-bit | **UNVERIFIED** |
| **CPU Cores** | `UNKNOWN — decision required` | 8 cores | **UNVERIFIED** |
| **RAM Capacity** | `UNKNOWN — decision required` | 32 GB RAM | **UNVERIFIED** |
| **Free Disk Space** | `UNKNOWN — decision required` | 400 GB free disk | **UNVERIFIED** |
| **Container / VM Execution** | `UNKNOWN — decision required` | Docker container recommended | **UNVERIFIED** |

### Host Fit Finding

Because all build host parameters remain `UNKNOWN — decision required`, the project owner's build host fitness **cannot be verified** at this time.

Before attempting a full AOSP source sync or image compilation in Chunk 4, the project owner must verify that the build machine meets or exceeds the documented minimums (8+ CPU cores, 32+ GB RAM, 400+ GB free disk space, Ubuntu 22.04 LTS / Docker).
