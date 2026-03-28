#!/bin/bash
# SessionStart[compact] hook — restore context after compaction
# Adapted from OmO's Compaction Context Injector (8-section structured recovery)

# Build memory path dynamically from current working directory
_sanitized_cwd=$(pwd | sed 's|/|-|g; s|^-||')
MEMORY_FILE="__HOME__/.claude/projects/${_sanitized_cwd}/memory/MEMORY.md"
[ ! -f "$MEMORY_FILE" ] && MEMORY_FILE="$(find __HOME__/.claude/projects/ -name MEMORY.md -type f 2>/dev/null | head -1)"
ENFORCE_FILE="__HOME__/.claude/enforce.md"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_STEP="   e) git log --oneline -10 — recent work context\n   f) Any files you were actively editing before compaction"
else
  GIT_STEP="   e) Any files you were actively editing before compaction"
fi

# Check for active notepads
NOTEPAD_MSG=""
if [ -d ".claude/notepads" ] && [ "$(ls -A .claude/notepads 2>/dev/null)" ]; then
  NOTEPAD_MSG="   g) Active notepads: .claude/notepads/ — read learnings before resuming work"
fi

cat <<EOF
<post-compaction-recovery>
COMPACTION DETECTED — FULL CONTEXT RE-INJECTION

Your context was just compacted. You MUST re-orient NOW:

1. READ IMMEDIATELY (in this order):
   a) $MEMORY_FILE — user profile, feedback history, project state
   b) $ENFORCE_FILE — mandatory rules for every message
   c) __HOME__/.claude/CLAUDE.md — global config hub
   d) __HOME__/.claude/rules/common/ and __HOME__/.claude/rules/typescript/
$GIT_STEP
${NOTEPAD_MSG}

2. IDENTITY REMINDER:
   Re-read CLAUDE.md for owner identity, language, and model policy.
   Model policy: Opus leads ambiguity/architecture/security; delegate simpler work

3. RESUME WORK — use this checklist to reconstruct context:
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
