#!/bin/bash
# Stop hook — Ralph loop (reliable, no plugin dependency)
# When RALPH_MODE is active, prevents Claude from stopping
# Activate: export CLAUDE_RALPH_MODE=1 before starting claude
# Deactivate: unset CLAUDE_RALPH_MODE or create ~/.claude/state/ralph-stop

STATE_DIR="$HOME/.claude/state"
RALPH_STOP="$STATE_DIR/ralph-stop"
RALPH_COUNTER="$STATE_DIR/ralph-counter"

# Check if ralph mode is active
RALPH_ACTIVE="${CLAUDE_RALPH_MODE:-0}"

# Also check for file-based activation
[ -f "$STATE_DIR/ralph-active" ] && RALPH_ACTIVE=1

# If ralph is not active, exit normally
[ "$RALPH_ACTIVE" = "0" ] && exit 0

# Check for stop signal
if [ -f "$RALPH_STOP" ]; then
  rm -f "$RALPH_STOP" "$RALPH_COUNTER" "$STATE_DIR/ralph-active"
  exit 0
fi

# Increment loop counter
COUNT=0
[ -f "$RALPH_COUNTER" ] && COUNT=$(cat "$RALPH_COUNTER" 2>/dev/null || echo 0)
COUNT=$((COUNT + 1))

# Safety limit: max 50 loops
if [ "$COUNT" -gt 50 ]; then
  rm -f "$RALPH_COUNTER" "$STATE_DIR/ralph-active"
  echo '{"reason": "Ralph loop: max iterations (50) reached. Safety stop."}' >&2
  exit 0
fi

printf '%d' "$COUNT" > "$RALPH_COUNTER"

# Prevent Claude from stopping -- exit code 2 blocks Stop events
echo "Ralph loop iteration ${COUNT}/50. The boulder never stops. Review your work, check for incomplete tasks, run tests, and continue. To stop: touch ~/.claude/state/ralph-stop"

exit 2
