# shut-up-claude

A Claude Code skill that stops Claude from adding AI attribution anywhere:
commit messages, `Co-Authored-By` trailers, PR/MR bodies, code comments,
file headers, docs, changelogs, messages, and file metadata.

No more `🤖 Generated with Claude Code`. No more `Co-Authored-By: Claude`.

## Install

```bash
git clone https://github.com/Mark14444/shut-up-claude ~/.claude/skills/shut-up-claude
```

Windows (PowerShell):

```powershell
git clone https://github.com/Mark14444/shut-up-claude "$env:USERPROFILE\.claude\skills\shut-up-claude"
```

Restart Claude Code. The skill loads automatically whenever Claude is about to
write a commit, PR, doc, or any other artifact.

## Make it permanent

Also disable Claude Code's built-in attribution in `~/.claude/settings.json`:

```json
{
  "attribution": { "commit": "", "pr": "" },
  "includeCoAuthoredBy": false
}
```

## What's inside

| Path | Purpose |
|---|---|
| `SKILL.md` | The rules Claude follows: what never to write and the pre-publish check |
| `scripts/check-attribution.sh` | Scans staged changes, the last commit message, files, or stdin for attribution |
| `hooks/commit-msg` | Optional git hook that strips attribution lines from every commit message |

### Checker

```bash
bash scripts/check-attribution.sh              # staged diff + HEAD message
bash scripts/check-attribution.sh docs/*.md    # files
git log -1 --format=%B | bash scripts/check-attribution.sh -
```

Exit code `0` = clean, `1` = attribution found.

### Git hook (per repo)

```bash
cp ~/.claude/skills/shut-up-claude/hooks/commit-msg .git/hooks/commit-msg
chmod +x .git/hooks/commit-msg
```
