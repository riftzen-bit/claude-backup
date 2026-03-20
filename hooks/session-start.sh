#!/bin/bash
# SessionStart hook — load core context and execution policy

MEMORY_FILE="/home/paul/.claude/projects/-home-paul/memory/MEMORY.md"
ENFORCE_FILE="/home/paul/.claude/enforce.md"
STATE_DIR="/home/paul/.claude/state"
SESSION_KEY="${CLAUDE_SESSION_ID:-$PPID}"
SESSION_FILE="$STATE_DIR/current-session-id.$SESSION_KEY"

mkdir -p "$STATE_DIR"
[ -f "$SESSION_FILE" ] || printf '%s\n' "$(date -u +%Y%m%dT%H%M%SZ)-$$" > "$SESSION_FILE"

# Check for stale files
STALE_COUNT=$(ls /home/paul/.claude/security_warnings_state_*.json 2>/dev/null | wc -l)
STALE_MSG=""
[ "$STALE_COUNT" -gt 0 ] && STALE_MSG="
⚠ $STALE_COUNT stale security state files. Clean: rm ~/.claude/security_warnings_state_*.json"

cat <<EOF
<session-init>
SESSION START — LOAD CONTEXT BEFORE ACTION

You MUST read these files before doing ANYTHING:
1. MEMORY: $MEMORY_FILE
2. ENFORCE: $ENFORCE_FILE
3. CLAUDE.md: /home/paul/.claude/CLAUDE.md
4. RULES: /home/paul/.claude/rules/common/ and /home/paul/.claude/rules/typescript/
5. If in a repo: README/CLAUDE.md plus build/test config and git log --oneline -5

FIRST MESSAGE POLICY:
- If desired behavior, scope, or acceptance criteria are unclear → ask concise product questions first
- If the task is clear → map relevant files and validator commands before editing
- For coding/debugging/refactor tasks → load execution-guard and route search/review/validation to cheaper specialists
- For frontend/UI tasks → load anti-ai-design before implementation
- For simple chat/questions → answer directly

Owner: Paul, Vietnamese speaker, non-programmer, PST timezone.
Model policy: Opus leads ambiguity/architecture/security; delegate simpler work.${STALE_MSG}
</session-init>
EOF
