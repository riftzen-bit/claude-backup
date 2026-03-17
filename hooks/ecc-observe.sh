#!/bin/bash
# Version-agnostic wrapper for ECC continuous-learning observation
# Resolves latest installed ECC version automatically
ECC_DIR=$(ls -td /home/paul/.claude/plugins/cache/everything-claude-code/everything-claude-code/*/ 2>/dev/null | head -1)
[ -n "$ECC_DIR" ] && "$ECC_DIR/skills/continuous-learning-v2/hooks/observe.sh" "$@" 2>/dev/null
exit 0
