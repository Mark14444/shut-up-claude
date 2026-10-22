#!/usr/bin/env bash
# PreToolUse guard: blocks tool calls (commands, file writes, MCP posts) that carry AI attribution.
# Exit 2 = block; stderr is shown to Claude so it can retry without the attribution.
input="$(cat)"

# Do not block edits to this plugin itself (its files list the patterns on purpose).
case "$input" in *shut-up-claude*) exit 0 ;; esac

PATTERN='co-authored-by:[^"\\]*(claude|anthropic)|(assisted|helped|signed-off|reviewed)-by:[^"\\]*(claude|anthropic)|generated (with|by|using) \[?claude|(created|made|written) (with|by|using) \[?claude|noreply@anthropic\.com|claude\.com/claude-code|claude\.ai/code|🤖|\\ud83e\\udd16'

hit="$(printf '%s' "$input" | grep -o -i -E "$PATTERN" | head -1)"
if [ -n "$hit" ]; then
  echo "Blocked by shut-up-claude: AI attribution found ('$hit'). Remove every Claude/AI attribution line or mention and retry." >&2
  exit 2
fi
exit 0
