# Model Routing (Auto-Active)

Opus 4.6 is ALWAYS the leader. Route work to cheaper models to save cost and parallelize.

## When to Route

| Message Type | Action |
|-------------|--------|
| Code changes (write/edit/refactor) | Route — show plan, auto-dispatch |
| Multi-file research/analysis | Route — dispatch haiku for search |
| Code review (after writing code) | Route — dispatch sonnet |
| Security review (before commits) | Route — dispatch sonnet |
| Frontend UI work | Route — dispatch gemini |
| Simple question or confirmation | Answer directly — no routing |
| Single quick fix (<20 lines, 1 file) | Do it yourself — routing overhead > benefit |

## Auto-Dispatch (no confirmation needed)

For clear-cut routing decisions, dispatch immediately and log:
- `[Route] search for X across codebase → haiku (simple search)`
- `[Route] review code changes → sonnet (code review)`
- `[Route] run security scan → sonnet (security review)`

## Ask Before Dispatch (confirmation needed)

- Ambiguous tasks with multiple valid approaches
- Opus subagent dispatch (expensive — $15/M input)
- Tasks touching >5 files (need anti-collision planning)
- Destructive operations (delete, force-push, drop)

## Routing Table

| Complexity | Model | Cost | Use for |
|------------|-------|------|---------|
| SIMPLE | haiku | 1x | Search, grep, glob, format, boilerplate, docs |
| MEDIUM | sonnet | 12x | Code review, refactor, bug fix, tests, analysis |
| COMPLEX | opus | 60x | Architecture, deep debug, security, ambiguous requirements |
| FRONTEND | gemini | ext | UI design, CSS, visual layout, animations |

## Frontend Auto-Detection

Auto-dispatch to Gemini when the request matches frontend patterns:
- Keywords: design, redesign, style, styling, UI, UX, layout, CSS, Tailwind, animation, theme, color, typography, font, landing page, component visual, responsive
- File types: .tsx/.jsx components, .css/.scss, tailwind.config.*, HTML templates
- Use `/design` command for explicit Gemini dispatch with full project context
- Gemini runs with `--sandbox false` for filesystem access

## Dispatch Methods

- Haiku/Sonnet/Opus: Agent tool with `model: "haiku"` / `model: "sonnet"` / `model: "opus"`
- Gemini: real tmux worker via `/design` command (splits pane, Gemini edits files directly)
- Models: gemini-3.1-pro-preview (primary) → gemini-3-flash-preview (fallback) → Opus (last resort)
- Gemini requires active tmux session — if not in tmux, fall back to Opus
- Opus reviews ALL Gemini changes via `git diff` before keeping — never apply unvalidated

## Anti-Collision (parallel agents)

1. Assign file ownership per agent — no two agents touch the same file
2. Use `isolation: "worktree"` for all parallel dispatches
3. If file overlap → run sequentially, not parallel
4. Merge in declared order after completion

## Routing Plan Format

```
| # | Subtask | Model | Files (owned) | Reason |
|---|---------|-------|---------------|--------|
| 1 | ... | haiku | src/utils.ts | ... |
| 2 | ... | sonnet | src/auth.ts | ... |

No overlap. Auto-dispatching.
```

## Cost Rules

- 1 Opus call = 60 Haiku calls — delegate aggressively for simple work
- Prefer cheapest model that can reliably complete the task
- When uncertain about complexity: default one tier up
- Failed task → retry one tier higher

## Commands

- `/route` — full orchestrator for complex multi-step tasks
- `/design` — dispatch frontend/UI tasks to Gemini with project context
- `/routing-stats` — cost dashboard for current session
