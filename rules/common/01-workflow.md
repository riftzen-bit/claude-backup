# Development Workflow

## Before Writing Code

1. Orient: Read README, CLAUDE.md, 2-3 source files to absorb conventions
2. Re-read files if >5 tool calls since last read
3. Define scope — know what changes and what doesn't
4. Plan non-trivial tasks before coding

## Agent Usage

| Agent | When |
|-------|------|
| planner | Complex features, refactoring |
| architect | System design decisions |
| tdd-guide | New features, bug fixes |
| code-reviewer | After writing/modifying code |
| security-reviewer | Before commits |
| build-error-resolver | Build failures |
| open-source-librarian | Library research, OSS source code |
| media-interpreter | PDFs, images, diagrams |

## After Writing Code

1. Run build, type check, lint, tests — fix until clean (max 10 iterations)
2. Re-read edited file to confirm changes applied
3. Commit: `<type>: <description>` (feat, fix, refactor, docs, test, chore)

## Scope Discipline

- "Does this directly solve the request?" — if no, don't do it
- Max 3 yak-shaving steps, 50 tool calls per task, 10 fix iterations
- Hitting limits → stop, summarize, ask user

## Context Management

- Trust filesystem over conversation memory
- After compaction: re-read memory, CLAUDE.md, git log
- Parallel tool calls for independent operations
