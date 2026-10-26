# DeeX Threat Model Framework

## Scope

This document provides the structural framework for analyzing security threats against the DeeX mobile operating system.

## Protected Assets

- **Account Data**: User files, media, databases, and application data private to each account.
- **Keys and Master Secrets**: Storage encryption key hierarchies, key-wrapping keys, and biometric templates.
- **Credential Records**: Salted password verifier hashes and authentication state.
- **System Partitions**: Boot, system, vendor, and recovery images protected by Android Verified Boot.
- **Telephony & Network State**: Shared SIM message history, call records, and active radio links.

## Threat Actors

- **Ordinary Accounts**: Standard non-root users operating on the physical device.
- **Malicious Apps inside an Account**: Untrusted third-party Android or Windows applications running within an account sandbox.
- **Connected Computer over USB**: External host connected via USB attempting file or ADB access.
- **Nearby Wireless Peer**: Bluetooth, Wi-Fi, or radio peers attempting unauthenticated data exchange.
- **Attacker with Physical Possession**: Adversary with lost or stolen hardware attempting offline chip extraction, cold boot attacks, or brute-force login.
- **Malicious Update**: Untrusted or tampered firmware update package.

## Threat Matrix Template

| Threat ID | Threat Description | Affected Asset | Actor | Mitigation Strategy | Verification Method | Status |
|---|---|---|---|---|---|---|
| *TBD* | *Future threat analysis* | *TBD* | *TBD* | *TBD* | *TBD* | Open |
