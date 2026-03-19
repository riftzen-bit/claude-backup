#!/usr/bin/env bash
# Claude Code Status Line v6 — Real Anthropic Usage API
set -f
input=$(cat)

# ═══ Parse stdin ═══
IFS=$'\x01' read -r cwd model used_pct vim_mode session_name version < <(
    echo "$input" | jq -r '[
        (.workspace.current_dir // .cwd // "?"),
        (.model.display_name // "?"),
        ((.context_window.used_percentage // "") | tostring),
        (.vim.mode // ""),
        (.session_name // ""),
        (.version // "")
    ] | join("\u0001")' 2>/dev/null
)
short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|")

# Git branch
git_branch=""
git -C "$cwd" rev-parse --git-dir &>/dev/null && \
    git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
                 || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

# ═══ Version (cached 1h) ═══
VER_CACHE="$HOME/.claude/.sl-ver"
latest_ver=""
if [ -n "$version" ] && [ "$version" != "null" ]; then
    do_check=1
    if [ -f "$VER_CACHE" ]; then
        age=$(( $(date +%s) - $(stat -c %Y "$VER_CACHE" 2>/dev/null || echo 0) ))
        [ "$age" -lt 3600 ] && do_check=0
        latest_ver="$(< "$VER_CACHE")"
    fi
    [ "$do_check" -eq 1 ] && { ( npm view @anthropic-ai/claude-code version 2>/dev/null > "$VER_CACHE" ) & disown 2>/dev/null; }
fi

# ═══ Plan name (cached, from credentials) ═══
CREDS="$HOME/.claude/.credentials.json"
PLAN_CACHE="$HOME/.claude/.sl-plan"
plan=""
if [ -f "$PLAN_CACHE" ]; then
    plan="$(< "$PLAN_CACHE")"
elif [ -f "$CREDS" ]; then
    plan=$(python3 -c "
import json
d=json.load(open('$CREDS'))
o=d.get('claudeAiOauth',{})
t=o.get('rateLimitTier','')
s=o.get('subscriptionType','')
if '20x' in t: print('Max 20x')
elif '5x' in t: print('Max 5x')
elif 'max' in s: print('Max')
elif 'pro' in s: print('Pro')
elif 'team' in s: print('Team')
else: print(s.capitalize() if s else '')
" 2>/dev/null)
    [ -n "$plan" ] && echo "$plan" > "$PLAN_CACHE"
fi

# ═══ Anthropic Usage API (cached 60s, background refresh) ═══
API_CACHE="$HOME/.claude/.sl-api"
API_LOCK="$HOME/.claude/.sl-api.lock"

_fetch_api() {
    mkdir "$API_LOCK" 2>/dev/null || return
    trap "rmdir '$API_LOCK' 2>/dev/null" EXIT

    local token
    token=$(python3 -c "import json;print(json.load(open('$CREDS'))['claudeAiOauth']['accessToken'])" 2>/dev/null)
    [ -z "$token" ] && { rmdir "$API_LOCK" 2>/dev/null; trap - EXIT; return; }

    curl -s --max-time 10 \
        -H "Authorization: Bearer $token" \
        -H "anthropic-beta: oauth-2025-04-20" \
        -H "User-Agent: claude-code/2.1" \
        "https://api.anthropic.com/api/oauth/usage" > "${API_CACHE}.tmp" 2>/dev/null \
    && mv "${API_CACHE}.tmp" "$API_CACHE" 2>/dev/null

    rmdir "$API_LOCK" 2>/dev/null; trap - EXIT
}

do_api=1
[ -f "$API_CACHE" ] && {
    age=$(( $(date +%s) - $(stat -c %Y "$API_CACHE" 2>/dev/null || echo 0) ))
    [ "$age" -lt 60 ] && do_api=0
}
[ "$do_api" -eq 1 ] && [ -f "$CREDS" ] && { _fetch_api & disown 2>/dev/null; }

# Read API cache
h5_pct=0; h5_reset=""; d7_pct=0; d7_reset=""
if [ -f "$API_CACHE" ] && [ -s "$API_CACHE" ]; then
    IFS=$'\x01' read -r h5_pct h5_reset d7_pct d7_reset < <(
        jq -r '[
            (.five_hour.utilization // 0 | floor),
            (.five_hour.resets_at // ""),
            (.seven_day.utilization // 0 | floor),
            (.seven_day.resets_at // "")
        ] | join("\u0001")' "$API_CACHE" 2>/dev/null
    )
fi

# ═══ Rendering helpers ═══
_quota_bar() {
    local pct=${1:-0} w=${2:-15}
    local filled=$(( pct * w / 100 ))
    [ "$filled" -gt "$w" ] && filled=$w
    [ "$pct" -gt 0 ] 2>/dev/null && [ "$filled" -eq 0 ] && filled=1
    local empty=$(( w - filled ))
    local clr
    if [ "$pct" -ge 90 ] 2>/dev/null; then clr='\033[31m'
    elif [ "$pct" -ge 75 ] 2>/dev/null; then clr='\033[95m'
    else clr='\033[94m'; fi
    local F="███████████████" E="░░░░░░░░░░░░░░░"
    printf "%b%s\033[2m%s\033[0m" "$clr" "${F:0:filled}" "${E:0:empty}"
}

_ctx_bar() {
    local pct=${1:-0} w=${2:-10}
    local filled=$(( pct * w / 100 ))
    [ "$filled" -gt "$w" ] && filled=$w
    [ "$pct" -gt 0 ] 2>/dev/null && [ "$filled" -eq 0 ] && filled=1
    local empty=$(( w - filled ))
    local clr
    if [ "$pct" -ge 85 ] 2>/dev/null; then clr='\033[31m'
    elif [ "$pct" -ge 70 ] 2>/dev/null; then clr='\033[33m'
    else clr='\033[32m'; fi
    local F="██████████" E="░░░░░░░░░░"
    printf "%b%s\033[2m%s\033[0m" "$clr" "${F:0:filled}" "${E:0:empty}"
}

_countdown() {
    local iso="$1"
    [ -z "$iso" ] || [ "$iso" = "null" ] && return
    local epoch now diff
    epoch=$(date -d "$iso" +%s 2>/dev/null) || return
    now=$(date +%s); diff=$(( epoch - now ))
    [ "$diff" -le 0 ] && { echo "0m"; return; }
    local mins=$(( (diff + 59) / 60 ))
    if [ "$mins" -lt 60 ]; then
        printf "%dm" "$mins"
    elif [ "$mins" -lt 1440 ]; then
        local h=$((mins/60)) m=$((mins%60))
        [ "$m" -gt 0 ] && printf "%dh %dm" "$h" "$m" || printf "%dh" "$h"
    else
        local d=$((mins/1440)) rh=$(( (mins%1440)/60 ))
        [ "$rh" -gt 0 ] && printf "%dd %dh" "$d" "$rh" || printf "%dd" "$d"
    fi
}

_qclr() {
    local p=${1:-0}
    if [ "$p" -ge 90 ] 2>/dev/null; then printf '\033[31m'
    elif [ "$p" -ge 75 ] 2>/dev/null; then printf '\033[95m'
    else printf '\033[94m'; fi
}

# ═══ Colors ═══
RS='\033[0m'; BD='\033[1m'; DIM='\033[2m'
Cc='\033[36m'; Cg='\033[32m'; Cy='\033[33m'
Cm='\033[35m'; Cb='\033[34m'; Cr='\033[31m'

# ═══ Line 1: identity + project ═══
L1=""
if [ -n "$plan" ]; then
    L1+="${DIM}[${RS}${Cm}${model}${RS} ${DIM}|${RS} ${Cc}${plan}${RS}${DIM}]${RS}"
else
    L1+="${Cm}${model}${RS}"
fi
L1+=" ${BD}${Cb}${short_cwd}${RS}"
[ -n "$git_branch" ] && L1+=" ${Cg} ${git_branch}${RS}"

# Context bar
if [ -n "$used_pct" ] && [ "$used_pct" != "null" ] && [ "$used_pct" != "" ]; then
    pct_int=${used_pct%.*}
    ctx_clr="$Cg"
    [ "${pct_int:-0}" -ge 70 ] 2>/dev/null && ctx_clr="$Cy"
    [ "${pct_int:-0}" -ge 85 ] 2>/dev/null && ctx_clr="$Cr"
    L1+=" $(_ctx_bar "${pct_int:-0}") ${ctx_clr}${used_pct}%${RS}"
fi

# Version
if [ -n "$version" ] && [ "$version" != "null" ]; then
    if [ -n "$latest_ver" ] && [ "$latest_ver" != "$version" ]; then
        L1+=" ${BD}${Cr}v${version}→${latest_ver}${RS}"
    else
        L1+=" ${DIM}v${version}${RS}"
    fi
fi
[ -n "$session_name" ] && [ "$session_name" != "null" ] && L1+=" ${Cc}[${session_name}]${RS}"
[ -n "$vim_mode" ] && [ "$vim_mode" != "null" ] && L1+=" ${BD}${Cr}[${vim_mode}]${RS}"

# ═══ Line 2: usage ═══
h5_cd=$(_countdown "$h5_reset")
d7_cd=$(_countdown "$d7_reset")

L2="${DIM}Usage${RS} "
L2+="$(_quota_bar "$h5_pct" 15) $(_qclr "$h5_pct")${h5_pct}%${RS}"
[ -n "$h5_cd" ] && L2+=" ${DIM}(${h5_cd} / 5h)${RS}"

L2+="  ${DIM}7d${RS} $(_quota_bar "$d7_pct" 15) $(_qclr "$d7_pct")${d7_pct}%${RS}"
[ -n "$d7_cd" ] && L2+=" ${DIM}(${d7_cd} / 7d)${RS}"

printf "%b\n%b\n" "$L1" "$L2"
