#!/bin/bash
# Validate a Claude skill folder structure and SKILL.md content
# Usage: validate-skill.sh <skill-folder-path>

set -uo pipefail

SKILL_DIR="${1:-.}"
ERRORS=0
WARNINGS=0

err() { echo "  ERROR: $1"; ERRORS=$((ERRORS + 1)); }
warn() { echo "  WARN:  $1"; WARNINGS=$((WARNINGS + 1)); }
ok() { echo "  OK:    $1"; }

echo "=== Skill Validation: $(basename "$SKILL_DIR") ==="
echo ""

# 1. Folder naming
FOLDER_NAME=$(basename "$SKILL_DIR")
if [[ "$FOLDER_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  ok "Folder name is kebab-case: $FOLDER_NAME"
else
  err "Folder name must be kebab-case: $FOLDER_NAME"
fi

# 2. SKILL.md exists (exact case)
if [ -f "$SKILL_DIR/SKILL.md" ]; then
  ok "SKILL.md exists"
else
  err "SKILL.md not found (must be exact case)"
  echo ""
  echo "=== RESULT: $ERRORS error(s), $WARNINGS warning(s) ==="
  exit 1
fi

SKILL_FILE="$SKILL_DIR/SKILL.md"

# 3. Frontmatter delimiters
FIRST_LINE=$(head -1 "$SKILL_FILE")
if [ "$FIRST_LINE" = "---" ]; then
  ok "Frontmatter opening delimiter found"
else
  err "Missing opening --- delimiter"
fi

CLOSING=$(awk 'NR>1 && /^---$/{print NR; exit}' "$SKILL_FILE")
if [ -n "$CLOSING" ]; then
  ok "Frontmatter closing delimiter at line $CLOSING"
else
  err "Missing closing --- delimiter"
fi

# 4. Name field
NAME=$(sed -n '2,/^---$/p' "$SKILL_FILE" | grep -E '^name:' | head -1 | sed 's/name: *//')
if [ -n "$NAME" ]; then
  if [[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    ok "name field is kebab-case: $NAME"
    if [ "$NAME" != "$FOLDER_NAME" ]; then
      warn "name ($NAME) doesn't match folder ($FOLDER_NAME)"
    fi
  else
    err "name must be kebab-case: $NAME"
  fi
else
  err "Missing name field in frontmatter"
fi

# 5. Description field
DESC=$(sed -n '2,/^---$/p' "$SKILL_FILE" | grep -E '^description:' | head -1 | sed 's/description: *//')
if [ -n "$DESC" ]; then
  DESC_LEN=${#DESC}
  if [ "$DESC_LEN" -le 1024 ]; then
    ok "description present ($DESC_LEN chars)"
  else
    err "description exceeds 1024 chars ($DESC_LEN)"
  fi
else
  err "Missing description field in frontmatter"
fi

# 6. No XML in frontmatter
FRONTMATTER=$(sed -n '2,/^---$/p' "$SKILL_FILE")
if echo "$FRONTMATTER" | grep -q '[<>]'; then
  err "XML angle brackets found in frontmatter (security restriction)"
else
  ok "No XML in frontmatter"
fi

# 7. No README.md
if [ -f "$SKILL_DIR/README.md" ]; then
  warn "README.md found inside skill folder (docs should go in SKILL.md or references/)"
else
  ok "No README.md inside skill folder"
fi

# 8. Word count
WORD_COUNT=$(wc -w < "$SKILL_FILE")
if [ "$WORD_COUNT" -le 5000 ]; then
  ok "SKILL.md word count: $WORD_COUNT (under 5000)"
else
  warn "SKILL.md is $WORD_COUNT words (recommended: under 5000)"
fi

# 9. Reserved names
if echo "$NAME" | grep -qiE '(claude|anthropic)'; then
  err "Name contains reserved word (claude/anthropic)"
else
  ok "No reserved words in name"
fi

echo ""
echo "=== RESULT: $ERRORS error(s), $WARNINGS warning(s) ==="
[ "$ERRORS" -eq 0 ] && echo "PASS" || echo "FAIL"
exit "$ERRORS"
