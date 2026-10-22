#!/usr/bin/env bash
# Scan text for AI attribution. Exit 0 = clean, 1 = found, 2 = usage error.
#   check-attribution.sh            -> staged diff (added lines) + HEAD commit message
#   check-attribution.sh FILE...    -> given files
#   check-attribution.sh -          -> stdin
set -u

PATTERN='co-authored-by:.*(claude|anthropic|openai|gpt|copilot|gemini|\bai\b)|(assisted|helped|signed-off|reviewed)-by:.*(claude|anthropic|\bai\b)|generated (with|by|using) .*(claude|anthropic|\bai\b|llm|gpt)|(created|made|written|built) (with|by|using) .*(claude|anthropic|an ai|\bai\b)|claude[ -]code|claude\.com|noreply@anthropic\.com|anthropic|\b(ai|llm|gpt)[- ](generated|written|assisted)|as an ai\b|🤖|(З|з)генерован|(С|с)генерирован|wygenerowan|(С|с)творено (за допомогою |з допомогою )?((Ш|ш)(І|і)|(И|и)(И|и)|ai|claude)|(Н|н)аписано (Ш|ш)(І|і)'

found=0
scan() { # $1 = label, stdin = text
  local hits
  hits=$(grep -n -i -E "$PATTERN" || true)
  if [ -n "$hits" ]; then
    found=1
    printf '%s\n' "--- $1" "$hits"
  fi
}

if [ $# -eq 0 ]; then
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "not a git repo; pass files or '-'" >&2; exit 2; }
  git diff --cached --unified=0 | grep -E '^\+[^+]' | sed 's/^+//' | scan "staged changes"
  git log -1 --format=%B 2>/dev/null | scan "HEAD commit message"
elif [ "$1" = "-" ]; then
  scan "stdin"
else
  for f in "$@"; do
    [ -f "$f" ] || { echo "skip (not a file): $f" >&2; continue; }
    scan "$f" < "$f"
  done
fi

if [ $found -eq 1 ]; then
  echo "AI attribution found — remove it." >&2
  exit 1
fi
echo "clean"
