---
name: design
description: Dispatch frontend/UI design tasks to Gemini as a real tmux worker, but only after explicit user opt-in. Gemini edits files directly, Opus validates and merges.
---

# Gemini Real Worker — tmux Design Dispatch

Route frontend/UI work to Gemini CLI in a tmux pane only after explicit user opt-in. Gemini edits files directly inside the current project, then Opus validates before keeping the result.

## Step 1: Pre-flight

- **explicit opt-in required**: if the user did not clearly approve Gemini for this task, STOP and ask first
- **tmux required**: `$TMUX` empty → tell user `tmux new -s work`, STOP
- **gemini CLI required**: `command -v gemini` fails → fall back to Opus, log `[Design] gemini unavailable → opus fallback`
- **workspace discipline required**: keep Gemini scoped to the current project only; never include secrets, credentials, or unrelated files in the prompt

## Step 2: Gather Project Context

- Detect framework (package.json) and CSS approach (Tailwind v3/v4, CSS Modules, styled-components, plain)
- Read: global styles/theme/tokens, target component, layout wrapper, design docs
- Note constraints: color palette, typography, breakpoints, dark mode

## Step 3: Git Safety Net

```bash
STAMP=$(date +%s)
BRANCH_NAME="gemini-design-$STAMP"
STASH_NAME="pre-gemini-design-$STAMP"
STASH_CREATED=0

git stash push -m "$STASH_NAME" --include-untracked >/dev/null 2>&1 && STASH_CREATED=1
git checkout -b "$BRANCH_NAME" 2>/dev/null || git checkout "$BRANCH_NAME"
```

Skip if not a git repo.

## Step 4: Build Gemini Prompt

Self-contained prompt MUST include:

```
You are an elite frontend designer. You have direct workspace write access from the current project directory. Stay strictly inside this repository.

AESTHETIC: [Choose bold direction — brutally minimal, retro-futuristic, organic, luxury, editorial, brutalist, art deco, industrial. NEVER "generic modern".]

PROJECT: Framework=[detected], CSS=[detected+version], Dir=[pwd]

EXISTING CODE: [minimum non-sensitive excerpts from Step 2]

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

INSTRUCTIONS: Edit files DIRECTLY. Use the project's existing CSS approach. Do not read or echo secrets, credentials, or unrelated files. Summarize exact files changed when done.
```

## Step 5: Dispatch to tmux

Models (try in order): `gemini-3.1-pro-preview` → `gemini-3-flash-preview` → Opus fallback.

Gemini CLI supports stdin plus `-p` for headless mode. Keep the full prompt out of process arguments.

**Prompt delivery** — write the Step 4 prompt to a secure temp file, then send a single command to tmux:
```bash
PROMPT_FILE=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/gemini-design.XXXXXX.md")
chmod 600 "$PROMPT_FILE"
# Write the full Step 4 prompt into "$PROMPT_FILE" before dispatch.

PANE_ID=$(tmux split-window -h -d -c "$(pwd)" -P -F '#{pane_id}')
cleanup() {
  rm -f "$PROMPT_FILE"
  tmux clear-history -t "$PANE_ID" 2>/dev/null || true
  tmux kill-pane -t "$PANE_ID" 2>/dev/null || true
}
trap cleanup EXIT

sleep 1
CMD="cat \"$PROMPT_FILE\" | gemini -m gemini-3.1-pro-preview --sandbox false --approval-mode auto_edit --include-directories \"$(pwd)\" -p \"Execute the full design brief from stdin exactly.\" && echo ___GEMINI_DONE___ || echo ___GEMINI_FAILED___"
tmux send-keys -t "$PANE_ID" -l "$CMD"
tmux send-keys -t "$PANE_ID" Enter
```

If the first model rate-limits, resend the same command with `gemini-3-flash-preview`.

## Step 6: Monitor (poll 5s, timeout 300s)

```bash
TIMEOUT=300; ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  tmux capture-pane -t "$PANE_ID" -p -S -10 2>/dev/null | grep -q '___GEMINI_DONE___\|___GEMINI_FAILED___' && break
  sleep 5; ELAPSED=$((ELAPSED + 5))
done
```

Rate limit (429): retry once with `gemini-3-flash-preview`. Both fail → Opus fallback.
Gemini CLI may exit `0` even on partial failure — always verify with `git diff` and validator output before keeping the result.

## Step 7: Opus Validation

Review `git diff` first: syntax valid? Anti-slop clean? Accessible? Responsive? Framework match? Imports exist? No broken non-UI files?

Then run the repo's real validators (build/typecheck/lint/tests, or the repo's actual chain). If validators fail, fix the root cause in the Gemini branch and rerun.

After validators pass:
- run `code-reviewer`
- run `security-reviewer` if the change touched auth, network, shell, secrets, or non-UI config

## Step 8: Merge & Cleanup

```bash
git checkout - && git merge "$BRANCH_NAME"
[ "$STASH_CREATED" -eq 1 ] && git stash list | grep -q "$STASH_NAME" && git stash pop
trap - EXIT
cleanup
```

## Step 9: Report

1. What Gemini changed (files + descriptions)
2. What Opus fixed during validation/review
3. Remind: "Check rendered output — layout issues are silent"

## Fallback Table

| Failure | Action |
|---------|--------|
| No tmux | Tell user, STOP |
| No gemini CLI | Opus with same anti-slop rules |
| Auth expired | Opus fallback, suggest `gemini auth login` |
| Timeout 300s | Kill pane, Opus fallback |
| Breaks things | Restore only files from `git diff --name-only` or drop the Gemini branch, then fall back to Opus |
