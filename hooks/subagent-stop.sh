#!/bin/bash
# SubagentStop hook: log subagent completions for routing stats
# Writes to session-specific log for /routing-stats command

INPUT_JSON=$(cat)

# Extract agent info using pure bash pattern matching
# Get model
MODEL=""
[[ "$INPUT_JSON" == *'"model":"haiku"'* ]] && MODEL="haiku"
[[ "$INPUT_JSON" == *'"model":"sonnet"'* ]] && MODEL="sonnet"
[[ "$INPUT_JSON" == *'"model":"opus"'* ]] && MODEL="opus"
[[ "$INPUT_JSON" == *'"model": "haiku"'* ]] && MODEL="haiku"
[[ "$INPUT_JSON" == *'"model": "sonnet"'* ]] && MODEL="sonnet"
[[ "$INPUT_JSON" == *'"model": "opus"'* ]] && MODEL="opus"
[ -z "$MODEL" ] && MODEL="unknown"

# Log to session file (append)
LOG_DIR="/home/paul/.claude/routing-logs"
mkdir -p "$LOG_DIR"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) model=$MODEL" >> "$LOG_DIR/session-$(date +%Y%m%d).log"

exit 0
