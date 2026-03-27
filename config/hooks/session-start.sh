#!/usr/bin/env bash
# Session start hook: token auto-refresh + project context

CREDS="$HOME/.claude/.credentials.json"

# --- Token expiry check + auto-refresh ---
if [[ ! -f "$CREDS" ]]; then
  echo "SessionStart:WARNING: No credentials file found. Run: claude auth login" >&2
  exit 0
fi

expires_at=$(jq -r '.claudeAiOauth.expiresAt // empty' "$CREDS" 2>/dev/null)
refresh_token=$(jq -r '.claudeAiOauth.refreshToken // empty' "$CREDS" 2>/dev/null)

if [[ -z "$expires_at" ]]; then
  echo "SessionStart:WARNING: No OAuth token found. Run: claude auth login" >&2
  exit 0
fi

now_ms=$(($(date +%s) * 1000))
remaining_ms=$((expires_at - now_ms))
remaining_h=$(( remaining_ms / 3600000 ))
remaining_m=$(( (remaining_ms % 3600000) / 60000 ))

if (( remaining_ms <= 0 )); then
  # Token expired -- try auto-refresh if refresh_token exists
  if [[ -n "$refresh_token" ]]; then
    REFRESH_RESULT=$(curl -s -X POST "https://claude.ai/api/auth/refresh" \
      -H "Content-Type: application/json" \
      -d "{\"refreshToken\": \"$refresh_token\"}" 2>/dev/null)

    NEW_TOKEN=$(echo "$REFRESH_RESULT" | jq -r '.accessToken // empty' 2>/dev/null)
    NEW_EXPIRES=$(echo "$REFRESH_RESULT" | jq -r '.expiresAt // empty' 2>/dev/null)

    if [[ -n "$NEW_TOKEN" && -n "$NEW_EXPIRES" ]]; then
      jq --arg at "$NEW_TOKEN" --arg ea "$NEW_EXPIRES" \
        '.claudeAiOauth.accessToken = $at | .claudeAiOauth.expiresAt = ($ea | tonumber)' \
        "$CREDS" > "${CREDS}.tmp" && mv "${CREDS}.tmp" "$CREDS"
      chmod 600 "$CREDS"
      echo "SessionStart:Token auto-refreshed successfully"
    else
      notify-send "Claude Code" "Token expired. Run: claude auth login" 2>/dev/null || true
      echo "SessionStart:TOKEN EXPIRED - auto-refresh failed. Run: claude auth login" >&2
    fi
  else
    notify-send "Claude Code" "Token expired. Run: claude auth login" 2>/dev/null || true
    echo "SessionStart:TOKEN EXPIRED. Run: claude auth login" >&2
  fi
  exit 0
elif (( remaining_ms < 3600000 )); then
  # Less than 1 hour left -- try to refresh proactively
  if [[ -n "$refresh_token" ]]; then
    REFRESH_RESULT=$(curl -s -X POST "https://claude.ai/api/auth/refresh" \
      -H "Content-Type: application/json" \
      -d "{\"refreshToken\": \"$refresh_token\"}" 2>/dev/null)

    NEW_TOKEN=$(echo "$REFRESH_RESULT" | jq -r '.accessToken // empty' 2>/dev/null)
    NEW_EXPIRES=$(echo "$REFRESH_RESULT" | jq -r '.expiresAt // empty' 2>/dev/null)

    if [[ -n "$NEW_TOKEN" && -n "$NEW_EXPIRES" ]]; then
      jq --arg at "$NEW_TOKEN" --arg ea "$NEW_EXPIRES" \
        '.claudeAiOauth.accessToken = $at | .claudeAiOauth.expiresAt = ($ea | tonumber)' \
        "$CREDS" > "${CREDS}.tmp" && mv "${CREDS}.tmp" "$CREDS"
      chmod 600 "$CREDS"
      echo "SessionStart:Token proactively refreshed (was ${remaining_h}h${remaining_m}m left)"
    fi
  else
    echo "SessionStart:Token expires in ${remaining_h}h${remaining_m}m. Consider: claude auth login" >&2
  fi
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

if [[ -n "$project_info" ]]; then
  echo "SessionStart:startup hook success: $project_info"
else
  echo "SessionStart:startup hook success: ready"
fi
