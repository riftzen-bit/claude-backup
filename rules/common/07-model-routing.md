# Model Routing (Auto-Active)

Opus 4.6 = orchestrator, not the default worker for everything. Delegate to save cost. Hooks enforce routing guards.

| Complexity | Model | Cost | Use for |
|------------|-------|------|---------|
| SIMPLE | haiku | 1x | Search, grep, glob, file inventory, validator discovery |
| MEDIUM | sonnet | 12x | Planning, code review, refactor, bug fix, tests, validation |
| COMPLEX | opus | 60x | Architecture, deep debug, security, ambiguous requirements |
| FRONTEND | gemini | ext | UI design, CSS, visual layout, animations — only after explicit user opt-in |

- Default specialists:
  - `repo-scout` = haiku
  - `planner` = sonnet
  - `code-reviewer` = sonnet
  - `validator` = sonnet
  - `security-reviewer` = opus
  - `open-source-librarian` = sonnet
  - `media-interpreter` = haiku
- Single quick fix (<20 lines, 1 file): do it yourself
- 1 Opus = 60 Haiku — delegate aggressively, cheapest model that works
- Do not keep search, review, and verification on Opus unless context sensitivity demands it
- Failed → retry one tier higher
- Anti-collision: file ownership per agent, `isolation: "worktree"` for parallel
- Commands: `/route`, `/design`, `/routing-stats`, `/self-optimize`, `/benchmark`
