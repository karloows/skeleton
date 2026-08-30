---
name: bug-fixing
description: Use when fixing a bug, regression, or incorrect behavior in this Flutter package. Trace the public export and affected path before editing, keep the fix small, and validate with analyze plus tests.
---

# Bug Fixing

Use this skill for broken behavior, exported API regressions, or test failures.

## Workflow

1. Read `CLAUDE.md`, `AGENTS.md`, and the relevant policy files first.
2. Trace the flow through `lib/skeleton.dart`, `PLAN.md`, and the affected
   implementation before choosing an edit point.
3. Fix the narrowest shared root cause that matches the report.
4. Add or update tests when the change touches non-trivial behavior.
5. Run `flutter analyze` and `flutter test` before handoff.

## Bias

- Prefer one fix in shared logic over patching symptoms in multiple places.
- Preserve the smallest usable public API unless the task explicitly requires
  widening it.

## Read These

- `CLAUDE.md`
- `.agents/policies/publishing.md`
- `.agents/policies/public-repo.md`
- `.agents/policies/dependency-policy.md`
