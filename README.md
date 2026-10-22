# shut-up-claude

A Claude Code plugin that stops Claude from adding AI attribution anywhere:
commit messages, `Co-Authored-By` trailers, PR/MR bodies, code comments,
file headers, docs, changelogs, messages, and file metadata.

No more `🤖 Generated with Claude Code`. No more `Co-Authored-By: Claude`.

## Install

Inside Claude Code:

```
/plugin marketplace add Mark14444/shut-up-claude
/plugin install shut-up-claude@shut-up-claude
```

Or from a terminal:

```bash
claude plugin marketplace add Mark14444/shut-up-claude
claude plugin install shut-up-claude@shut-up-claude
```

Restart Claude Code after installing. Update later with
`claude plugin update shut-up-claude@shut-up-claude`.

## How it works

Three layers, so the rule holds even when one of them is skipped:

| Layer | What it does |
|---|---|
| **SessionStart hook** | Loads the rule into every session, so it is always active |
| **PreToolUse hook** | Blocks any shell command, file write/edit, or MCP call (Slack, GitHub, Jira, …) that contains attribution, and tells Claude to retry without it |
| **Skill** | Full rule set, list of forbidden phrases in several languages, and a pre-publish checker |

The rule covers everything, not only GitHub: any git host, any file, any
document, any message sent through any tool.

## Make it permanent

Also disable Claude Code's built-in attribution in `~/.claude/settings.json`:

```json
{
  "attribution": { "commit": "", "pr": "" },
  "includeCoAuthoredBy": false
}
```

## Extras

Checker (from `skills/shut-up-claude/`):

```bash
bash scripts/check-attribution.sh              # staged diff + HEAD message
bash scripts/check-attribution.sh docs/*.md    # files
git log -1 --format=%B | bash scripts/check-attribution.sh -
```

Exit code `0` = clean, `1` = attribution found.

Optional per-repo git hook that strips attribution lines from every commit
message, no matter who writes it:

```bash
cp skills/shut-up-claude/git-hooks/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```
