#!/bin/bash
# PreToolUse hook for Agent tool — routing guard + collision check

INPUT_JSON=$(cat)
STATE_DIR="/home/paul/.claude/state"
SESSION_KEY="${CLAUDE_SESSION_ID:-$PPID}"
SESSION_FILE="$STATE_DIR/current-session-id.$SESSION_KEY"
LOG_DIR="/home/paul/.claude/routing-logs"

mkdir -p "$STATE_DIR" "$LOG_DIR"
[ -f "$SESSION_FILE" ] || printf '%s\n' "$(date -u +%Y%m%dT%H%M%SZ)-$$" > "$SESSION_FILE"
SESSION_ID=$(cat "$SESSION_FILE")
LOG_FILE="$LOG_DIR/session-$SESSION_ID.jsonl"

INPUT_JSON="$INPUT_JSON" LOG_FILE="$LOG_FILE" python3 - <<'PY'
import json
import os
from datetime import datetime, timezone

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

raw = os.environ.get("INPUT_JSON", "")
log_file = os.environ["LOG_FILE"]

record = {
    "event": "dispatch",
    "ts": datetime.now(timezone.utc).isoformat(),
    "model": "unknown",
    "description": "",
}

try:
    data = json.loads(raw)
    record["model"] = find_first(data, {"model"}) or "unknown"
    record["description"] = find_first(data, {"description", "task_description"}) or ""
except Exception:
    pass

with open(log_file, "a", encoding="utf-8") as fh:
    fh.write(json.dumps(record, ensure_ascii=False) + "\n")
PY

cat <<'EOF'
<routing-guard>
BEFORE launching this subagent, verify:

1. MODEL ASSIGNMENT: Is the model parameter correct?
   - SIMPLE tasks → model: "haiku"
   - MEDIUM tasks → model: "sonnet"
   - COMPLEX tasks → model: "opus"
   - FRONTEND tasks → use /design command (real tmux Gemini worker, NOT Bash timeout)

2. ROUTING APPROVAL:
   - Clear-cut tasks (search, planning, code review, validation, security scan): auto-dispatch OK; dispatches are logged automatically
   - Ask the user only when product intent or acceptance criteria are ambiguous
   - Clear complex work may dispatch an Opus subagent without asking if the goal is already clear
   - Frontend/UI tasks: /design requires explicit user opt-in because Gemini gets filesystem access; otherwise keep the work on Claude

3. COLLISION CHECK: Does this agent's file set overlap with any other parallel agent?
   - If YES: do NOT dispatch in parallel. Run sequentially.
   - If NO: safe to parallel dispatch.

4. ISOLATION: Is isolation: "worktree" set for parallel dispatches?
   - All parallel agents MUST use worktree isolation.
   - Solo agents (no parallel peers) may skip worktree.

Opus 4.6 is ALWAYS the leader.
</routing-guard>
EOF
