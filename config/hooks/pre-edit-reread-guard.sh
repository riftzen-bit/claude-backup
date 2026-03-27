#!/bin/bash
# PreToolUse hook — HARD enforcement: must re-read file before editing
# Tracks which files have been read recently and blocks edits to stale files

INPUT_JSON=$(cat)

RESULT=$(INPUT_JSON="$INPUT_JSON" python3 - <<'PY'
import json
import os
import sys
import time

STATE_DIR = os.path.expanduser("~/.claude/state")
READS_DIR = os.path.join(STATE_DIR, "file-reads")
os.makedirs(READS_DIR, exist_ok=True)

# Max seconds since last read before we warn (120 seconds = 2 minutes)
MAX_STALE_SECONDS = 120
# Max tool calls since last read (tracked via a counter file)
MAX_TOOLS_SINCE_READ = 8

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

def find_all_paths(obj, keys):
    paths = []
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key in keys and isinstance(value, str) and value.strip():
                paths.append(value.strip())
            paths.extend(find_all_paths(value, keys))
    elif isinstance(obj, list):
        for item in obj:
            paths.extend(find_all_paths(item, keys))
    return paths

raw = os.environ.get("INPUT_JSON", "")
try:
    data = json.loads(raw)
except:
    data = {}

tool_name = find_first(data, {"tool_name", "tool"})

# Track reads: when a file is read, record the timestamp
if tool_name in ("Read", "Grep", "Glob", "Cat"):
    paths = find_all_paths(data, {"file_path", "path", "filePath"})
    for p in paths:
        if p and os.path.isfile(p):
            safe_name = p.replace("/", "__").replace(".", "_")
            tracker = os.path.join(READS_DIR, safe_name)
            with open(tracker, "w") as f:
                f.write(str(time.time()))
    # Increment tool counter
    counter_file = os.path.join(STATE_DIR, "tool-call-counter")
    count = 0
    if os.path.exists(counter_file):
        try:
            count = int(open(counter_file).read().strip())
        except:
            count = 0
    with open(counter_file, "w") as f:
        f.write(str(count + 1))
    sys.exit(0)

# For ANY tool call, increment the counter
counter_file = os.path.join(STATE_DIR, "tool-call-counter")
count = 0
if os.path.exists(counter_file):
    try:
        count = int(open(counter_file).read().strip())
    except:
        count = 0
with open(counter_file, "w") as f:
    f.write(str(count + 1))

# Only check for edit tools
edit_tools = {"ApplyPatch", "Edit", "MultiEdit", "Write", "NotebookEdit"}
if tool_name not in edit_tools:
    sys.exit(0)

# Get file being edited
paths = find_all_paths(data, {"file_path", "path", "filePath"})
if not paths:
    sys.exit(0)

warnings = []
for p in paths:
    if not p:
        continue

    # Skip config/non-code files
    basename = os.path.basename(p)
    skip_patterns = [
        "CLAUDE.md", "AGENTS.md", ".env", ".gitignore",
        "package.json", "tsconfig", ".eslint", ".prettier",
        "settings.json", "enforce.md",
    ]
    if any(pat in basename for pat in skip_patterns):
        continue

    # Check if this file was recently read
    safe_name = p.replace("/", "__").replace(".", "_")
    tracker = os.path.join(READS_DIR, safe_name)

    if not os.path.exists(tracker):
        # NEVER been read in this session
        warnings.append(f"NEVER_READ|{p}")
        continue

    try:
        last_read = float(open(tracker).read().strip())
    except:
        warnings.append(f"NEVER_READ|{p}")
        continue

    elapsed = time.time() - last_read

    if elapsed > MAX_STALE_SECONDS:
        minutes = int(elapsed / 60)
        warnings.append(f"STALE|{p}|{minutes}m ago")

if warnings:
    print("WARN")
    for w in warnings:
        print(w)
else:
    print("OK")
PY
)

STATUS=$(echo "$RESULT" | head -1)

if [ "$STATUS" = "WARN" ]; then
    NEVER_READ=$(echo "$RESULT" | grep "^NEVER_READ|")
    STALE=$(echo "$RESULT" | grep "^STALE|")

    cat <<'HEADER'
<reread-enforcement>
STALE FILE WARNING — You MUST re-read before editing!
Memory degrades after tool calls. Trust the filesystem, not cache.
HEADER

    if [ -n "$NEVER_READ" ]; then
        echo ""
        echo "FILES NEVER READ in this session (CRITICAL — read them FIRST):"
        echo "$NEVER_READ" | while IFS='|' read -r _ filepath; do
            printf '  !! %s — MUST Read() this file before editing!\n' "$filepath"
        done
    fi

    if [ -n "$STALE" ]; then
        echo ""
        echo "FILES READ TOO LONG AGO (re-read to refresh memory):"
        echo "$STALE" | while IFS='|' read -r _ filepath ago; do
            printf '  !! %s — last read %s, re-read now!\n' "$filepath" "$ago"
        done
    fi

    cat <<'FOOTER'

ACTION REQUIRED: Use Read() on each file above BEFORE proceeding with this edit.
Do NOT edit from memory. Do NOT guess file contents. Read it fresh.
</reread-enforcement>
FOOTER
fi

exit 0
