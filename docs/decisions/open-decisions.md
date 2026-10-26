# Open Decisions Log

The following architectural and hardware decisions must be resolved by the project owner before downstream execution chunks can proceed.

| Decision ID | Decision Required | Status | Owner | Blocking Reason / Dependencies |
|---|---|---|---|---|
| `DEC-001` | Target smartphone model and SoC | OPEN | Project owner | Blocks target device configs in Chunk 2 and Kernel/Boot customization. |
| `DEC-002` | Chosen AOSP release / branch | OPEN | Project owner | Blocks source manifest pinning (Chunk 3) and framework modifications. |
| `DEC-003` | Kernel version and source (AOSP common kernel vs. vendor kernel) | OPEN | Project owner | Blocks Kernel module configuration and hardware driver setup. |
| `DEC-004` | Availability and licensing of vendor source, firmware, and proprietary blobs for target device | OPEN | Project owner | Blocks vendor driver integration and hardware initialization. |
| `DEC-005` | Bootloader unlock/relock and AVB custom-key support on target device | OPEN | Project owner | Blocks Boot module Verified Boot (AVB) implementation. |
| `DEC-006` | Hardware security support on target device (Keymaster/KeyMint, StrongBox, secure element, trusted time source, biometric TEE) | OPEN | Project owner | Blocks Vault cryptographic key management and durable lockout time tracking. |
| `DEC-007` | Project's own software licence | OPEN | Project owner | Blocks formal repository distribution licensing. |
| `DEC-008` | Vulnerability-reporting contact | OPEN | Project owner | Blocks formal publication of SECURITY.md response procedure. |
| `DEC-009` | Build host specification (CPU, RAM, disk) and operating system | OPEN | Project owner | Blocks reproducible build environment configuration. |
| `DEC-010` | Whether and how the Google Mobile Services licensing process will be started, and who the legal applicant is | OPEN | Project owner | Blocks official GMS licensing application and certification workflow. |
| `DEC-011` | Windows-compatibility technical approach | OPEN | Project owner | Deferred to Windows module specification and architecture planning. |
