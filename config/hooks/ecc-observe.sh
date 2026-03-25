#!/bin/bash
# Optional ECC continuous-learning observation wrapper.
# Disabled by default: requires explicit opt-in and a pinned observer path.

[ "$CLAUDE_ENABLE_ECC_OBSERVE" = "1" ] || exit 0

OBSERVE_SCRIPT="$CLAUDE_ECC_OBSERVER"
CANONICAL_SCRIPT=$(realpath -e "$OBSERVE_SCRIPT" 2>/dev/null) || exit 0

case "$CANONICAL_SCRIPT" in
  __HOME__/.claude/plugins/cache/everything-claude-code/everything-claude-code/*/skills/continuous-learning-v2/hooks/observe.sh)
    ;;
  *)
    exit 0
    ;;
esac

[ "$CANONICAL_SCRIPT" = "$OBSERVE_SCRIPT" ] || exit 0
[ -f "$CANONICAL_SCRIPT" ] || exit 0
[ -x "$CANONICAL_SCRIPT" ] || exit 0

"$CANONICAL_SCRIPT" "$@" 2>/dev/null || true
exit 0
