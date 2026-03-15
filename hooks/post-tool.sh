#!/bin/bash
# Combined PostToolUse hook: observe + review + screenshot
# Single hook = single "Async hook Stop completed" message

INPUT_JSON=$(cat)

# 1. Continuous learning observation (background, silent)
echo "$INPUT_JSON" | /home/paul/.claude/plugins/cache/everything-claude-code/everything-claude-code/1.8.0/skills/continuous-learning-v2/hooks/observe.sh post 2>/dev/null &

# 2. Extract tool name
TOOL_NAME=$(echo "$INPUT_JSON" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_name",""))' 2>/dev/null || echo "")

case "$TOOL_NAME" in
  Edit|Write|NotebookEdit)
    # Auto-review reminder
    cat <<'EOF'
<post-edit-review>
You just modified a file. Review your own change:
- Re-read the edited file to verify correctness
- Check for typos, logic errors, missing imports
- Would a senior engineer approve this diff?
</post-edit-review>
EOF

    # UI screenshot reminder
    FILE_PATH=$(echo "$INPUT_JSON" | python3 -c 'import json,sys; d=json.load(sys.stdin).get("tool_input",{}); print(d.get("file_path",d.get("path","")))' 2>/dev/null || echo "")
    case "$FILE_PATH" in
      *.tsx|*.jsx|*.vue|*.svelte|*.css|*.scss|*.html)
        cat <<'EOF'
<post-ui-change>
UI file modified. Visually verify with Playwright screenshot.
</post-ui-change>
EOF
        ;;
    esac
    ;;
esac

wait
exit 0
