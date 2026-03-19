#!/bin/bash
# UserPromptSubmit hook — HARD injection of enforce.md into EVERY message
# This is the primary enforcement mechanism. Cannot be skipped.

# Skip when running from TeleClaude
[ "$TELECLAUDE" = "1" ] && exit 0

ENFORCE_FILE="/home/paul/.claude/enforce.md"

# Read enforce.md and wrap in XML enforcement tags
if [ -f "$ENFORCE_FILE" ]; then
  echo "<mandatory-enforcement>"
  cat "$ENFORCE_FILE"
  echo ""
  echo "ACKNOWLEDGE: You MUST follow ALL rules above before responding."
  echo "Start response with [ENFORCED] to confirm injection received."
  echo "</mandatory-enforcement>"
else
  # Fallback if enforce.md missing — inline critical rules
  cat <<'EOF'
<mandatory-enforcement>
CRITICAL: enforce.md missing. Minimal enforcement active:
1. Read files BEFORE editing — never edit blind
2. Vietnamese conversation, English code
3. Never claim done without verification
4. Never add AI attribution
5. Never fabricate — search when unsure
6. TDD: RED → GREEN → REFACTOR
Start response with [ENFORCED] to confirm.
</mandatory-enforcement>
EOF
fi
