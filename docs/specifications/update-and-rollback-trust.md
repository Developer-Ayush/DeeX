Status: Draft
Date: 2025-05-16
Master Plan Sections: 3.2, 14.2, 14.3, 17.1, 17.3

# DeeX Boot — Update, Rollback Protection, and Recovery Trust Policy

## 1. Objectives and Principles

This specification defines the trust policies governing over-the-air (OTA) system updates, anti-rollback index enforcement, update interruption recovery, and recovery partition security for the **DeeX Boot** module.

In accordance with Master Plan Sections 14.2 and 14.3:
- System updates MUST be cryptographically authenticated before application.
- Downgrading firmware to an older version containing known vulnerabilities MUST be prevented via hardware-enforced rollback protection.
- Interrupted updates or recovery mechanisms MUST NOT create a bypass route that grants unauthorized access to user account data or system privileges.

---

## 2. Update Package Authentication & Integrity

1. **Cryptographic Package Verification**:
   - Every system update zip package MUST be signed with the production release OTA key (`deex-release-key-ota`).
   - The recovery installer (`update_engine` / recovery binary) MUST verify the PKCS#1 v1.5 RSA-4090 signature and payload manifest hash before streaming or writing any bytes to flash partitions.
2. **Payload Hash Matching**:
   - The inner payload manifest (`payload.bin`) contains individual SHA-256 block hashes for target partitions (`boot`, `system`, `vendor`, etc.).
   - Writing to partition slots MUST verify each payload chunk against the signed manifest before commit.
3. **Rejection of Unauthenticated Packages**:
   - If signature verification fails, the package MUST be rejected immediately without modifying target partition state.

---

## 3. Anti-Rollback Protection Policy

1. **AVB Rollback Index Numbers**:
   - Every compiled image contains a monotonically increasing integer Rollback Index stored in the `vbmeta` header.
2. **Titan M2 Hardware Enforcement**:
   - Rollback index counters are stored in Titan M2 non-volatile secure storage (`rollback_index_location`).
   - During boot verification, the bootloader compares the `vbmeta` Rollback Index ($R_{img}$) with the Titan M2 stored value ($R_{hw}$):
     - If $R_{img} < R_{hw}$: **BOOT FAILS IMMEDIATELY (RED state halt).** The device refuses to boot the older image.
     - If $R_{img} > R_{hw}$: Bootloader writes $R_{img}$ into Titan M2 NVRAM to update $R_{hw} := R_{img}$, then proceeds to boot.
     - If $R_{img} = R_{hw}$: Boot succeeds without altering Titan M2 storage.
3. **Owner Policy on Security Downgrades**:
   - Deliberate software rollbacks are strictly forbidden in production release builds to prevent exploiting patched vulnerabilities.

---

## 4. Interrupted Update Handling & A/B Partitioning

Google Pixel 8 (`shiba`) utilizes Virtual A/B (VAB) seamless updates with dual boot slots (`slot_a` and `slot_b`).

1. **Dual Slot Isolation**:
   - Updates are streamed directly into the inactive slot (e.g. `slot_b` while active OS runs on `slot_a`).
   - The active slot (`slot_a`) remains untouched and fully functional during the entire update process.
2. **Atomic Slot Switch**:
   - Once installation completes and payload verification passes on `slot_b`, `update_engine` marks `slot_b` as `UNBOOTABLE` -> `BOOTABLE`.
   - The bootloader switches active boot slot to `slot_b` for the next restart.
3. **Interruption Safety**:
   - If power loss or reset occurs *during* update streaming to `slot_b`: `slot_b` remains marked `UNBOOTABLE`. On reboot, the bootloader seamlessly boots `slot_a` without service disruption.
   - If power loss occurs *during first boot* of `slot_b`: AVB checks boot attempt counter. If `slot_b` fails to complete boot after 3 attempts, bootloader automatically rolls back active slot designation to `slot_a`.

---

## 5. Recovery Path Security & Account Authentication Protection

Master Plan Section 14.3 requires that **recovery procedures must not create an undocumented route to bypass account authentication.**

1. **Identical Trust Policy**: Recovery and fastboot flash environments MUST enforce the exact same AVB verification policy as the main system OS. Unauthenticated recovery images MUST be rejected in locked state.
2. **Fastboot Wipe & Account Protection**:
   - Executing factory reset or data wipe via fastboot (`fastboot -w` / `fastboot erase userdata`) clears the `/data` partition, resulting in immediate cryptographic erasure of DeeX Vault keys.
   - Data wipe NEVER grants access to encrypted files or existing account sessions. Wiping storage renders encrypted data permanently unrecoverable.
3. **No Administrative Reset Route**:
   - Bootloader / recovery interfaces MUST NOT provide "password override", "account unlock", or "master clear bypass" facilities that expose account data.

---

## 6. Open Decisions for Project Owner

- **`DEC-BOOT-001`**: Rollback index increment policy during emergency security maintenance patches (automatic CI increment vs. manual owner decision).
- **`DEC-BOOT-002`**: Physical hardware behavior verification of Titan M2 rollback counter persistence across custom key re-enrollment.
