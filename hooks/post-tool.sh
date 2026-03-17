#!/bin/bash
# Combined PostToolUse hook: observe + review + screenshot + import check
# Optimized: pure bash pattern matching, no Python subprocess

INPUT_JSON=$(cat)

# 1. Continuous learning observation (background, silent)
echo "$INPUT_JSON" | /home/paul/.claude/hooks/ecc-observe.sh post &

# 2. Fast tool detection — pure bash, no Python
# Check Edit/Write/NotebookEdit
if [[ "$INPUT_JSON" == *'"tool_name":"Edit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name":"Write"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name":"NotebookEdit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "Edit"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "Write"'* ]] || \
   [[ "$INPUT_JSON" == *'"tool_name": "NotebookEdit"'* ]]; then

  cat <<'EOF'
<post-edit-review>
You just modified a file. Review your own change:
- Re-read the edited file to verify correctness
- Check for typos, logic errors, missing imports
- Would a senior engineer approve this diff?
</post-edit-review>
EOF

  # UI screenshot reminder for frontend files
  if [[ "$INPUT_JSON" == *'.tsx"'* ]] || [[ "$INPUT_JSON" == *'.jsx"'* ]] || \
     [[ "$INPUT_JSON" == *'.vue"'* ]] || [[ "$INPUT_JSON" == *'.svelte"'* ]] || \
     [[ "$INPUT_JSON" == *'.css"'* ]] || [[ "$INPUT_JSON" == *'.scss"'* ]] || \
     [[ "$INPUT_JSON" == *'.html"'* ]]; then
    cat <<'EOF'
<post-ui-change>
UI file modified. Visually verify with Playwright screenshot.
</post-ui-change>
EOF
  fi

# Check Bash for hallucinated packages
elif [[ "$INPUT_JSON" == *'"tool_name":"Bash"'* ]] || \
     [[ "$INPUT_JSON" == *'"tool_name": "Bash"'* ]]; then

  # Case-insensitive check for module-not-found errors
  INPUT_LOWER="${INPUT_JSON,,}"
  if [[ "$INPUT_LOWER" == *"module not found"* ]] || \
     [[ "$INPUT_LOWER" == *"not found in registry"* ]] || \
     [[ "$INPUT_LOWER" == *"404 not found"* ]] || \
     [[ "$INPUT_LOWER" == *"err_module_not_found"* ]] || \
     [[ "$INPUT_LOWER" == *"no matching version"* ]] || \
     [[ "$INPUT_LOWER" == *"cannot find module"* ]] || \
     [[ "$INPUT_LOWER" == *"no such package"* ]] || \
     [[ "$INPUT_LOWER" == *"package not found"* ]]; then
    cat <<'EOF'
<hallucination-warning>
Package/module not found. This may be a hallucinated package name.
Verify the package exists: check npm/PyPI/crates.io before retrying.
</hallucination-warning>
EOF
  fi
fi

wait
exit 0
