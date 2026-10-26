# Instructions for AI Coding Agents

As an AI coding agent working on the DeeX codebase, you must follow these directives strictly:

1. **Read the Master Plan First**: Always read `docs/specifications/DeeX-Master-Plan-v1.0.md` before performing work. It is the single source of truth for the project.
2. **Work One Chunk at a Time**: Complete only the single assigned chunk. Do not start work on future modules or speculative features outside the assigned scope.
3. **Never Invent Facts**: Do not guess hardware models, SoCs, AOSP releases, kernel versions, commit hashes, or vendor details. If a fact is unknown, mark it as `UNKNOWN — decision required` and list it in `docs/decisions/open-decisions.md`.
4. **No Mock Security Code**: Do not introduce mock encryption, fake key derivation, or placeholder authentication in production code paths. Test-only code must reside strictly under `tests/` and be clearly labelled.
5. **Never Log or Print Secrets**: Ensure that passwords, encryption keys, tokens, biometric templates, or credential verifiers are never output to logs, console, or build artifacts.
6. **Record Completed Chunks**: Record every completed chunk in `docs/build-records/CHANGELOG-chunks.md` with status and verification output.
7. **Stop and Report Conflicts**: If prompt instructions, codebase state, or master plan specifications conflict, stop immediately and report the conflict without guessing or resolving it silently.
