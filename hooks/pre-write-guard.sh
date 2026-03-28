#!/bin/bash
# PreToolUse hook — inject discipline on EVERY tool call
# Light reminder for read-only tools, full guard for mutating tools

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

# ── MUTATING TOOLS: full guard ──
if is_edit_tool; then
  cat <<'EOF'
<pre-write-guard>
STOP — BEFORE THIS EDIT, VERIFY ALL OF THESE:

1. SEARCH: Did you search the codebase for existing code that does this? (3+ queries)
2. READ: Did you re-read THIS file AND all files that import/use it?
3. UNDERSTAND: Can you trace every function call chain affected by this change?
4. TEST FIRST: Does a test file exist? Have you written failing tests FIRST?
   □ If NO test file → STOP. Create test file with 5+ tests per function FIRST.
   □ If test exists → add tests for the NEW behavior BEFORE editing source.
   □ ALL 9 categories: happy, edge, error, boundary, security, integration, async, state, regression
5. ALTERNATIVES: Did you consider 3+ approaches? Why is this one best?
6. IMPACT: What other files will break? What tests need updating?
7. STYLE: Match existing code patterns exactly. No @ts-ignore, no eslint-disable.
8. SECURITY: No hardcoded secrets, parameterized queries, validated inputs.
9. COMPLETENESS: Is this a FULL implementation, not a stub or partial?

Write the test BEFORE the implementation. No exceptions.
code-reviewer(sonnet) after edit. security-reviewer(opus) before commit.
</pre-write-guard>
EOF
elif is_mutating_bash; then
  cat <<'EOF'
<pre-bash-write-guard>
STOP — this Bash command modifies files:
1. Confirm the command is scoped to intended files only
2. Prefer precise file tools (Edit/Write) when possible
3. Re-read affected files and run validators after completion
4. If installing packages: verify they exist first (hallucination guard)
</pre-bash-write-guard>
EOF

# ── AGENT DISPATCH: routing reminder ──
elif [[ "$TOOL_NAME" == "Agent" ]]; then
  cat <<'EOF'
<pre-agent-guard>
Delegation checklist:
1. MODEL: haiku(search) | sonnet(plan/review/validate) | opus(architecture/security)
2. PROMPT: 6-section format (TASK + EXPECTED OUTCOME + SCOPE + MUST DO + MUST NOT DO + CONTEXT)
3. COLLISION: no file overlap with parallel agents
4. ISOLATION: worktree for parallel dispatches
5. NOTEPAD: include notepad paths in CONTEXT for multi-step work
</pre-agent-guard>
EOF

# ── ALL OTHER TOOLS: lightweight reminder ──
else
  cat <<'EOF'
<tool-discipline>
Trust filesystem over memory. Re-read if >5 tool calls since last read. No fabricated paths/APIs.
</tool-discipline>
EOF
fi

exit 0
