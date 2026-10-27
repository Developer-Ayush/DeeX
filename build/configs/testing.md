# DeeX Build Configuration: Testing

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 4.2, 13.2, 15, 17.2

## 1. Purpose

The Testing configuration is designed for automated security testing, continuous integration (CI) test execution, Compatibility Test Suite (CTS) verification, Android Compatibility Definition Document (CDD) compliance runs, and per-account isolation fuzzing.

## 2. AOSP Build Variant & Target

- **AOSP Build Variant**: `userdebug`
  - Citation: `https://source.android.com/docs/setup/build/building#choose-a-target` (Access Date: 2025-05-16, Confidence: `VERIFIED`).
- **Target `lunch` Specifier**: `UNKNOWN — decision required` (Pending owner confirmation of AOSP release in `ADR-0003`; target template `aosp_shiba-userdebug`).

## 3. Allowed Debugging Facilities

- ADB root daemon access enabled (`adb root`) strictly for automated test runner control over USB/TCP.
- System property `ro.debuggable=1` enabled.
- SELinux Enforcing mode REQUIRED (`setenforce 1`) to accurately validate DeeX account isolation, SELinux domain transition rules, and MAC policies.
- Instrumentation and CTS test harness support enabled.
- User-facing debugging menus disabled.

## 4. Cryptographic Key Identifiers

- **Key Tier**: Dedicated Testing Keys (`deex-test-key-01`).
- Test keys are maintained in restricted test environment keystores.
- **Restriction**: Test keys must NEVER be accepted by production bootloaders or release system builds.

## 5. Custom DeeX Module Stubbing Policy

- DeeX system services (Vault, Identity, Isolation, Bridge, Connect) must be compiled from complete source.
- Stubs are permitted ONLY for external third-party cloud/GMS mock interfaces when executing offline unit tests.
- Core account isolation and cryptographic storage services must NEVER be stubbed during security test runs.

## 6. Logging and Secret Policy

- Test logs must collect pass/fail assertion results and code coverage metrics.
- Automated secret scanning tools must sanitize `logcat` and test report outputs.
- **Strict Prohibition (Master Plan 4.2, 17.2)**: Credentials, passwords, master keys, and biometric hashes must NEVER be written to test artifacts or test logs.

## 7. Required Build Evidence for Success

Before a build in the Testing configuration is recorded as successful:
1. Ninja build finishes with zero errors.
2. System image artifacts pass automated structure check script (`tools/check-repo-structure.sh`).
3. Automated test suite (unit tests, isolation tests, CTS baseline runner) executes and produces an uncorrupted XML test output report.
4. Image SHA256 hashes recorded in build record template.
