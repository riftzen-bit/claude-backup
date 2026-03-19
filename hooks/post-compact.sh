#!/bin/bash
# SessionStart[compact] hook — fires AFTER compaction to re-inject all context
# This is critical because compaction loses conversation-only instructions

MEMORY_FILE="/home/paul/.claude/projects/-home-paul/memory/MEMORY.md"
ENFORCE_FILE="/home/paul/.claude/enforce.md"

cat <<EOF
<post-compaction-recovery>
COMPACTION DETECTED — FULL CONTEXT RE-INJECTION

Your context was just compacted. You MUST re-orient NOW:

1. READ IMMEDIATELY (in this order):
   a) $ENFORCE_FILE — mandatory rules for every message
   b) $MEMORY_FILE — user profile, feedback history, project state
   c) /home/paul/.claude/CLAUDE.md — global config hub
   d) git log --oneline -10 — recent work context
   e) Any files you were actively editing before compaction

2. IDENTITY REMINDER:
   Owner: Paul, Vietnamese speaker, non-programmer, PST timezone
   Language: Vietnamese (conversation), English (code)
   Model: Opus 4.6 = leader, delegate simple tasks

3. RESUME WORK:
   After reading all files above, continue the task that was in progress.
   Do NOT ask "what were we doing?" — the files will tell you.

Start next response with [ENFORCED] [POST-COMPACT] to confirm re-injection.
</post-compaction-recovery>
EOF

# Also output enforce.md content directly for immediate availability
if [ -f "$ENFORCE_FILE" ]; then
  echo "<enforce-reinject>"
  cat "$ENFORCE_FILE"
  echo "</enforce-reinject>"
fi
