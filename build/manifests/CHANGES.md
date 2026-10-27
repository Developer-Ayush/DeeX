# DeeX Manifest Modification Policy and Changelog

Status: Draft
Date: 2025-05-16
Master Plan Sections: 2.2, 2.4, 16.2

## Manifest Modification Policy Rule

**Mandatory Change Control Rule**:
No repository pin, commit revision, remote URL, or branch definition in `build/manifests/aosp-pinned.xml` or `build/manifests/deex-local-manifest.xml` may be modified silently or without formal documentation.

Every modification to a manifest pin must satisfy all of the following requirements:

1. **Formal Authorization**: A pin update must be authorized by either:
   - An Architectural Decision Record (ADR) in `docs/decisions/` (e.g. AOSP baseline release upgrade), OR
   - A logged Security Update Entry in `docs/build-records/CHANGELOG-chunks.md` or a security tracking issue referencing an upstream CVE / ASB (Android Security Bulletin).
2. **Deterministic Resolution**: The new commit revision (40-character SHA1) must be resolved from primary source git repositories using deterministic commands (such as `git ls-remote`).
3. **Audit Trail**: Every update must be recorded in this `CHANGES.md` file and logged in `build/manifests/pin-log.md` with timestamp, author, justification, and resolving command.
4. **No Floating References**: Floating branch names (`main`, `master`, `android-15.0.0_r1`) are strictly forbidden in production pinned manifests.

## Manifest Modification Log

| Date | Author / Role | Affected File | Project Name | Previous Revision | New Revision | Justification / ADR Reference |
|---|---|---|---|---|---|---|
| 2025-05-16 | Jules (AI Build Engineer) | `aosp-pinned.xml.template` | Initial Baseline | None | `aosp-pinned.xml.template` | Created initial manifest template pending owner release choice in ADR-0003 |
