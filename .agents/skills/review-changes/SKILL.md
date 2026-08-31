---
name: review-changes
description: Use when reviewing code or docs changes in this package. Prioritize regressions, public API compatibility, release-note gaps, and missing validation before handoff.
---

# Review Changes

Use this skill for self-review, requested review, or pre-handoff checking.

## Review Order

1. Regressions in package behavior or tests.
2. Public API changes in `lib/skeleton.dart` or other exported package
   behavior.
3. README or `PLAN.md` drift after public API or behavior changes.
4. Validation gaps or unnecessary dependency additions.
5. Public-repo hygiene issues such as secrets or personal data.

## Output Rules

- Findings first.
- Tie each finding to a file or behavior.
- If no findings remain, say so directly and still mention any real validation
  gap.

## Read These

- `.agents/policies/publishing.md`
- `.agents/policies/public-repo.md`
- `.agents/policies/dependency-policy.md`
