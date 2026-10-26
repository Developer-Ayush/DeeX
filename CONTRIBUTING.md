# Contributing to DeeX

Thank you for contributing to DeeX. To maintain system integrity and compliance with the DeeX Master Plan, all contributions must adhere to the rules below.

## One Chunk Per Change Rule

- All work is executed in small, incremental chunks as defined in the master plan.
- Submissions must address only the assigned chunk scope. Unrelated refactoring or speculative features will be rejected.

## Branching and Commit Conventions

- Create descriptive branch names corresponding to the module or chunk (e.g., `chunk-1-repo-foundation`).
- Commits must be small, logical, and focused on a single change.
- Write concise, descriptive commit messages.

## Code Review Expectations

- All code changes require technical review before merging.
- Changes must pass all automated structural and test checks (`tools/check-repo-structure.sh` and test suites in `tests/`).

## Master Plan Modifications

- The specification in `docs/specifications/DeeX-Master-Plan-v1.0.md` is the project baseline.
- Proposed modifications to the master plan must be submitted via an Architecture Decision Record (ADR) in `docs/decisions/` and approved by project leadership. Silent edits to the master plan are strictly prohibited.
