#!/bin/bash
# SessionStart: auto-load context for every new session

# Check for stale security/temp files
STALE_COUNT=$(ls ~/.claude/security_warnings_state_*.json 2>/dev/null | wc -l)
STALE_MSG=""
[ "$STALE_COUNT" -gt 0 ] && STALE_MSG="
WARNING: $STALE_COUNT stale security state files found. Clean with: rm ~/.claude/security_warnings_state_*.json"

cat <<EOF
<session-start-hook>
Session initialized. Auto-load context:
1. Read ~/.claude/projects/-home-paul/memory/MEMORY.md for user profile and project state
2. Check git log --oneline -5 if in a git repo for recent context
3. Classify the user's first message and route accordingly${STALE_MSG}
</session-start-hook>
EOF
