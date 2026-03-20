#!/bin/bash
# Combined PostToolUse hook: post-edit review + UI reminder + package hallucination guard

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

# Optional ECC observation (disabled by default; explicit opt-in only)
if [ "$CLAUDE_ENABLE_ECC_OBSERVE" = "1" ]; then
  echo "$INPUT_JSON" | /home/paul/.claude/hooks/ecc-observe.sh post >/dev/null 2>&1 &
fi

# Check ApplyPatch/Edit/Write/MultiEdit/NotebookEdit
if [[ "$TOOL_NAME" == "ApplyPatch" ]] || \
   [[ "$TOOL_NAME" == "Edit" ]] || \
   [[ "$TOOL_NAME" == "MultiEdit" ]] || \
   [[ "$TOOL_NAME" == "Write" ]] || \
   [[ "$TOOL_NAME" == "NotebookEdit" ]]; then

  cat <<'EOF'
<post-edit-review>
You just modified a file. Review your own change:
- Re-read the edited file to verify correctness
- Check for typos, logic errors, missing imports
- Confirm you know the repo's validator commands before claiming completion
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
elif [[ "$TOOL_NAME" == "Bash" ]]; then

  if [[ "$MUTATING_BASH" == "true" ]]; then
    cat <<'EOF'
<post-bash-write-review>
This Bash command may have changed files.
- Re-read any affected files
- Run the relevant validators before claiming completion
- If UI files changed, verify visually
</post-bash-write-review>
EOF
  fi

  if [[ "${INPUT_JSON,,}" == *"module not found"* ]] || \
     [[ "${INPUT_JSON,,}" == *"not found in registry"* ]] || \
     [[ "${INPUT_JSON,,}" == *"404 not found"* ]] || \
     [[ "${INPUT_JSON,,}" == *"err_module_not_found"* ]] || \
     [[ "${INPUT_JSON,,}" == *"no matching version"* ]] || \
     [[ "${INPUT_JSON,,}" == *"cannot find module"* ]] || \
     [[ "${INPUT_JSON,,}" == *"no such package"* ]] || \
     [[ "${INPUT_JSON,,}" == *"package not found"* ]]; then
    cat <<'EOF'
<hallucination-warning>
Package/module not found. This may be a hallucinated package name.
Verify the package exists: check npm/PyPI/crates.io before retrying.
</hallucination-warning>
EOF
  fi
fi
exit 0
