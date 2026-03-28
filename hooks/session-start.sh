#!/usr/bin/env bash
# Session start hook: token status check + project context
# NOTE: Claude Code handles its own OAuth refresh internally.
# This hook only CHECKS status and warns — never touches credentials.

CREDS="$HOME/.claude/.credentials.json"

# --- Token status check (read-only, no refresh attempts) ---
if [[ ! -f "$CREDS" ]]; then
  echo "SessionStart:WARNING: No credentials file found. Run: claude auth login" >&2
  exit 0
fi

expires_at=$(jq -r '.claudeAiOauth.expiresAt // empty' "$CREDS" 2>/dev/null)

if [[ -z "$expires_at" ]]; then
  echo "SessionStart:WARNING: No OAuth token found. Run: claude auth login" >&2
  exit 0
fi

now_ms=$(($(date +%s) * 1000))
remaining_ms=$((expires_at - now_ms))
remaining_h=$(( remaining_ms / 3600000 ))
remaining_m=$(( (remaining_ms % 3600000) / 60000 ))

if (( remaining_ms <= 0 )); then
  notify-send "Claude Code" "Token expired. Run: claude auth login" 2>/dev/null || true
  echo "SessionStart:TOKEN EXPIRED. Run: claude auth login" >&2
  exit 0
elif (( remaining_ms < 3600000 )); then
  echo "SessionStart:Token expires in ${remaining_h}h${remaining_m}m — Claude Code will auto-refresh" >&2
fi

# --- Project type detection ---
project_info=""
if [[ -f "package.json" ]]; then
  langs="javascript"
  frameworks=""
  [[ -f "next.config.js" || -f "next.config.mjs" || -f "next.config.ts" ]] && frameworks="next.js"
  [[ -f "tsconfig.json" ]] && langs="typescript"
  project_info="Project type: {\"languages\":[\"$langs\"],\"frameworks\":[\"$frameworks\"],\"primary\":\"$langs\",\"projectDir\":\"$(pwd)\"}"
elif [[ -f "go.mod" ]]; then
  project_info="Project type: {\"languages\":[\"go\"],\"frameworks\":[],\"primary\":\"go\",\"projectDir\":\"$(pwd)\"}"
elif [[ -f "pyproject.toml" || -f "setup.py" ]]; then
  project_info="Project type: {\"languages\":[\"python\"],\"frameworks\":[],\"primary\":\"python\",\"projectDir\":\"$(pwd)\"}"
elif [[ -f "Cargo.toml" ]]; then
  project_info="Project type: {\"languages\":[\"rust\"],\"frameworks\":[],\"primary\":\"rust\",\"projectDir\":\"$(pwd)\"}"
fi

# --- Auto-fix plugin hook permissions (survives plugin updates) ---
find "$HOME/.claude/plugins/" -name "*.sh" -not -perm -u+x -exec chmod +x {} \; 2>/dev/null

if [[ -n "$project_info" ]]; then
  echo "SessionStart:startup hook success: $project_info"
else
  echo "SessionStart:startup hook success: ready"
fi
