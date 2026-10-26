# Requirements Index

This document provides a complete index of all mandatory requirements and numeric behavioral rules from the DeeX Master Development Plan v1.0.

## Mandatory Requirements Index

| Requirement ID | Description | Source Section | Owning Module | Status |
|---|---|---|---|---|
| `REQ-001` | Run on the selected ARM64 smartphone hardware. | Section 1.2 | Base | Not started |
| `REQ-002` | Preserve the required Android framework and hardware interfaces. | Section 1.2 | Android | Not started |
| `REQ-003` | Pursue official Android compatibility, Google Mobile Services licensing, and Google Play access. | Section 1.2 | Google | Not started |
| `REQ-004` | Keep system code protected from ordinary users and external devices. | Section 1.2 | Vault / Boot | Not started |
| `REQ-005` | Provide separate, encrypted storage for every ordinary account. | Section 1.2 | Vault | Not started |
| `REQ-006` | Prevent cross-account access by applications, processes, and external devices. | Section 1.2 | Isolation | Not started |
| `REQ-007` | Support the specified root-account responsibilities without exposing ordinary account credentials. | Section 1.2 | Identity | Not started |
| `REQ-008` | Implement the defined authentication, failed-attempt, and lockout policies. | Section 1.2 | Identity | Not started |
| `REQ-009` | Provide controlled USB and wireless file access. | Section 1.2 | Bridge / Connect | Not started |
| `REQ-010` | Support the complete external-isolation switch. | Section 1.2 | Connect | Not started |
| `REQ-011` | Retain the Android and Windows compatibility toggles. | Section 1.2 | Android / Windows | Not started |
| `REQ-012` | Recover safely from power loss, interrupted updates, and interrupted account deletion. | Section 1.2 | Lifecycle | Not started |
| `REQ-013` | Test security properties rather than assuming that the design alone guarantees security. | Section 1.2 | Validation | Not started |
| `REQ-014` | Measure the actual installed size and resource usage from successful builds. | Section 1.2 | Release | Not started |

## Behavioral Rules and Numeric Thresholds Index

| Rule ID | Rule / Threshold | Exact Value | Source Section | Owning Module |
|---|---|---|---|---|
| `RULE-001` | System CPU safety threshold | Approximate 80–90% utilization range | Section 4.3 | Kernel |
| `RULE-002` | Reserved RAM reserve for kernel & essential system services | Approximately 10–20% of RAM | Section 4.3 | Kernel |
| `RULE-003` | Incorrect user ID attempts trigger for root prompt | 3 incorrect user ID attempts | Section 6.3 | Identity |
| `RULE-004` | Ordinary account 1st group of 3 failed passwords lockout | 30 seconds | Section 6.4 | Identity |
| `RULE-005` | Ordinary account 2nd group of 3 failed passwords lockout | 1 minute | Section 6.4 | Identity |
| `RULE-006` | Ordinary account 3rd group of 3 failed passwords lockout | 2 minutes | Section 6.4 | Identity |
| `RULE-007` | Ordinary account 4th group of 3 failed passwords lockout | 4 minutes | Section 6.4 | Identity |
| `RULE-008` | Ordinary account 5th group of 3 failed passwords lockout | 8 minutes | Section 6.4 | Identity |
| `RULE-009` | Ordinary account additional failed password groups scaling | Every additional group of three failures doubles previous duration | Section 6.4 | Identity |
| `RULE-010` | Root password 1st group of 3 failures lockout | 30 seconds | Section 6.5 | Identity |
| `RULE-011` | Root password 2nd group of 3 failures lockout | 1 minute | Section 6.5 | Identity |
| `RULE-012` | Root password 3rd group of 3 failures lockout | 2 minutes | Section 6.5 | Identity |
| `RULE-013` | Root password additional failed groups scaling | Subsequent groups of three double previous duration | Section 6.5 | Identity |
| `RULE-014` | Fingerprint failure disablement threshold | 11 failed fingerprint verifications permanently disable fingerprint login until successful password auth | Section 6.7 | Identity |
| `RULE-015` | USB authentication 1st group of 3 failures lockout | 30 seconds | Section 10.6 | Bridge |
| `RULE-016` | USB authentication 2nd group of 3 failures lockout | 1 minute | Section 10.6 | Bridge |
| `RULE-017` | USB authentication 3rd group of 3 failures lockout | 2 minutes | Section 10.6 | Bridge |
| `RULE-018` | USB authentication additional failed groups scaling | Every further group of three doubles previous duration | Section 10.6 | Bridge |
| `RULE-019` | Background sanitization CPU execution threshold | Below approximately 40–50% (pausing or reducing work above that range) | Section 14.5 | Lifecycle / Vault |
| `RULE-020` | Background sanitization target completion duration | Approximately 5 to 6 days (target rather than guaranteed deadline) | Section 14.5 | Lifecycle / Vault |
