# Agent Instructions

`skeleton` — a Flutter package scaffold. Source may be published on a public
GitHub repo.

Commands and architecture live in [CLAUDE.md](CLAUDE.md) — read that first.

Policies (read all, they're short):
[.agents/policies/publishing.md](.agents/policies/publishing.md),
[.agents/policies/public-repo.md](.agents/policies/public-repo.md),
[.agents/policies/commit-policy.md](.agents/policies/commit-policy.md),
[.agents/policies/branch-policy.md](.agents/policies/branch-policy.md),
[.agents/policies/pr-policy.md](.agents/policies/pr-policy.md),
[.agents/policies/dependency-policy.md](.agents/policies/dependency-policy.md)

Repo-local skills:

- Shared: [.agents/skills/package-workflow/SKILL.md](.agents/skills/package-workflow/SKILL.md)
- Claude: [.claude/skills/package-workflow/SKILL.md](.claude/skills/package-workflow/SKILL.md)

## Public repo — read before editing

- Treat this repo as public-safe. Never commit secrets, tokens, or personal
  data.
- The package is still at scaffold stage (`0.0.1`). Keep the package entrypoint
  and any documented usage in `README.md` aligned with code changes.
- Do not edit `CHANGELOG.md` or bump `version` in `pubspec.yaml` during normal
  fix, feat, refactor, docs, or test work.
- If you add or change a user-facing API, update `README.md` in the same
  change.
- Keep `PLAN.md` aligned with the intended package shape when major direction
  changes happen.

## Git conventions

- Don't commit or push directly to `main` unless explicitly asked — see
  [.agents/policies/branch-policy.md](.agents/policies/branch-policy.md) for
  branch naming.
- Commit messages follow
  [.agents/policies/commit-policy.md](.agents/policies/commit-policy.md) —
  conventional commits with a required body.
- `ship` means: if the current branch is `main`, create and check out a new
  branch that follows branch policy; otherwise keep the current feature branch.
  Then commit the work, push the branch, and open a PR using the GitHub MCP
  connector without asking for extra confirmation. Do not use `gh` for this
  workflow.
- `land` means: squash-merge the PR using the GitHub MCP connector, switch the
  local checkout back to `main`, pull the merged changes, and delete the local
  branch. Do not use `gh` for this workflow.

## Conventions

- Use Flutter-native solutions first.
- Keep the package small and avoid speculative architecture.
- Prefer adding tests for non-trivial behavior.
