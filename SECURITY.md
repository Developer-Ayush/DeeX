# Security Policy

## Reporting Vulnerabilities

To report a security vulnerability, please contact: `UNKNOWN — decision required`.

## Security Rules and Hygiene

- **No Secrets in Repository**: Signing keys, private credentials, API tokens, keystores, and certificates must NEVER be committed to the repository. Repository ignore rules (`.gitignore`) enforce key exclusion.
- **No Mock Security**: Production code paths must never contain placeholder or mock security code.

## Claims Boundary

Per Section 17.7 of the DeeX Master Development Plan v1.0, DeeX makes no claims of being "certified", "cryptographically secure", "tamper-proof", or "fully isolated" until concrete implementation and reproducible test evidence exist.
