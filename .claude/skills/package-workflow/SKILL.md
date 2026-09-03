---
name: package-workflow
description: Repo-local workflow guidance for building `skeleton`.
---

# Package Workflow

Use this skill when working on the `skeleton` package.

## Read first

1. `AGENTS.md`
2. `CLAUDE.md`
3. `PLAN.md`

## What this repo is

- A public Flutter package scaffold.
- Current version is `0.0.1`.
- The current API is still sample code.

## Build rules

- Keep v1 small.
- Prefer Flutter-native solutions before custom infrastructure.
- Avoid new dependencies unless Flutter cannot reasonably cover the need.
- Add or update tests for non-trivial behavior.

## Checks

Run:

```sh
fvm flutter analyze
fvm flutter test
```
