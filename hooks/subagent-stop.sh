#!/bin/bash
# SubagentStop hook: log subagent completions for routing stats

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
            if key in keys:
                if isinstance(value, str) and value.strip():
                    return value.strip()
                if isinstance(value, bool):
                    return value
            found = find_first(value, keys)
            if found not in (None, ""):
                return found
    elif isinstance(obj, list):
        for item in obj:
            found = find_first(item, keys)
            if found not in (None, ""):
                return found
    return None

raw = os.environ.get("INPUT_JSON", "")
log_file = os.environ["LOG_FILE"]

record = {
    "event": "complete",
    "ts": datetime.now(timezone.utc).isoformat(),
    "model": "unknown",
    "description": "",
    "status": "ok",
}

try:
    data = json.loads(raw)
    record["model"] = find_first(data, {"model"}) or "unknown"
    record["description"] = find_first(data, {"description", "task_description"}) or ""
    error = find_first(data, {"error", "exception"})
    success = find_first(data, {"success", "ok"})
    if error:
        record["status"] = "failed"
        record["error"] = str(error)
    elif success is False:
        record["status"] = "failed"
except Exception:
    pass

with open(log_file, "a", encoding="utf-8") as fh:
    fh.write(json.dumps(record, ensure_ascii=False) + "\n")
PY

exit 0
