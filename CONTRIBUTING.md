# Contributing

Thanks for considering a contribution to `skeleton`.

## Setup

```sh
flutter pub get
```

## Before opening a PR

```sh
flutter analyze
flutter test
dart format .
```

All three must pass cleanly.

## Guidelines

- Read [AGENTS.md](AGENTS.md) for repo conventions (branching, commits, PRs,
  dependencies) — they apply to human contributors too.
- Read [PLAN.md](PLAN.md) before adding features; it's the project brief.
- Keep dependencies minimal — prefer Flutter/Dart built-ins over new
  packages.
- Add tests for non-trivial behavior.
- Don't edit `CHANGELOG.md` or bump `version` in `pubspec.yaml` — releases
  are handled by `release-please`.

## Commits & branches

- Branches: `<type>/<short-kebab-description>` (e.g. `fix/handle-focus`).
- Commits: conventional commits (`<type>(<scope>): <summary>`) with a short
  body explaining why.

## Reporting bugs / requesting features

Use the issue templates when opening an issue.
