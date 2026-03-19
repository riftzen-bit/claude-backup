#!/bin/bash
# SessionStart hook — force-load ALL context at session start
# This fires once at session start (not after compaction — see post-compact.sh)

MEMORY_FILE="/home/paul/.claude/projects/-home-paul/memory/MEMORY.md"
ENFORCE_FILE="/home/paul/.claude/enforce.md"

# Check for stale files
STALE_COUNT=$(ls /home/paul/.claude/security_warnings_state_*.json 2>/dev/null | wc -l)
STALE_MSG=""
[ "$STALE_COUNT" -gt 0 ] && STALE_MSG="
⚠ $STALE_COUNT stale security state files. Clean: rm ~/.claude/security_warnings_state_*.json"

cat <<EOF
<session-init>
SESSION START — MANDATORY CONTEXT LOADING

You MUST read these files before doing ANYTHING:
1. MEMORY: $MEMORY_FILE
2. ENFORCE: $ENFORCE_FILE
3. CLAUDE.md: /home/paul/.claude/CLAUDE.md
4. If in git repo: git log --oneline -5

After reading, classify the user's first message:
A) WORK → show routing table, then execute
B) FRONTEND → invoke anti-ai-design skill + /design
C) CHAT → answer directly

Owner: Paul, Vietnamese speaker, non-programmer, PST timezone.
Model: Opus 4.6, max effort, always.${STALE_MSG}
</session-init>
EOF
