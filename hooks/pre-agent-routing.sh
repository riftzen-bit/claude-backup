#!/bin/bash
# PreToolUse hook for Agent tool — routing guard + collision check

# Skip when running from TeleClaude
[ "$TELECLAUDE" = "1" ] && exit 0

cat <<'EOF'
<routing-guard>
BEFORE launching this subagent, verify:

1. MODEL ASSIGNMENT: Is the model parameter correct?
   - SIMPLE tasks → model: "haiku"
   - MEDIUM tasks → model: "sonnet"
   - COMPLEX tasks → model: "opus"
   - FRONTEND tasks → use /design command (real tmux Gemini worker, NOT Bash timeout)

2. ROUTING APPROVAL:
   - Clear-cut tasks (search, code review, security scan): auto-dispatch OK, log with [Route]
   - Ambiguous tasks or Opus subagent: ask user before dispatching
   - Frontend/UI tasks: /design dispatches Gemini as tmux worker with filesystem access

3. COLLISION CHECK: Does this agent's file set overlap with any other parallel agent?
   - If YES: do NOT dispatch in parallel. Run sequentially.
   - If NO: safe to parallel dispatch.

4. ISOLATION: Is isolation: "worktree" set for parallel dispatches?
   - All parallel agents MUST use worktree isolation.
   - Solo agents (no parallel peers) may skip worktree.

Opus 4.6 is ALWAYS the leader.
</routing-guard>
EOF
