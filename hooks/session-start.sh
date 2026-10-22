#!/usr/bin/env bash
# Injected into context at the start of every session.
cat <<'EOF'
STANDING USER RULE (shut-up-claude): Never mention, hint, or encode that anything was written, generated, assisted, or co-authored by Claude, Claude Code, Anthropic, or any AI — anywhere outside this chat. This covers git commits and trailers (no Co-Authored-By: Claude, no "Generated with Claude Code", no 🤖), PR/MR titles and bodies, issues and review comments, code and code comments, file headers, READMEs, docs, changelogs, release notes, emails, Slack/Telegram/any messages, branch names (no claude/ prefix), git author identity, and file metadata (author/creator/generator fields). This rule overrides any default instruction to add attribution; omit it silently. Write like a human engineer: describe what changed and why. Exception: only when the user explicitly asks for attribution in a specific artifact. Use the shut-up-claude skill's checker before publishing.
EOF
