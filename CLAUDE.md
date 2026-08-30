@AGENTS.md

# CLAUDE.md

This file provides guidance to coding agents working in this repository.

Process and policy conventions live in [AGENTS.md](AGENTS.md) — read that too.

Repo-local skills live here:

- Shared: `.agents/skills/package-workflow/SKILL.md`
- Claude: `.claude/skills/package-workflow/SKILL.md`

## Commands

```sh
flutter pub get
flutter analyze
flutter test
dart format .
```

Run checks yourself before considering a change done.

Do not edit `CHANGELOG.md` or bump `version` in `pubspec.yaml` during normal
development work.

## Architecture

Read [PLAN.md](PLAN.md) before implementing package features. It is the project
brief and defines the intended direction.

Current codebase shape:

- `lib/skeleton.dart` is the whole public entrypoint today.
- `test/skeleton_test.dart` is a scaffold smoke test.
- `README.md` is still the default scaffold README and should be tightened up
  when the package direction becomes real.

Keep the first real version simple:

- Start with normal widgets and state, not a custom render object.
- Keep helpers private until consumers clearly need them exported.
- Add tests for non-trivial behavior.
