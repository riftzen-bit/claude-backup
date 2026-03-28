#!/bin/bash
# PostToolUse hook — inject review/discipline after EVERY tool call

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
  echo "$INPUT_JSON" | __HOME__/.claude/hooks/ecc-observe.sh post >/dev/null 2>&1 &
fi

# ── EDIT TOOLS: full review ──
if [[ "$TOOL_NAME" == "ApplyPatch" ]] || \
   [[ "$TOOL_NAME" == "Edit" ]] || \
   [[ "$TOOL_NAME" == "MultiEdit" ]] || \
   [[ "$TOOL_NAME" == "Write" ]] || \
   [[ "$TOOL_NAME" == "NotebookEdit" ]]; then

  cat <<'EOF'
<post-edit-review>
FILE MODIFIED — MANDATORY ACTIONS NOW:

1. RE-READ the changed file. Verify correctness line by line.
2. SEARCH for all callers/importers of changed code — verify nothing breaks.
3. TESTS — write/update for EVERY function touched:
   □ 5+ tests per function, ALL 9 categories (happy, edge, error, boundary,
     security, integration, async, state, regression)
   □ 3+ edge cases (null, empty, zero, NaN, unicode, overflow, long strings)
   □ 100% error paths with correct error types
   □ REALISTIC test data — not "foo"/"bar"
4. RUN tests — show ACTUAL output, not "tests pass"
5. SHOW coverage — 100% on new/modified code
6. RUN all validators (build, types, lint) — fix until clean
7. VERIFY completeness:
   □ No "...", no "TODO", no "// implement later", no truncated code
   □ No stubs or partial implementations
   □ All affected files updated (not just the target)

FORBIDDEN: skipping test categories, partial tests, claiming done without evidence.
code-reviewer(sonnet) after edits. security-reviewer(opus) before commit.
</post-edit-review>
EOF

  # UI screenshot reminder for frontend files
  if [[ "$INPUT_JSON" == *'.tsx"'* ]] || [[ "$INPUT_JSON" == *'.jsx"'* ]] || \
     [[ "$INPUT_JSON" == *'.vue"'* ]] || [[ "$INPUT_JSON" == *'.svelte"'* ]] || \
     [[ "$INPUT_JSON" == *'.css"'* ]] || [[ "$INPUT_JSON" == *'.scss"'* ]] || \
     [[ "$INPUT_JSON" == *'.html"'* ]]; then
    cat <<'EOF'
<post-ui-change>
UI file modified — visually verify with Playwright screenshot before claiming done.
</post-ui-change>
EOF
  fi

# ── BASH: mutating + hallucination guard ──
elif [[ "$TOOL_NAME" == "Bash" ]]; then

  if [[ "$MUTATING_BASH" == "true" ]]; then
    cat <<'EOF'
<post-bash-write-review>
Bash modified files — re-read affected files and run validators before completion.
</post-bash-write-review>
EOF
  fi

  INPUT_LOWER=$(printf '%s' "$INPUT_JSON" | tr '[:upper:]' '[:lower:]')
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
Package/module not found — likely hallucinated name. Verify on npm/PyPI/crates.io before retrying.
</hallucination-warning>
EOF
  fi

# ── AGENT: completion check ──
elif [[ "$TOOL_NAME" == "Agent" ]]; then
  cat <<'EOF'
<post-agent-review>
Subagent completed — verify its output before trusting. Check files it claims to have modified.
</post-agent-review>
EOF

# ── READ/GREP/GLOB: directory context injection ──
elif [[ "$TOOL_NAME" == "Read" ]] || [[ "$TOOL_NAME" == "Grep" ]] || [[ "$TOOL_NAME" == "Glob" ]]; then
  # Extract file path from input and check for nearby AGENTS.md
  FILE_DIR=$(printf '%s' "$INPUT_JSON" | python3 -c "
import json, sys, os
try:
    d = json.load(sys.stdin)
    p = ''
    if isinstance(d, dict):
        for k in ('file_path', 'path', 'pattern'):
            if k in d and isinstance(d[k], str):
                p = d[k]; break
        if not p:
            for v in d.values():
                if isinstance(v, dict):
                    for k in ('file_path', 'path'):
                        if k in v and isinstance(v[k], str):
                            p = v[k]; break
    if p and os.path.isfile(p):
        print(os.path.dirname(p))
    elif p and os.path.isdir(p):
        print(p)
except: pass
" 2>/dev/null)

  if [ -n "$FILE_DIR" ] && [ -d "$FILE_DIR" ]; then
    # Check for AGENTS.md up the directory tree (max 3 levels)
    CHECK_DIR="$FILE_DIR"
    for i in 1 2 3; do
      if [ -f "$CHECK_DIR/AGENTS.md" ]; then
        printf '<directory-context>\n'
        printf '[AGENTS.md: %s/AGENTS.md]\n' "$CHECK_DIR"
        head -40 "$CHECK_DIR/AGENTS.md"
        printf '\n</directory-context>\n'
        break
      fi
      CHECK_DIR=$(dirname "$CHECK_DIR")
      [ "$CHECK_DIR" = "/" ] && break
    done
  fi
fi

exit 0
