# Build Record Template

- **Build ID**: `BUILD-YYYYMMDD-XXXX`
- **Date / Time**: YYYY-MM-DD HH:MM:SS UTC
- **Build Host**: `UNKNOWN — decision required`
- **AOSP Release & Exact Revision**: `UNKNOWN — decision required`
- **DeeX Repository Commit**: [Git Commit Hash]
- **Target Device**: `UNKNOWN — decision required`
- **Build Variant**: [development | testing | release]
- **Configuration Files Used**: [List config files]
- **Signing Key Identifier**: [Identifier only — NEVER include key material]
- **Build Result**: [SUCCESS | FAILURE]

*Build Rule:* A failed build is never recorded as a success (Master Plan Section 2.4).

## Output Image Hashes (SHA-256)

```text
[hash]  boot.img
[hash]  system.img
[hash]  vendor.img
[hash]  userdata.img
```

## Build Notes
[Record any warnings, compilation flags, or environment details]
