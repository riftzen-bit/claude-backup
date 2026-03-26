# Development Workflow

## Before Writing Code

1. Orient: Read README, CLAUDE.md, 2-3 source files to absorb conventions
2. Re-read files if >5 tool calls since last read
3. Define scope — know what changes and what doesn't
4. If behavior or acceptance criteria are unclear, ask concise product questions before coding
5. Discover the repo's actual validator commands before coding
6. Explore before asking — most questions about the codebase are discoverable through search; only ask for product intent
7. Plan non-trivial tasks before coding

## Skill Usage

- `execution-guard`: default for coding/debugging/refactor/test tasks
- `anti-ai-design`: all frontend/UI work
- `planning-with-files`: long, research-heavy, or multi-phase tasks
- `vercel-react-best-practices`: React/Next.js changes

Manual on-demand skills:
- `web-design-guidelines`: UI/accessibility/design audits
- `skill-factory`: create new Claude skills
- `text-to-speech`: generate speech audio

## Agent Usage

| Agent | When |
|-------|------|
| repo-scout | File discovery, pattern matching, validator discovery |
| planner | Complex features, refactoring, planning with open questions |
| code-reviewer | After writing/modifying code |
| security-reviewer | Before commits |
| validator | Build/typecheck/lint/tests with exact evidence |
| open-source-librarian | Library research, OSS source code |
| media-interpreter | PDFs, images, diagrams |

## After Writing Code

1. Re-read edited files to confirm changes applied
2. Run `validator` or the same checks directly: build, type check, lint, tests — fix until clean (max 10 iterations)
3. Run `code-reviewer` after validators pass
4. Before any commit: run `security-reviewer`
5. Commit: `<type>: <description>` (feat, fix, refactor, docs, test, chore)

## Scope Discipline

- "Does this directly solve the request?" — if no, don't do it
- Avoid runaway yak-shaving; if 3+ unrelated detours appear, re-scope consciously instead of drifting
- If tool calls or fix loops are growing without progress, explain the blocker and ask the user; do not use the limit as an excuse to skip required verification
- If a validator or acceptance criterion remains unmet, report it honestly instead of implying completion

## Anti-Duplication

Before starting work, check if it was already done:
- Search for existing implementations before writing new code
- Check git log for recent related changes
- If delegating to subagents: include learnings from previous tasks in CONTEXT section
- If multi-step work: read notepad before each new task

## Context Management

- Trust filesystem over conversation memory
- After compaction: re-read memory, CLAUDE.md, git log
- Parallel tool calls for independent operations
