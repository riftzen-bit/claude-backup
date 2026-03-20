#!/bin/bash
# PreToolUse hook for mutating tools — remind before edits/writes happen

INPUT_JSON=$(cat)
PYTHON_CODE=$(cat <<'PY'
import json
import re
import sys

def find_first(obj, keys):
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key in keys and isinstance(value, str) and value.strip():
                return value.strip()
            found = find_first(value, keys)
            if found:
                return found
    elif isinstance(obj, list):
        for item in obj:
            found = find_first(item, keys)
            if found:
                return found
    return ""

try:
    data = json.load(sys.stdin)
except Exception:
    data = {}

tool_name = find_first(data, {"tool_name", "tool"})
command_text = find_first(data, {"command", "cmd"})
command_lower = command_text.lower()

mutating_tokens = [
    "sed -i",
    "tee ",
    "touch ",
    "mkdir ",
    "mv ",
    "cp ",
    "rm ",
    "git apply",
    "git restore",
    "git checkout --",
    "patch ",
    "npm install",
    "npm ci",
    "pnpm add",
    "pnpm install",
    "yarn add",
    "yarn install",
    "bun add",
    "bun install",
    "pip install",
    "cargo add",
    "go get",
]

has_redirection = bool(re.search(r'(^|[\s;&|])\d*>>?', command_text))
is_mutating_bash = tool_name == "Bash" and (has_redirection or any(token in command_lower for token in mutating_tokens))

print(tool_name)
print("true" if is_mutating_bash else "false")
PY
)
PARSED=$(printf '%s' "$INPUT_JSON" | python3 -c "$PYTHON_CODE")

TOOL_NAME=$(printf '%s\n' "$PARSED" | sed -n '1p')
MUTATING_BASH=$(printf '%s\n' "$PARSED" | sed -n '2p')

is_edit_tool() {
  [[ "$TOOL_NAME" == "ApplyPatch" ]] || \
  [[ "$TOOL_NAME" == "Edit" ]] || \
  [[ "$TOOL_NAME" == "MultiEdit" ]] || \
  [[ "$TOOL_NAME" == "Write" ]] || \
  [[ "$TOOL_NAME" == "NotebookEdit" ]]
}

is_mutating_bash() {
  [[ "$MUTATING_BASH" == "true" ]]
}

if is_edit_tool; then
  cat <<'EOF'
<pre-write-guard>
Before editing:
- Re-read the target file first
- If behavior or acceptance criteria are unclear, ask before changing code
- If the repo has tests, start with a failing test before implementation
</pre-write-guard>
EOF
elif is_mutating_bash; then
  cat <<'EOF'
<pre-bash-write-guard>
This Bash command appears to modify files.
- Confirm the command is scoped to the intended files only
- Prefer precise file tools when possible
- Re-read affected files and run validators after the write completes
</pre-bash-write-guard>
EOF
fi

exit 0
