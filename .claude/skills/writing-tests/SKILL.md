---
name: writing-tests
description: Use when adding or updating tests for this package. Prefer behavior-level coverage, keep tests aligned with the public API, and finish with analyze plus test.
---

# Writing Tests

Use this skill when the task is to add, update, or repair tests.

## Test Rules

- Prefer behavior-level tests over private implementation checks.
- Cover the real risk.
- Keep tests close to the package behavior they protect.
- Avoid test-only seams that worsen the public package design.

## Validation Flow

1. Run focused `fvm flutter test` commands while iterating when useful.
2. Finish with `fvm flutter analyze`.
3. Finish with `fvm flutter test`.

## Read These

- `CLAUDE.md`
- `.claude/policies/publishing.md`
- `.claude/policies/public-repo.md`
