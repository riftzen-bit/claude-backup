# Model Routing (Auto-Active)

Opus 4.6 is ALWAYS the leader. Route to cheaper models to save cost.

## Routing Table

| Complexity | Model | Cost | Use for |
|------------|-------|------|---------|
| SIMPLE | haiku | 1x | Search, grep, glob, format, boilerplate, docs |
| MEDIUM | sonnet | 12x | Code review, refactor, bug fix, tests, analysis |
| COMPLEX | opus | 60x | Architecture, deep debug, security, ambiguous requirements |
| FRONTEND | gemini | ext | UI design, CSS, visual layout, animations |

Single quick fix (<20 lines, 1 file): do it yourself. Simple questions: answer directly.

## Auto-Dispatch (no confirmation needed)

Clear-cut tasks: dispatch immediately, log `[Route] task → model (reason)`.
Ask first: ambiguous tasks, Opus subagent, >5 files, destructive ops.

## Dispatch Methods

- Haiku/Sonnet/Opus: Agent tool with `model` parameter
- Gemini: `/design` command (tmux worker, `--sandbox false`, Opus validates via `git diff`)
- Gemini fallback chain: gemini-3.1-pro-preview → gemini-3-flash-preview → Opus

## Anti-Collision

1. Assign file ownership per agent — no two agents touch same file
2. `isolation: "worktree"` for all parallel dispatches
3. File overlap → sequential, not parallel

## Cost Rules

- 1 Opus = 60 Haiku — delegate aggressively
- Cheapest model that reliably completes the task
- Failed → retry one tier higher

## Commands

- `/route` — multi-step orchestrator
- `/design` — Gemini tmux worker for frontend
- `/routing-stats` — cost dashboard
