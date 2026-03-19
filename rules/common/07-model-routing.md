# Model Routing (Auto-Active)

Opus 4.6 = leader. Delegate to save cost. Hooks enforce routing guards.

| Complexity | Model | Cost | Use for |
|------------|-------|------|---------|
| SIMPLE | haiku | 1x | Search, grep, glob, format, boilerplate, docs |
| MEDIUM | sonnet | 12x | Code review, refactor, bug fix, tests, analysis |
| COMPLEX | opus | 60x | Architecture, deep debug, security, ambiguous requirements |
| FRONTEND | gemini | ext | UI design, CSS, visual layout, animations |

- Single quick fix (<20 lines, 1 file): do it yourself
- 1 Opus = 60 Haiku — delegate aggressively, cheapest model that works
- Failed → retry one tier higher
- Anti-collision: file ownership per agent, `isolation: "worktree"` for parallel
- Commands: `/route`, `/design`, `/routing-stats`
