---
name: design
description: Dispatch frontend/UI design tasks to Gemini as a real tmux worker. Gemini edits files directly, Opus validates and merges.
---

# Gemini Real Worker — tmux Design Dispatch

Route frontend/UI task to Gemini CLI in a tmux pane. Gemini edits files directly, Opus validates.

## Step 1: Pre-flight

- **tmux required**: `$TMUX` empty → tell user `tmux new -s work`, STOP
- **gemini CLI required**: `command -v gemini` fails → fall back to Opus, log `[Design] gemini unavailable → opus fallback`

## Step 2: Gather Project Context

- Detect framework (package.json) and CSS approach (Tailwind v3/v4, CSS Modules, styled-components, plain)
- Read: global styles/theme/tokens, target component, layout wrapper, design docs
- Note constraints: color palette, typography, breakpoints, dark mode

## Step 3: Git Safety Net

```bash
git stash push -m "pre-gemini-design-$(date +%s)" --include-untracked 2>/dev/null
git checkout -b gemini-design-$(date +%s) 2>/dev/null
```

Skip if not a git repo.

## Step 4: Build Gemini Prompt

Self-contained prompt MUST include:

```
You are an elite frontend designer. You have FULL filesystem access. Edit files directly.

AESTHETIC: [Choose bold direction — brutally minimal, retro-futuristic, organic, luxury, editorial, brutalist, art deco, industrial. NEVER "generic modern".]

PROJECT: Framework=[detected], CSS=[detected+version], Dir=[pwd]

EXISTING CODE: [key file excerpts from Step 2]

TASK: [user's design request]

DESIGN RULES:
- Distinctive fonts — NEVER Inter, Roboto, Arial as primary
- CSS variables for color themes — dominant + sharp accents
- Atmosphere: gradient meshes, noise textures, geometric patterns
- Purposeful animations — staggered reveals, not gratuitous
- FORBIDDEN: purple/indigo gradients, 3-card grids, cookie-cutter heroes, predictable layouts, AI-generic patterns
- Unexpected layouts: asymmetry, overlap, diagonal flow, grid-breaking, generous negative space
- WCAG 2.1 AA: 4.5:1 contrast, semantic HTML, keyboard navigable
- Mobile-first, touch targets ≥44x44px

INSTRUCTIONS: Edit files DIRECTLY. Use project's existing CSS approach. Summarize changes when done.
```

## Step 5: Dispatch to tmux

Models (try in order): `gemini-3.1-pro-preview` → `gemini-3-flash-preview` → Opus fallback.

Flags: `--sandbox false` (filesystem), `-y` (auto-approve), `-p "..."` (non-interactive).

**Prompt delivery** — write to stable path, use `tmux send-keys -l`:
```bash
PROMPT_FILE="/tmp/gemini-design-$(date +%s).md"
PANE_ID=$(tmux split-window -h -d -c "$(pwd)" -P -F '#{pane_id}')
sleep 1
CMD="gemini -m gemini-3.1-pro-preview --sandbox false -y -p \"\$(cat $PROMPT_FILE)\" && echo ___GEMINI_DONE___ || echo ___GEMINI_FAILED___"
tmux send-keys -t "$PANE_ID" -l "$CMD"
tmux send-keys -t "$PANE_ID" Enter
```

Do NOT use `$(cat file)` directly in send-keys — subshell races.

## Step 6: Monitor (poll 5s, timeout 300s)

```bash
TIMEOUT=300; ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  tmux capture-pane -t "$PANE_ID" -p -S -10 2>/dev/null | grep -q '___GEMINI_DONE___\|___GEMINI_FAILED___' && break
  sleep 5; ELAPSED=$((ELAPSED + 5))
done
rm -f "$PROMPT_FILE"
```

Rate limit (429): retry with `gemini-3-flash-preview`. Both fail → kill pane, Opus fallback.
gemini CLI may exit 0 on rate limit — always verify via `git diff`.

## Step 7: Opus Validation

Review `git diff`: syntax valid? Anti-slop clean? Accessible? Responsive? Framework match? Imports exist? No broken non-UI files?

Fix issues directly in branch.

## Step 8: Merge & Cleanup

```bash
git checkout - && git merge gemini-design-* && git stash pop 2>/dev/null
tmux kill-pane -t "$PANE_ID" 2>/dev/null && rm -f "$PROMPT_FILE"
```

## Step 9: Report

1. What Gemini changed (files + descriptions)
2. What Opus fixed in validation
3. Remind: "Check rendered output — layout issues are silent"

## Fallback Table

| Failure | Action |
|---------|--------|
| No tmux | Tell user, STOP |
| No gemini CLI | Opus with same anti-slop rules |
| Auth expired | Opus fallback, suggest `gemini auth login` |
| Timeout 300s | Kill pane, Opus fallback |
| Breaks things | `git checkout .` revert, Opus fallback |
