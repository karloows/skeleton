---
name: flutter-validation
description: Use when validating code changes in this package. Run the smallest honest checks while iterating, then finish with flutter analyze and flutter test before handoff.
---

# Flutter Validation

Use this skill when package or test code changed.

## Validation Flow

1. Use the smallest check that proves the edited area while iterating.
2. Finish with `fvm flutter analyze`.
3. Finish with `fvm flutter test`.
4. If public API or documented behavior changed, review `README.md`,
   `CHANGELOG.md`, and `PLAN.md` for consistency.
5. Report exactly what ran and what did not.

## Read These

- `CLAUDE.md`
- `.claude/policies/publishing.md`
- `.claude/policies/public-repo.md`
