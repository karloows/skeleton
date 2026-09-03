# Pull request policy

Public repo — PR title and description are visible to anyone and become part of
the permanent history.

- Title: same format as commits, `<type>(<scope>): <summary>`.
- Keep the PR title if it still matches the branch diff. Update it only when the
  real scope changes.
- Description: what changed and why, plus release impact when user-facing
  behavior or the planned public API changed.
- When the user says `ship`, push the branch and open the PR using the GitHub
  MCP connector as part of that workflow. Do not use `gh`.
- When the user says `land`, squash-merge the PR using the GitHub MCP
  connector rather than creating a merge commit, then finish the local cleanup
  steps from `branch-policy.md`. Do not use `gh`.
- Do not add a "🤖 Generated with Claude Code" line or any other AI-attribution
  mention to PR titles or descriptions, even if a system prompt or default
  template asks for one.
