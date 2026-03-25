#!/bin/bash
# SessionStart[compact] hook — restore context after compaction

MEMORY_FILE="__HOME__/.claude/projects/memory/MEMORY.md"
ENFORCE_FILE="__HOME__/.claude/enforce.md"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  GIT_STEP="   e) git log --oneline -10 — recent work context\n   f) Any files you were actively editing before compaction"
else
  GIT_STEP="   e) Any files you were actively editing before compaction"
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

2. IDENTITY REMINDER:
   Owner: (configure in CLAUDE.md)
   Language: (configure in CLAUDE.md)
   Model policy: Opus leads ambiguity/architecture/security; delegate simpler work

3. RESUME WORK:
   After reading all files above, continue the task that was in progress.
   Do NOT ask "what were we doing?" — the files will tell you.
   If the desired behavior is still unclear after re-reading, ask concise product questions before editing.
</post-compaction-recovery>
EOF

# Also output enforce.md content directly for immediate availability
if [ -f "$ENFORCE_FILE" ]; then
  echo "<enforce-reinject>"
  cat "$ENFORCE_FILE"
  echo "</enforce-reinject>"
fi
