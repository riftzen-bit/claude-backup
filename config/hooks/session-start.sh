#!/bin/bash
# SessionStart hook — load core context + auto-cleanup stale files

MEMORY_FILE="__HOME__/.claude/projects/memory/MEMORY.md"
ENFORCE_FILE="__HOME__/.claude/enforce.md"
STATE_DIR="__HOME__/.claude/state"
LOG_DIR="__HOME__/.claude/routing-logs"
SESSION_KEY="${CLAUDE_SESSION_ID:-$PPID}"
SESSION_FILE="$STATE_DIR/current-session-id.$SESSION_KEY"

mkdir -p "$STATE_DIR" "$LOG_DIR"
[ -f "$SESSION_FILE" ] || printf '%s\n' "$(date -u +%Y%m%dT%H%M%SZ)-$$" > "$SESSION_FILE"

# ── Auto-cleanup stale files (silent) ──
# Purge session ID files older than 7 days
find "$STATE_DIR" -name 'current-session-id.*' -mtime +7 -delete 2>/dev/null
# Purge routing logs older than 14 days
find "$LOG_DIR" -name '*.jsonl' -mtime +14 -delete 2>/dev/null
# Purge stale security state files
rm -f __HOME__/.claude/security_warnings_state_*.json 2>/dev/null
# Purge stale cross-rules cache older than 1 day
find "$STATE_DIR" -name 'cross-rules-*.txt' -mtime +1 -delete 2>/dev/null
# Fix plugin .sh permissions (workaround for anthropics/claude-code#20432)
find __HOME__/.claude/plugins -name '*.sh' ! -perm -111 -exec chmod +x {} \; 2>/dev/null

# Detect cross-tool instruction files in current directory
CROSS_TOOL_MSG=""
CROSS_FILES=""
for f in .cursor/rules .github/copilot-instructions.md .windsurfrules .clinerules AGENTS.md; do
  [ -e "$f" ] && CROSS_FILES="$CROSS_FILES $f"
done
[ -n "$CROSS_FILES" ] && CROSS_TOOL_MSG="
Cross-tool instruction files detected:$CROSS_FILES — read them for extra project context."

# Detect project type (skip home directory — not a project)
PROJECT_MSG=""
if [ "$(pwd)" != "$HOME" ]; then
  PROJECT_TYPE=""
  [ -f "package.json" ] && PROJECT_TYPE="node"
  [ -f "pyproject.toml" ] || [ -f "setup.py" ] && PROJECT_TYPE="python"
  [ -f "go.mod" ] && PROJECT_TYPE="go"
  [ -f "Cargo.toml" ] && PROJECT_TYPE="rust"
  [ -f "build.gradle.kts" ] || [ -f "build.gradle" ] && PROJECT_TYPE="kotlin/java"
  [ -n "$PROJECT_TYPE" ] && PROJECT_MSG="
Project type: $PROJECT_TYPE"
fi

cat <<EOF
<session-init>
SESSION START — LOAD CONTEXT BEFORE ACTION

You MUST read these files before doing ANYTHING:
1. MEMORY: $MEMORY_FILE
2. ENFORCE: $ENFORCE_FILE
3. CLAUDE.md: __HOME__/.claude/CLAUDE.md
4. RULES: __HOME__/.claude/rules/common/ and __HOME__/.claude/rules/typescript/
5. If in a repo: README/CLAUDE.md plus build/test config and git log --oneline -5

FIRST MESSAGE POLICY:
- If desired behavior, scope, or acceptance criteria are unclear → ask concise product questions first
- If the task is clear → map relevant files and validator commands before editing
- For coding/debugging/refactor tasks → load execution-guard and route search/review/validation to cheaper specialists
- For frontend/UI tasks → load anti-ai-design before implementation
- For simple chat/questions → answer directly

Owner: (configure in CLAUDE.md).
Model policy: Opus leads ambiguity/architecture/security; delegate simpler work.${CROSS_TOOL_MSG}${PROJECT_MSG}
</session-init>
EOF
