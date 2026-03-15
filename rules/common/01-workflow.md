# Development Workflow

## Before Writing Code

1. **Orient**: Read README, CLAUDE.md, docs/, and 2-3 existing source files to absorb conventions
2. **Read full files** before editing — never edit based on memory of what a file "probably" contains
3. **Re-read files** if >5 tool calls have passed since last read (memory degrades)
4. **Ask** when requirements are ambiguous — one good question beats 100 lines of wrong code
5. **Verify** all imports/packages exist on their registry before using them
6. **Define scope** — know what you're changing and what you're not
7. **Plan** non-trivial tasks before coding

## Agent Usage

| Agent | When |
|-------|------|
| planner | Complex features, refactoring |
| architect | System design decisions |
| tdd-guide | New features, bug fixes |
| code-reviewer | After writing/modifying code |
| security-reviewer | Before commits |
| build-error-resolver | Build failures |
| open-source-librarian | Library research, OSS source code, GitHub permalinks |
| media-interpreter | Extract info from PDFs, images, diagrams |

Use agents for parallel/isolated work. Use Grep/Glob/Read directly for simple searches.

## TDD Cycle

RED (write failing test) → GREEN (minimal code to pass) → REFACTOR. No exceptions.

## After Writing Code

1. Run build, type check, lint, tests — fix until zero errors (max 10 iterations)
2. **Verify edits applied**: re-read the file or show actual output proving it works
3. Never say "done" or "fixed" without running verification
4. If verification fails, say so honestly — never claim partial success as success
5. Commit with conventional format: `<type>: <description>` (feat, fix, refactor, docs, test, chore)

## Scope Discipline

- Before every change: "does this directly solve the request?" If no, don't do it
- Max 3 steps of yak shaving from original request
- Max 50 tool calls per task, max 10 fix iterations
- If hitting limits: stop, summarize progress, ask user

## Context Management

- Trust filesystem state over conversation memory
- When confused: run `git status`, `git log --oneline -10`, read key files
- Store decisions in files (memory/, progress.txt), not just conversation
- After compaction: re-read memory files, CLAUDE.md, git log to re-orient

## Token Efficiency

- Lead with the answer, skip filler words and preamble
- Don't restate what the user said, don't narrate tool calls
- Use parallel tool calls for independent operations
- One targeted search beats three broad searches
