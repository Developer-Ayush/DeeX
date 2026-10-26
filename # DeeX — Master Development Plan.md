# DeeX — Master Development Plan
## Deep Encrypted Execution X-Kernel
**Document version:** 1.0  
**Status:** Foundational project specification  
**Platform:** ARM64 smartphones  
**Base:** Android Open Source Project (AOSP)  
**Primary objectives:** Security, encryption, account isolation, Android compatibility, and official Google certification and licensing.

---

# 1. Project Vision and Fundamental Requirements

## 1.1 Purpose

DeeX is a security-first mobile operating system derived from AOSP. It will retain the Android application framework needed to run Android applications while replacing or extending system components to implement DeeX's account, storage, authentication, and device-access policies.

The OS must combine everyday smartphone functionality with strong separation between users of the same physical device.

## 1.2 Mandatory requirements

1. Run on the selected ARM64 smartphone hardware.
2. Preserve the required Android framework and hardware interfaces.
3. Pursue official Android compatibility, Google Mobile Services licensing, and Google Play access.
4. Keep system code protected from ordinary users and external devices.
5. Provide separate, encrypted storage for every ordinary account.
6. Prevent cross-account access by applications, processes, and external devices.
7. Support the specified root-account responsibilities without exposing ordinary account credentials.
8. Implement the defined authentication, failed-attempt, and lockout policies.
9. Provide controlled USB and wireless file access.
10. Support the complete external-isolation switch.
11. Retain the Android and Windows compatibility toggles.
12. Recover safely from power loss, interrupted updates, and interrupted account deletion.
13. Test security properties rather than assuming that the design alone guarantees security.
14. Measure the actual installed size and resource usage from successful builds.

## 1.3 Fundamental security principle

DeeX must not rely on its user interface to enforce security.

Hiding a file, account, menu, or system directory is not sufficient. Access must be denied by the underlying permission system, kernel, storage encryption, trusted services, and hardware security mechanisms.

---

# 2. DeeX Base — Source and Build Foundation

## 2.1 Objectives

Establish the source repository, reproducible build environment, target-device configuration, and baseline AOSP image before adding custom security features.

## 2.2 Responsibilities

- Select and pin the supported AOSP release.
- Record the source manifest and exact revision of every required component.
- Establish the target ARM64 device configuration.
- Identify available vendor source, firmware, drivers, and proprietary hardware interfaces.
- Configure the Soong/Ninja build system and required build tools.
- Maintain separate configurations for development, testing, and release.
- Create a controlled integration process for custom DeeX modules.
- Record source licences and third-party dependencies.
- Maintain build logs, image hashes, configuration records, and release manifests.

## 2.3 Initial source structure

The logical DeeX project structure will be:

```text
DeeX/
├── docs/
│   ├── architecture/
│   ├── specifications/
│   ├── threat-model/
│   ├── testing/
│   └── decisions/
├── device/
│   └── target-device/
├── vendor/
│   └── target-device/
├── packages/
│   └── apps/
├── system/
│   └── deex/
│       ├── identity/
│       ├── vault/
│       ├── isolation/
│       ├── bridge/
│       ├── connectivity/
│       └── policy/
├── tests/
├── build/
└── release/
```

This is a logical organization. AOSP components will remain in their proper upstream directories, and vendor files will be included only where licensing permits.

## 2.4 Build rules

- Every build must identify its source revision and configuration.
- Custom modules must have explicit interfaces and documented dependencies.
- Production images must not contain development-only debugging privileges.
- Changes must be reproducible and reviewable.
- No security-critical module may be silently replaced with a mock implementation in a release build.
- Build failures must not be treated as successful outputs.

## 2.5 Completion criteria

A baseline AOSP image builds successfully, boots on the target hardware, and has documented hardware support, partition layout, and known limitations.

---

# 3. DeeX Boot — Secure Boot Chain

## 3.1 Objectives

Establish a verified chain of trust from the hardware root of trust to the running OS.

## 3.2 Responsibilities

- Integrate the supported bootloader and hardware root of trust.
- Configure Android Verified Boot (AVB) where supported.
- Verify the kernel, device tree, system partitions, and other covered partitions.
- Configure rollback protection where the device supports it.
- Protect release-signing keys and separate them from development keys.
- Establish a defined response to corrupted or unauthenticated system images.
- Ensure recovery and update images follow the same trust policy.
- Protect the integrity of DeeX's account-management and encryption services.

## 3.3 Required behaviour

An attacker must not be able to replace the installed DeeX system with a modified image and have it silently accepted as authentic.

The boot process must distinguish authorized system images from unauthorized or corrupted images.

## 3.4 Important boundary

Verified Boot does not automatically make user data confidential. It establishes software integrity; account encryption and authorization are separate responsibilities handled by DeeX Vault and DeeX Isolation.

## 3.5 Completion criteria

Boot integrity verification works on the target hardware, tampered images are handled according to the documented policy, and recovery behaviour is tested.

---

# 4. DeeX Kernel — System Foundation

## 4.1 Objectives

Configure the Linux kernel and platform support required for a secure, stable ARM64 smartphone OS.

## 4.2 Responsibilities

- Configure the target architecture and device drivers.
- Retain required display, touchscreen, audio, camera, modem, storage, Wi-Fi, Bluetooth, and sensor support.
- Configure memory protection, process isolation, and access-control mechanisms.
- Enable the kernel features required for encrypted storage.
- Configure mandatory access control through the appropriate Android security mechanisms, including SELinux.
- Restrict unnecessary kernel interfaces and privileged debugging facilities.
- Configure logging without exposing passwords, keys, or private account data.
- Support the device's supported secure hardware interfaces.
- Establish system-wide CPU and memory resource accounting.

## 4.3 Resource policy

The initial DeeX design targets:

- A system-wide CPU safety threshold in the approximate 80–90% utilization range.
- A reserve of approximately 10–20% of RAM for the kernel and essential system services.
- Resource sharing across accounts, with background processes continuing under the system-wide resource policy.

These are initial design targets, not guarantees of safe operating temperature. CPU utilization and available RAM alone cannot establish thermal safety. Hardware-supported thermal protection and the device's required thermal controls must remain functional.

## 4.4 Completion criteria

The kernel boots reliably, required hardware functions operate, isolation controls work, and resource accounting can distinguish account processes from essential system processes.

---

# 5. DeeX Vault — Encryption and Key Management

## 5.1 Objectives

Protect system data, ordinary account data, credentials, and encryption keys against unauthorized access.

## 5.2 System protection

- Protect system partitions through the boot-integrity mechanism.
- Use the target device's supported storage-encryption capabilities.
- Restrict access to system code and key material.
- Prevent ordinary USB access from exposing the system partition.
- Keep production cryptographic keys out of source code and build logs.

## 5.3 Account storage encryption

Each ordinary account must have its own independent encryption-key hierarchy.

A conceptual structure is:

```text
Hardware-backed security
          |
          v
DeeX Key Management
          |
          +---- Account A key hierarchy
          |          |
          |          +---- Account A data
          |
          +---- Account B key hierarchy
          |          |
          |          +---- Account B data
          |
          +---- Account C key hierarchy
                     |
                     +---- Account C data
```

This diagram is conceptual. Actual key derivation, wrapping, and storage must use the device's supported secure hardware and approved cryptographic mechanisms.

## 5.4 Credential-derived protection

The account design specifies the following inputs:

- Username
- Permanent user ID
- Password
- Original account-creation time

These values may provide account context to the key hierarchy, but they must not simply be concatenated and hashed to form a storage key.

The implementation must use a proper password-based key derivation function, independent random salt, and a suitable key-wrapping design. Account metadata that can change, such as username, must not be a direct dependency that makes existing data inaccessible after a username change.

The account's permanent identity and original creation metadata can be bound to its key hierarchy without making routine credential changes destructive.

## 5.5 Password storage

- Never store plaintext passwords.
- Store salted password-verifier hashes produced by a suitable password-hashing scheme.
- Compare the submitted credential with the stored verifier using the defined authentication process.
- Protect credential records against unauthorized modification.
- Avoid logging passwords, password hints, or derived secrets.

## 5.6 Credential changes

When a password or username changes:

1. Authenticate the account owner.
2. Validate the new credential input.
3. Update the relevant credential record atomically.
4. Preserve access to existing account data through key wrapping or controlled key rotation.
5. Ensure interruption during the update cannot leave the account in an inconsistent state.

## 5.7 Account deletion and cryptographic erasure

The immediate security objective is to destroy the account's usable decryption keys and key-wrapping paths so that its encrypted data becomes cryptographically inaccessible.

After that:

- Record the storage regions associated with the deleted account.
- Process eligible regions in small background chunks.
- Save sanitization progress durably.
- Resume interrupted work after a restart.
- Write best-effort overwrite patterns and zeroes where supported.
- Allow already-sanitized or unneeded space to be reassigned according to the storage allocator's rules.

Physical flash storage uses wear-leveling and remapping. Consequently, logical overwriting cannot guarantee that every physical NAND cell has been overwritten. Cryptographic erasure is the immediate protection; background sanitization is a secondary measure.

## 5.8 Completion criteria

Independent account encryption is verified, credential changes preserve data, deleted-account keys become unusable, and power-loss tests demonstrate safe recovery.

---

# 6. DeeX Identity — Accounts and Authentication

## 6.1 Account types

### Root account

The root account is a special system-management identity.

It can:

- Create ordinary accounts.
- Authorize account creation using its password.
- Manage Android and Windows compatibility toggles.
- Control the external-isolation switch.
- Access the dedicated root management interface.

It cannot:

- Delete ordinary accounts.
- View ordinary users' passwords or password hashes through its interface.
- View ordinary account encryption keys.
- Install ordinary applications through the root interface.
- Access ordinary account files merely because it is root.

The interface must not expose ordinary user IDs, passwords, or other account credentials. The account-listing interface displays ordinary usernames.

These restrictions must be enforced by the DeeX management services and access-control policy, not by merely hiding UI elements.

### Ordinary accounts

Each ordinary account has:

- A permanent, unique user ID.
- A changeable username.
- A password.
- An optional registered fingerprint.
- An independent encrypted storage area.
- An independent failed-password counter and lockout state.
- An independent fingerprint-failure state.

There is no fixed account count or fixed per-account storage quota. Actual storage availability, RAM, CPU capacity, hardware limits, and system-reserved resources remain binding constraints.

## 6.2 Account creation

Account creation is available from the login screen and requires root-password authorization.

The creation workflow collects:

1. Username.
2. Permanent user ID.
3. Password.
4. Password confirmation where required by the account-creation UI.
5. Optional password hints.

If the requested user ID is already taken, the user must choose another. Usernames and passwords need not be unique.

Once created, the user ID cannot be changed. The username and password can be changed later by the account owner.

The creation process must allocate independent storage and keys without overlapping another account's protected allocation.

## 6.3 Login workflow

1. Display the lock screen.
2. Ask for the user ID.
3. Resolve the user ID to the corresponding account.
4. Display that account's authentication screen.
5. Accept the password or registered fingerprint where available.
6. Unlock only that account's protected data and session.

An unknown user ID does not increment an ordinary account's failed-password counter.

After three incorrect user ID attempts, request the root password in a single-field prompt. After successful root authentication, return to the user ID and password login screen.

## 6.4 Ordinary password failure policy

Each ordinary account has its own independent counter.

| Consecutive failed passwords | Lockout duration |
|---|---:|
| First group of 3 | 30 seconds |
| Second group of 3 | 1 minute |
| Third group of 3 | 2 minutes |
| Fourth group of 3 | 4 minutes |
| Fifth group of 3 | 8 minutes |

Every additional group of three failures doubles the previous lockout duration.

A successful password login resets the account's failed-password counter to zero.

## 6.5 Root password failure policy

Root authentication has its own independent counter and the same escalating sequence:

- Three failures: 30-second lockout.
- Next three failures: 1-minute lockout.
- Next three failures: 2-minute lockout.
- Subsequent groups of three double the previous lockout duration.

Root lockout state must not be merged with any ordinary account's counter.

## 6.6 Persistence of lockouts

Store lockout state and unlock timestamps durably so restart or power loss cannot reset the policy.

The time source must resist ordinary software clock manipulation. A normal wall clock alone is insufficient because an attacker may attempt to roll it backward.

The implementation must use available trusted time and hardware facilities where supported and document what protection is achievable on the target device.

## 6.7 Fingerprint authentication

Fingerprint authentication is available to ordinary accounts only. Root always requires its password.

Workflow:

1. Enter the user ID.
2. Open the account's authentication screen.
3. Authenticate with either the password or registered fingerprint.
4. Unlock the account after successful authentication.

Fingerprint policy:

- Eleven failed fingerprint verifications permanently disable fingerprint login for that account until successful password authentication.
- The disabled state and attempt counter survive restart and power loss.
- A successful password login automatically re-enables fingerprint authentication and resets the fingerprint-failure counter.
- A fingerprint failure for one account does not count against another account.

Fingerprint verification must use the device's supported secure biometric subsystem. The design must account for hardware-enforced retry limits and secure biometric state; a software-only counter must not be represented as tamper-proof if privileged software could reset it.

## 6.8 Password hints and forgotten passwords

During account creation, users may enter hints to help remember their password.

The Forgot Password interface displays the hints.

If the owner cannot remember the password, the account has no password-reset or administrative recovery route under the current specification. The owner may permanently lose access to its encrypted data.

Password hints must not reveal the password itself or be treated as authentication credentials.

## 6.9 Owner-controlled credential changes

After logging in, the account owner can open Settings and change the username or password by entering the current password.

For password changes:

- Request the new password twice.
- If the entries differ, ask the user to enter them again.
- Replace the stored credential verifier atomically once validation succeeds.
- Preserve the existing data-encryption hierarchy.

## 6.10 Owner-controlled account deletion

The owner can request deletion from Settings by entering the username, user ID, and password.

The system must authenticate the request against the intended account, confirm that the account is the one being deleted, and begin the defined cryptographic-erasure and background-sanitization procedure.

Root cannot delete accounts.

## 6.11 Completion criteria

Account creation, login, password changes, fingerprint handling, lockouts, and deletion are tested independently for every account type.

---

# 7. DeeX Isolation — Account Separation

## 7.1 Objectives

Make ordinary accounts independent security domains even though they share the same physical smartphone.

## 7.2 Storage isolation

- Each account has its own protected storage allocation.
- Storage allocations must not overlap.
- One account cannot list, read, modify, or delete another account's files.
- Applications cannot request access to another account's storage.
- A root-management interface cannot bypass the account-access policy.
- System services must not expose protected data across account boundaries.
- Shared device services must expose only the specific information explicitly defined as shared.

## 7.3 Process isolation

The implementation must map DeeX accounts to appropriate Android/Linux user identities, processes, namespaces where applicable, and access-control rules.

The ordinary Android application sandbox remains a separate layer inside each account.

The policy must be enforced in privileged services and the kernel; it cannot rely exclusively on application cooperation.

## 7.4 Application installation

Within an ordinary account:

- The owner may install applications from any source.
- There is no mandatory DeeX malware scan before installation.
- No mandatory DeeX application store is required.
- Applications may use the inter-application access and sharing facilities allowed inside that same account.

This unrestricted-within-account design does not override the system's mandatory account boundaries. An application cannot obtain another account's private files or identity simply because it has broad permissions inside its own account.

## 7.5 Concurrent account sessions

Only one ordinary account is active in the foreground at a time.

When an account is locked or another account becomes active:

- Its session may remain open.
- Its applications may continue running in the background.
- Its protected storage remains unavailable to other accounts.
- Its processes remain subject to system-wide CPU and RAM constraints.

The OS must not confuse background execution with permission to access the foreground account.

## 7.6 Account count and resource management

There is no fixed account-count limit in the DeeX policy. The implementation may report insufficient resources when the hardware cannot support another account or session.

It must not allocate overlapping storage or allow one account's bookkeeping to corrupt another account's data.

## 7.7 Completion criteria

Cross-account read, write, process-access, application-sharing, and session-switching tests demonstrate isolation under both normal and adversarial conditions.

---

# 8. DeeX Interface — Login and System UI

## 8.1 Objectives

Provide a minimal and understandable smartphone interface that reflects DeeX's account and authentication policies.

## 8.2 Login interface

The login screen must support:

- User ID entry.
- Account-specific password entry.
- Fingerprint authentication for eligible ordinary accounts.
- Root-password prompts where specified.
- Lockout messages and remaining lockout time.
- Account creation with root authorization.
- Password-hint display through Forgot Password.

The login screen must not disclose account data to unauthenticated users beyond the information intentionally exposed by the specified login workflow.

## 8.3 Root interface

The root interface is a restricted management environment. It shows ordinary usernames and provides only the authorized management controls.

It must not expose ordinary passwords, password hashes, encryption keys, or private account files.

Root cannot install applications or delete ordinary accounts.

## 8.4 Essential applications

The minimal system application set includes:

- Camera.
- Calls.
- Settings.
- Messages.
- Clock.

The camera, gallery, photos, videos, and other ordinary non-SIM content remain private to the account that owns them.

Calls and messages use the shared device-level telephony policy described in DeeX Connect.

## 8.5 UI and security separation

UI components request operations from authenticated system services. A visual button is not the authority that grants access.

The UI must clearly distinguish:

- Authentication failure.
- Account lockout.
- Fingerprint disabled after eleven failures.
- Root authentication.
- Account creation.
- Account deletion.
- External isolation being enabled or disabled.
- Android or Windows compatibility being enabled or disabled.

## 8.6 Completion criteria

Every interface flow is tested against its corresponding authorization policy, including attempts to bypass the UI and call the underlying services directly.

---

# 9. DeeX Connect — Communications and Connectivity

## 9.1 Objectives

Implement device connectivity while preserving the defined distinction between shared telephony services and private account settings.

## 9.2 Shared SIM-related activities

The following are shared across ordinary accounts:

- Cellular calls.
- SMS sending and receiving.
- The full shared SMS inbox and message history.
- SIM-associated contacts.
- Mobile data.

All accounts can view the shared SMS inbox and history.

Because the telephony hardware is device-level, the implementation must explicitly mediate which account can initiate a call, send a message, or interact with the shared message history. Account isolation must not accidentally expose unrelated private files.

## 9.3 Private account activities

The following remain private to their owning account:

- Camera output and gallery.
- Photos and videos.
- Other non-SIM files and applications.
- Saved Wi-Fi credentials and account-specific Wi-Fi preferences.

## 9.4 Wi-Fi policy

Each ordinary account has its own private Wi-Fi settings and saved credentials.

The root account can maintain its own Wi-Fi connection for use when no ordinary account is active.

The implementation must reconcile private saved credentials with the fact that the physical Wi-Fi interface is shared by the device.

A private account's saved password must not become visible to another account merely because the network interface is shared.

## 9.5 Bluetooth and wireless transfers

Wireless transfers follow the account-scoped file-access policy:

- A transfer initiated from an account can expose only the storage portion explicitly made available by that account.
- Root authentication is not required for ordinary account-scoped wireless file transfers under the current design.
- Another account's private storage remains inaccessible.

## 9.6 NFC

NFC is disabled across the OS, including root and applications. No DeeX interface may enable it.

## 9.7 External-isolation switch

Root controls a complete external-isolation switch.

When OFF, the OS must cut external communications, including:

- Cellular calls.
- SMS.
- Mobile data.
- Wi-Fi communications.
- Bluetooth communications and transfers.
- Wired external connections.
- GPS/location services and location tracking.
- Other supported external communication paths.

The implementation must use the appropriate hardware and driver controls where available, not merely hide connectivity settings or block applications while radios remain operational.

The switch state persists across restart and power loss.

When external connectivity is restored, previously disabled services must not be automatically enabled. Root may restore the previous configuration or choose services manually.

## 9.8 Important implementation boundary

Emergency calling and other legally or technically mandated device behaviours must be documented against the target hardware and applicable requirements. DeeX must not claim that a software switch physically disables a radio unless the implementation and hardware behaviour establish that fact.

## 9.9 Completion criteria

Shared telephony, private Wi-Fi credentials, wireless file transfers, NFC disablement, isolation-state persistence, and external communication cut-off are tested on the actual device.

---

# 10. DeeX Bridge — USB and External Device Access

## 10.1 Objectives

Allow a connected computer to access one authenticated account's files without exposing the system partition or other accounts.

## 10.2 Connection workflow

Every USB connection starts unauthenticated.

1. The connected device initially sees an empty drive.
2. DeeX requests the root password.
3. After successful root authentication, DeeX requests the relevant account's user ID and password.
4. After successful account authentication, the computer receives access only to that account's permitted files.
5. On disconnection, the authorization expires.

The latest specified flow uses the root password for the first stage, followed by the ordinary account's user ID and password.

## 10.3 Authorized access

After both authentication stages succeed, the connected device may:

- Read authorized files.
- Create files.
- Modify files.
- Delete files.

It cannot access:

- Another account's private storage.
- The root account's private management environment.
- System code or protected system partitions.
- Account encryption keys or credential records.

## 10.4 Session authorization

- Every connection requires fresh authentication.
- Previously recognized devices do not receive automatic access.
- Disconnecting invalidates the authorization.
- Reconnecting requires the full authentication sequence again.

## 10.5 Device public keys

The OS may retain a connected device's public key to identify or recognize that device in the future.

This key is an identification aid only. It does not replace root authentication, account authentication, or fresh connection authorization.

## 10.6 External-device lockout policy

USB authentication failures use a counter separate from the mobile device's ordinary login counters.

The external-device policy is:

- Three failures: 30-second lockout.
- Next three failures: 1-minute lockout.
- Next three failures: 2-minute lockout.
- Every further group of three doubles the previous lockout duration.

This policy is independent of the phone's ordinary account lockout state.

## 10.7 Completion criteria

USB access is tested for fresh authentication, authorization expiry, correct account scoping, file modification, lockout persistence, and attempts to access protected system or account data.

---

# 11. DeeX Android — Android Application Compatibility

## 11.1 Objectives

Retain the Android platform components required for Android applications while removing unnecessary components that are not needed for DeeX's intended functionality or certification.

## 11.2 Retained components

The build must preserve the required portions of:

- Android application runtime.
- Android framework APIs.
- Core system services.
- Application lifecycle management.
- Package management and permission handling.
- Graphics and media frameworks.
- Required hardware abstraction layers.
- Binder-based system communication.
- Required Android libraries and compatibility interfaces.

The exact component set will be established from the selected AOSP release, target hardware, required application features, and compatibility requirements.

## 11.3 Removed components

Potentially removable components include:

- Unneeded bundled applications.
- Unnecessary browser components.
- Unused services and packages.
- Debugging utilities not required in production.
- Other components proven to be unnecessary for system operation or required certification.

Removal must be based on dependency analysis and compatibility tests rather than package names alone.

## 11.4 Google component boundary

AOSP and Google Mobile Services are not the same thing.

Google Play, proprietary Google applications, and licensed GMS components cannot be assumed to be present in the AOSP source tree. They must be integrated through the appropriate official licensing and distribution process.

Therefore, stripping unnecessary Google-related components must never mean removing components that DeeX's required Google configuration needs.

## 11.5 Compatibility toggle

Root controls the Android compatibility toggle.

- When OFF, DeeX follows its defined policy for preventing Android applications from launching.
- When ON, the Android application environment is available.
- Opening an Android application while compatibility is ON launches it through the supported Android runtime.
- The toggle persists across restart and power loss.
- When re-enabled, DeeX may restore the previous state or let root choose manually.
- Previously disabled services must not be automatically enabled.

## 11.6 Completion criteria

Representative Android applications install and run, framework behaviours remain compatible, account isolation is preserved, and the selected compatibility test suites pass.

---

# 12. DeeX Windows — Windows Application Compatibility

## 12.1 Objectives

Provide a separate, root-controlled mechanism for running supported Windows applications where technically feasible on the target ARM64 smartphone.

## 12.2 Architecture

This module must remain separate from the core Android framework and account-management services.

Its design must establish:

- Supported Windows executable formats.
- ARM64-native versus translated instruction execution.
- Required compatibility libraries and APIs.
- Graphics, audio, input, and filesystem integration.
- Application installation and launch handling.
- Isolation from other accounts.
- CPU, memory, storage, and battery requirements.

## 12.3 Compatibility toggle

Root controls the Windows compatibility toggle.

- OFF prevents the Windows compatibility environment from launching applications.
- ON permits supported Windows applications to use the selected compatibility mechanism.
- The toggle persists across restart and power loss.
- Previously disabled services are not automatically enabled when compatibility is restored.

## 12.4 Scope limitations

Windows compatibility is not equivalent to running the full Windows desktop operating system. The module will support only the applications and execution models that its selected implementation can actually run.

## 12.5 Completion criteria

The implementation demonstrates a defined set of supported applications, correct account isolation, predictable resource consumption, and reliable enable/disable behaviour.

---

# 13. DeeX Google — Google Services and Certification

## 13.1 Objectives

Pursue official Android compatibility, Google Mobile Services licensing, Google Play availability, and the applicable Google Play Integrity requirements.

These are mandatory project goals, subject to Google's evaluation and approval.

## 13.2 Compatibility process

The project must:

1. Select the intended Android release.
2. Implement the applicable Android Compatibility Definition Document (CDD).
3. Run the relevant Compatibility Test Suite (CTS).
4. Address failures and regressions.
5. Run additional required compatibility and vendor tests.
6. Follow the applicable Google partner and licensing process.
7. Integrate authorized GMS components when licensed.
8. Validate Google Play installation, updates, and required service behaviour.

The CDD and CTS requirements vary by Android release. They must be pinned to the release selected for DeeX.

## 13.3 Certification is not a bypass mechanism

DeeX will pursue legitimate device compatibility and licensing. It must not rely on falsifying device identity, spoofing integrity results, bypassing attestation, or disguising an uncertified image as a certified one.

Custom account isolation, boot-integrity changes, or modifications to system services must be evaluated for their effect on compatibility and Google approval.

## 13.4 Google Play Integrity

Testing must cover the applicable integrity verdicts and supported hardware-backed attestation requirements.

A successful local CTS run does not, by itself, guarantee GMS licensing or every Play Integrity verdict.

The final result depends on the device configuration, supported security hardware, approved software image, applicable requirements, and Google's decisions.

## 13.5 Completion criteria

The project has documented CTS results, required compatibility evidence, authorized GMS integration, and verified Google Play behaviour. Certification and licensing are recorded as achieved only after official approval.

---

# 14. DeeX Lifecycle — Updates, Recovery, and Account Deletion

## 14.1 Objectives

Keep DeeX secure and recoverable throughout installation, updates, account changes, deletion, and system failure.

## 14.2 System updates

- Authenticate update packages.
- Verify their integrity before installation.
- Use the supported verified-boot and rollback-protection mechanisms.
- Protect signing keys.
- Avoid partially applied updates that leave the system unbootable.
- Preserve account encryption and access-control invariants.
- Test update failures and interrupted installation.

## 14.3 Recovery

Recovery must define how to handle:

- Corrupted system partitions.
- Failed updates.
- Interrupted boot.
- Interrupted account deletion.
- Interrupted background sanitization.
- Interrupted credential updates.
- Damaged account metadata.

Recovery procedures must not create an undocumented route to bypass account authentication.

## 14.4 Account deletion lifecycle

The required sequence is:

1. Authenticate the account owner.
2. Validate the account-deletion request.
3. Make the account unavailable for normal login.
4. Destroy the keys or key-wrapping paths needed to decrypt its data.
5. Record storage regions requiring further sanitization.
6. Perform best-effort background overwrite and zeroing.
7. Persist progress so sanitization resumes after restart.
8. Reclaim storage only when the allocator can do so safely.

## 14.5 Background sanitization policy

The initial design targets background sanitization when CPU usage is below approximately 40–50%, pausing or reducing work above that range.

The system must track progress, avoid interfering with essential services, and resume after power loss.

The intended completion time is approximately five to six days, but this is a target rather than a guaranteed deadline. Storage size, device performance, flash behaviour, and workload affect the duration.

## 14.6 Completion criteria

Updates and recovery preserve the security invariants, deletion makes data cryptographically inaccessible immediately, and background sanitization resumes safely after interruption.

---

# 15. DeeX Validation — Security, Reliability, and Performance Testing

## 15.1 Objectives

Verify that the implementation satisfies the requirements through repeatable tests rather than relying on design claims.

## 15.2 Account security tests

Test:

- Duplicate user ID rejection.
- Username changes.
- Password changes.
- Password mismatch handling.
- Per-account failed-password counters.
- Escalating lockouts.
- Lockout persistence across reboot.
- Unknown user ID handling.
- Root-password escalation.
- Fingerprint failure counting.
- Fingerprint disablement after eleven failed attempts.
- Automatic fingerprint re-enablement after successful password authentication.
- Root password-only authentication.

## 15.3 Storage and isolation tests

Test:

- Independent account encryption.
- Storage allocation separation.
- Attempts to read another account's files.
- Attempts to modify another account's files.
- Attempts to access protected keys and credential records.
- Application-to-application access inside one account.
- Attempts by applications to access another account.
- Background sessions during account switching.
- Account deletion and interrupted sanitization.

## 15.4 Connectivity tests

Test:

- Shared call functionality.
- Shared SMS inbox and history.
- Shared SIM-associated contacts.
- Mobile-data behaviour.
- Private Wi-Fi credentials.
- Wireless file transfer limited to the initiating account's exposed storage.
- NFC remaining disabled.
- External-isolation switch behaviour.
- Persistence of switch state across restart.
- Restoration without automatically enabling previously disabled services.

## 15.5 USB tests

Test:

- Empty-drive presentation before authentication.
- Root-password authentication.
- Ordinary account authentication.
- Read, create, modify, and delete permissions.
- Access attempts against another account.
- Access attempts against system partitions.
- Authorization expiry on disconnect.
- Mandatory reauthentication on reconnect.
- Independent external-device lockout behaviour.

## 15.6 Android and Google tests

Test:

- Android application installation and launch.
- Required framework APIs and behaviours.
- Package management and application lifecycle.
- CTS and other applicable compatibility suites.
- GMS operation after authorized integration.
- Google Play installation and updates.
- Applicable Play Integrity behaviour.
- Regressions caused by DeeX customizations.

## 15.7 Performance tests

Measure:

- Boot time.
- Installed OS size.
- System partition usage.
- RAM consumption.
- CPU usage under multiple account sessions.
- Storage throughput and encryption overhead.
- Battery consumption.
- Background sanitization throughput.
- Android compatibility overhead.
- Stability under resource pressure.

## 15.8 Completion criteria

Each test has a documented procedure, expected result, actual result, and reproducible evidence. Critical failures must be fixed or explicitly prevent release; they cannot be hidden by declaring the module complete.

---

# 16. DeeX Release — Production Image

## 16.1 Objectives

Produce a tested, installable image for the selected smartphone.

## 16.2 Release requirements

- A pinned and documented source revision.
- A reproducible production build.
- Verified boot and appropriate signing.
- Working hardware support.
- Functional account and storage isolation.
- Tested authentication and lockout policies.
- Working connectivity and external-device policies.
- Validated update and recovery behaviour.
- Completed compatibility testing.
- Documented GMS licensing and certification status.
- Software bill of materials and third-party licence records.
- Installation and recovery instructions.
- A record of known limitations and supported hardware.

## 16.3 Release measurements

The release must report measured values rather than preliminary estimates for:

- Downloaded image size.
- Installed system partition size.
- Required user-data space.
- Minimum usable storage.
- Idle and active RAM usage.
- Boot time.
- Battery consumption under defined tests.
- Background sanitization performance.

## 16.4 Completion criteria

The production image boots on the target device, the required security and functionality tests pass, the installation and recovery process is documented, and the certification status is accurately represented.

---

# 17. Cross-Module Rules

These requirements apply to all 15 modules.

## 17.1 Security boundaries

No module may bypass DeeX account isolation simply because it runs as a privileged system service. Any cross-account access must be explicitly defined by the shared-service policy.

## 17.2 Credential handling

Passwords, password hashes, biometric templates, encryption keys, and recovery-sensitive metadata must not be exposed through ordinary application interfaces or logs.

## 17.3 Failure handling

A failed authentication, interrupted update, corrupted metadata record, or power loss must not silently grant additional access.

## 17.4 Resource handling

All modules must account for the shared CPU, RAM, storage, and hardware resources of the phone.

## 17.5 Configuration persistence

The Android compatibility toggle, Windows compatibility toggle, external-isolation state, and required lockout state must persist across restart and power loss.

## 17.6 Documentation

Each module must document:

- Its purpose.
- Its public interfaces.
- Its dependencies.
- Its security assumptions.
- Its configuration.
- Its tests.
- Its known limitations.
- Its completion status.

## 17.7 No unverified claims

DeeX must not be described as certified, cryptographically secure, tamper-proof, or fully isolated unless the relevant implementation and evidence support the claim.

---

# 18. Project-Wide Completion Definition

DeeX is considered ready for its intended production release only when:

1. The selected AOSP base builds reproducibly.
2. The target hardware is supported.
3. The boot chain verifies the intended system image.
4. Account storage is independently encrypted and isolated.
5. The root and ordinary account policies operate as specified.
6. Authentication and lockout policies survive restart and power loss.
7. Shared telephony and private account resources behave as specified.
8. USB and wireless transfers enforce account-scoped access.
9. The external-isolation switch behaves according to its defined policy.
10. Android compatibility is functional.
11. Windows compatibility has a documented and tested supported scope.
12. Required Google compatibility testing and licensing processes have been completed to the extent necessary for the release claim.
13. Account deletion and recovery are tested.
14. Critical security and reliability failures have been resolved.
15. The release image and its limitations are documented.

**The central rule of DeeX:** encryption protects data, authentication establishes identity, authorization controls access, isolation separates accounts, verified boot protects system integrity, and testing provides evidence that these mechanisms work together.

This master plan defines the project's baseline requirements. Implementation details may be refined as necessary to satisfy the actual hardware, AOSP release, security mechanisms, and official compatibility requirements without silently discarding the agreed objectives.
