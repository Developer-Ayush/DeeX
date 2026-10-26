# DeeX Build Configurations

This document defines the three supported build variants for the DeeX operating system.

## Build Variants

### 1. Development Configuration (`userdebug` / `eng` equivalent)
- **Purpose**: Internal development, module debugging, and initial bring-up.
- **Privileges**: Debugging interfaces, verbosely logged system traces, and test instrumentation enabled.
- **Restriction**: Must NEVER be distributed as production or release images.

### 2. Testing Configuration
- **Purpose**: Automated security testing, CTS testing, and isolation verification.
- **Privileges**: Restricted test harnesses enabled under controlled lab environments.
- **Restriction**: Non-production only.

### 3. Release Configuration (`user` equivalent)
- **Purpose**: Production release images for end users.
- **Privileges**: Production-hardened only.
- **Rule (Master Plan Section 2.4)**: Production images must not contain development-only debugging privileges. No security-critical module may be replaced with a mock implementation.

## Build Flags and Variables

All build flags, compilation switches, and device target definitions remain `UNKNOWN — decision required` until the AOSP release and target device model are selected.
