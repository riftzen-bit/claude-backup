---
name: design
description: Dispatch frontend/UI design tasks to Gemini as a real tmux worker. Gemini edits files directly, Opus validates and merges.
---

# Gemini Real Worker — tmux Design Dispatch

Route this frontend/UI task to a real Gemini CLI worker running in a tmux pane.
Gemini has full filesystem access and edits files directly. Opus validates before keeping changes.

## Step 1: Pre-flight Checks

Run these checks before anything else:

**1a. tmux required:**
- If `$TMUX` is empty → you are NOT inside tmux
- Tell user: "Start a tmux session first: `tmux new -s work`, then re-run `/design`"
- STOP here if not in tmux

**1b. gemini CLI required:**
- Run `command -v gemini` — if not found, fall back to Opus immediately
- Log: `[Design] gemini unavailable → opus fallback`

## Step 2: Gather Project Context

Before dispatching, scan the project to build context for Gemini:

**2a. Detect project type:**
- Check package.json for framework (React, Next.js, Vue, Svelte, Astro)
- Check for plain HTML/CSS if no package.json
- Identify CSS approach: tailwind.config.* → Tailwind | *.module.css → CSS Modules | styled-components | plain CSS/Sass

**2b. Read relevant files** (include key excerpts in Gemini prompt):
- Global styles / theme / design tokens (CSS variables, Tailwind config, theme files)
- Component being redesigned (if applicable)
- Layout/template wrapping the target component
- Any design system docs or style guides

**2c. Identify constraints:**
- Tailwind version: v3 (tailwind.config.js) vs v4 (CSS @theme directives)
- Existing color palette, typography, spacing scale
- Responsive breakpoints, dark mode support

## Step 3: Create Git Safety Net

Before Gemini touches any files, create a checkpoint:

```bash
# Stash any uncommitted work first
git stash push -m "pre-gemini-design-$(date +%s)" --include-untracked 2>/dev/null

# Create a branch for Gemini's work
git checkout -b gemini-design-$(date +%s) 2>/dev/null
```

If git is not available or not a repo, skip this step — Gemini will still work but no rollback safety.

## Step 4: Build Gemini Prompt

Construct a self-contained prompt. The prompt MUST include:

```
You are an elite frontend designer creating production-ready code.
You have FULL filesystem access. Edit files directly using your tools.

AESTHETIC DIRECTION:
[Choose a bold direction — brutally minimal, retro-futuristic, organic/natural, luxury/refined, editorial/magazine, brutalist/raw, art deco/geometric, industrial/utilitarian. NEVER "generic modern".]

PROJECT:
- Framework: [detected framework]
- CSS: [detected CSS approach + version]
- Working directory: [pwd]

EXISTING CODE CONTEXT:
[Include key file excerpts gathered in Step 2]

TASK:
[user's design request — the $ARGUMENTS from the /design command]

DESIGN RULES (mandatory):
- Choose distinctive, characterful fonts — NEVER Inter, Roboto, Arial, or system fonts as primary
- Use CSS variables for cohesive color themes — dominant colors with sharp accents
- Add atmosphere: gradient meshes, noise textures, geometric patterns, layered transparencies
- Animations must be purposeful — orchestrated page load with staggered reveals
- FORBIDDEN: purple/indigo gradients on white, generic 3-card grids, cookie-cutter heroes, predictable layouts
- FORBIDDEN: any pattern that looks "AI generated" or generic
- Use unexpected layouts: asymmetry, overlap, diagonal flow, grid-breaking elements, generous negative space
- WCAG 2.1 AA: 4.5:1 contrast (normal text), 3:1 (large text), semantic HTML, keyboard navigable
- Mobile-first: base styles for mobile, min-width media queries for larger screens
- Touch targets: minimum 44x44px

INSTRUCTIONS:
- Edit the project files DIRECTLY using your file editing tools
- Do NOT just output code — actually write it to the correct files
- Create new files if needed (specify full paths)
- Use the project's existing CSS approach (don't switch methods)
- When done, output a brief summary of what you changed and why
```

## Step 5: Dispatch to tmux Worker

Spawn Gemini in a new tmux pane. Key technical details from testing:

**Model selection** (try in order):
1. `gemini-3.1-pro-preview` — primary, best quality
2. `gemini-3-flash-preview` — fallback if pro is rate-limited (429)
3. Fallback to Opus if all Gemini models fail

**Flags required:**
- `--sandbox false` — filesystem access (read/write project files)
- `-y` — YOLO mode (auto-approve all tool calls, required for headless file editing)
- `-p "..."` — non-interactive prompt mode

**Prompt delivery** (critical — tested and verified):
- Do NOT use `$(cat file)` in tmux send-keys — the subshell may race or fail
- Instead, use `tmux send-keys -l` with the prompt INLINE (escaped properly)
- For long prompts: write to a STABLE path (not mktemp), send the cat command as part of the inline, and clean up AFTER polling confirms completion

```bash
# Write prompt to stable location
PROMPT_FILE="/tmp/gemini-design-$(date +%s).md"
# Write the constructed prompt to $PROMPT_FILE

# Split tmux pane horizontally (Gemini on the right)
PANE_ID=$(tmux split-window -h -d -c "$(pwd)" -P -F '#{pane_id}')

# Wait for shell to be ready in new pane
sleep 1

# Send using -l (literal) to prevent premature expansion
CMD="gemini -m gemini-3.1-pro-preview --sandbox false -y -p \"\$(cat $PROMPT_FILE)\" && echo ___GEMINI_DONE___ || echo ___GEMINI_FAILED___"
tmux send-keys -t "$PANE_ID" -l "$CMD"
tmux send-keys -t "$PANE_ID" Enter
```

Log: `[Design] user request → gemini worker (tmux pane $PANE_ID)`

## Step 6: Monitor & Wait

Poll the tmux pane to detect when Gemini finishes:

```bash
# Poll every 5 seconds, timeout after 300s (5 minutes)
TIMEOUT=300
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
  CAPTURE=$(tmux capture-pane -t "$PANE_ID" -p -S -10 2>/dev/null)
  if echo "$CAPTURE" | grep -q '___GEMINI_DONE___\|___GEMINI_FAILED___'; then
    break
  fi
  sleep 5
  ELAPSED=$((ELAPSED + 5))
done

# Clean up prompt file AFTER gemini finishes (not before!)
rm -f "$PROMPT_FILE"
```

While waiting, Opus can continue with other non-frontend tasks if the user has more work.

**Rate limit handling**: if Gemini returns 429/RESOURCE_EXHAUSTED:
- Check pane output: `tmux capture-pane -t "$PANE_ID" -p -S - | grep -i "rate\|429\|exhausted"`
- If gemini-3.1-pro-preview rate limited: retry with `gemini-3-flash-preview` (faster, less rate-limited)
- If both fail: kill pane, fall back to Opus
- gemini CLI may exit 0 even on rate limit — always verify file changes via `git diff`

If timeout: kill the pane and fall back to Opus.

## Step 7: Opus Validation

After Gemini finishes, review ALL changes:

```bash
git diff --stat
git diff
```

Review against this checklist:

| Check | Criteria |
|-------|----------|
| Syntax | Valid HTML/CSS/JSX for the target framework? |
| Anti-slop | No Inter/Roboto, no purple gradients, no generic layouts? |
| Accessibility | Semantic elements, contrast ratios, focus indicators, ARIA? |
| Responsive | Mobile-first, no fixed widths, no horizontal scroll potential? |
| Framework match | Uses project's CSS approach, not a different one? |
| Imports | All packages/fonts actually exist? No hallucinated dependencies? |
| Consistency | Matches existing design tokens/theme? |
| No damage | Did Gemini accidentally break non-UI files? |

If issues found: fix them directly in the current branch.

## Step 8: Merge & Cleanup

```bash
# If validation passed, merge back
git checkout -  # back to original branch
git merge gemini-design-*  # merge Gemini's work

# Pop stash if we stashed earlier
git stash pop 2>/dev/null

# Clean up tmux pane
tmux kill-pane -t "$PANE_ID" 2>/dev/null

# Clean up temp file
rm -f "$PROMPT_FILE"
```

Log: `[Design] gemini worker complete → opus-validated → merged to [branch]`

## Step 9: Report

Tell the user:
1. What Gemini changed (file list with brief descriptions)
2. What Opus fixed during validation (if anything)
3. Remind: "Check rendered output for visual verification — layout issues are silent"

## Fallback Behavior

| Failure | Action |
|---------|--------|
| Not in tmux | Tell user to start tmux, STOP |
| gemini CLI not found | Fall back to Opus with same anti-slop rules |
| gemini auth expired | Fall back to Opus, suggest `gemini auth login` |
| Timeout (300s) | Kill pane, fall back to Opus |
| Gemini output breaks things | `git checkout .` to revert, fall back to Opus |

All fallbacks → Opus generates with identical anti-slop design rules.
Log: `[Design] gemini [reason] → opus fallback`
