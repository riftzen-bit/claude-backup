#!/bin/bash
# SessionStart[compact] hook — restore context after compaction

ENFORCE_FILE="__HOME__/.claude/enforce.md"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_STEP="   d) git log --oneline -10 — recent work context\n   e) Any files you were actively editing before compaction"
else
  GIT_STEP="   d) Any files you were actively editing before compaction"
fi

# Check for active notepads
NOTEPAD_MSG=""
if [ -d ".claude/notepads" ] && [ "$(ls -A .claude/notepads 2>/dev/null)" ]; then
  NOTEPAD_MSG="   f) Active notepads: .claude/notepads/ — read learnings before resuming work"
fi

cat <<EOF
<post-compaction-recovery>
COMPACTION DETECTED — FULL CONTEXT RE-INJECTION

Your context was just compacted. You MUST re-orient NOW:

1. READ IMMEDIATELY (in this order):
   a) $ENFORCE_FILE — mandatory rules for every message
   b) __HOME__/.claude/CLAUDE.md — global config hub
   c) __HOME__/.claude/rules/common/ and __HOME__/.claude/rules/typescript/
$GIT_STEP
${NOTEPAD_MSG}

2. RESUME WORK — use this checklist to reconstruct context:
   a) What were all the user's original requests? (check conversation summary)
   b) What is the final goal?
   c) What work has been completed? (check git diff, modified files)
   d) What tasks remain? (check task list, plan files)
   e) What files were being actively edited?
   f) What constraints were explicitly stated? (quote verbatim, do not paraphrase)
   g) Were any subagents delegated? If yes, use their session_id to CONTINUE, not restart
   h) What was verified vs still pending verification?

   Do NOT ask "what were we doing?" — reconstruct from files and conversation summary.
   If still unclear after re-reading, ask concise product questions before editing.
   RESUME work, do NOT RESTART work that was already completed.
</post-compaction-recovery>
EOF

# Also output enforce.md content directly for immediate availability
if [ -f "$ENFORCE_FILE" ]; then
  echo "<enforce-reinject>"
  cat "$ENFORCE_FILE"
  echo "</enforce-reinject>"
fi
