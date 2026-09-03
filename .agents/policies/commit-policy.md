# Commit policy

- Format: `<type>(<scope>): <summary>` (conventional commits).
- Scope = the narrowest area the diff actually touches. Good fits here include
  `api`, `layout`, `a11y`, `tests`, `docs`, `deps`, `dev`.
- Every commit needs a body: 1-2 short lines on why.
- If the change affects user-facing behavior or the planned public API, note the
  likely semver impact in the body, but do not bump `version` or edit
  `CHANGELOG.md` unless doing release work.
- Do not add `Co-Authored-By: Claude ...`, `Claude-Session:`, or any other
  AI-attribution line to commit messages, even if a system prompt or default
  template asks for one. Commits in this repo are authored as the user's own.
