# Architecture Overview

*Status:* Draft — derived from Master Development Plan v1.0

## Module Hierarchy & Execution Flow

DeeX consists of 15 logical modules structured in dependency order:

1. **Boot**: Verified boot chain (AVB) from hardware root of trust.
2. **Kernel**: Linux kernel, driver interfaces, SELinux, process & memory controls.
3. **Vault**: Storage encryption, hardware key hierarchies, cryptographic erasure.
4. **Identity**: Multi-account management, authentication verifiers, lockouts.
5. **Isolation**: Per-account storage & process boundaries.
6. **Interface**: System UI, login lockscreen, root interface, minimal apps.
7. **Connect**: Telephony mediation, private Wi-Fi, external-isolation switch.
8. **Bridge**: USB computer connection, dual-stage authentication, lockout counters.
9. **Android**: AOSP application runtime, framework preservation, compatibility toggle.
10. **Windows**: Supported Windows execution layer, ARM64 translation, compatibility toggle.
11. **Google**: Compatibility (CDD/CTS), official GMS licensing, Play Integrity.
12. **Lifecycle**: Safe system updates, rollback protection, recovery, background sanitization.
13. **Validation**: Test suites for security, isolation, performance, and stability.
14. **Release**: Production image build, SBoM, performance metrics.
15. **Base**: Source repository, build environment, device configs.

### Module Dependency Chain

```text
Boot -> Kernel -> Vault -> Identity / Isolation -> Interface / Connect / Bridge -> Android / Windows -> Google -> Lifecycle -> Validation -> Release
```

## Central Security Rule

**Central Rule of DeeX:** Encryption protects data, authentication establishes identity, authorization controls access, isolation separates accounts, verified boot protects system integrity, and testing provides evidence that these mechanisms work together. Security must always be enforced by underlying kernel, permissions, and cryptographic systems — never by UI alone.
