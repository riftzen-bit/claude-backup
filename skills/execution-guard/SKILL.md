---
name: execution-guard
description: Use for any coding task: fix bug, implement feature, update file, refactor, debug, investigate failure, add tests, run validators, review changes, or verify a repo. Enforces clarify → explore → route → TDD → verify → review for a non-programmer user.
---

# Execution Guard

Apply this workflow on coding tasks.

## 1. Clarify only what matters

- If desired behavior, scope, or acceptance criteria are unclear, ask concise product questions before editing
- Do not ask the user for technical implementation choices unless unavoidable
- Never guess missing behavior just to keep moving

## 2. Explore before editing

- Read the relevant files first
- Find existing patterns before introducing new ones
- Discover the repo's real validator commands from project config before coding

## 3. Route work by cost and skill

- `repo-scout` (haiku): search, inventory, conventions, validator discovery
- `planner` (sonnet): multi-file planning, risks, open questions
- `code-reviewer` (sonnet): post-edit review
- `validator` (sonnet): build, typecheck, lint, tests, coverage
- `security-reviewer` (opus): before commits or security-sensitive changes
- Keep Opus as orchestrator for ambiguity, architecture, and security-sensitive decisions

## 4. TDD is the default

- RED: write or update a failing test first when behavior changes
- GREEN: make the smallest change that passes
- REFACTOR: improve while keeping tests green
- If the repo has no test harness, state that clearly and use the closest available safety net

## 5. Verification is evidence, not vibes

- Run the repo's actual validators before claiming completion
- Record exact command, exit code, and key output for each check
- If a check is skipped, unavailable, or flaky, say so explicitly
- Never say "verified" because the code looks right

## 6. Review before handoff

- Re-read edited files
- Run `code-reviewer` after validators pass
- Before any commit, run `security-reviewer`

## 7. Honesty rules

- Separate facts from assumptions
- Trust filesystem and command output over memory
- If something is still uncertain or blocked, say that directly
