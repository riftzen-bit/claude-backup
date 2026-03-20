#!/bin/bash
# PostToolUse hook — best-effort desktop notification for file mutations

INPUT_JSON=$(cat)

if [[ "$INPUT_JSON" == *'"tool_name":"ApplyPatch"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name":"Edit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name":"MultiEdit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name":"Write"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name":"NotebookEdit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "ApplyPatch"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "Edit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "MultiEdit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "Write"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "NotebookEdit"'* ]]; then
  notify-send "Claude Code" "File change applied — re-read, validate, and review." >/dev/null 2>&1 || true
fi

exit 0
