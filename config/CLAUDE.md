# Claude Code Configuration Hub

## Identity
- Owner: [Your name]
- Language: [Your language] for conversation, English for code/rules
- Model policy: Opus leads ambiguity, architecture, and security; route search/review/validation to cheaper agents

## Session Load Order
Read before action:
1. `~/.claude/enforce.md`
2. `~/.claude/rules/common/` and `~/.claude/rules/typescript/`
3. In a repo: project `README`/`CLAUDE.md` plus build/test config and recent `git log`
4. Cross-tool files if detected: `.cursor/rules/`, `.github/copilot-instructions.md`, `AGENTS.md`, `.windsurfrules`

## Specialists
- `repo-scout` (haiku): file discovery, convention matching, validator discovery, cross-tool rules
- `planner` (sonnet): intent classification, scoped plans, risks, validation plan
- `code-reviewer` (sonnet): review changed files/diffs after edits
- `validator` (sonnet): run build/typecheck/lint/tests with exact evidence
- `security-reviewer` (opus): review pending changes for secrets, unsafe defaults, and commit-time risks
- `open-source-librarian` (sonnet): OSS/docs/source research
- `media-interpreter` (haiku): PDFs, images, screenshots, diagrams

## Auto Skills
- `execution-guard`: coding tasks, honest verification, routing discipline
- `anti-ai-design`: all UI/design work
- `vercel-react-best-practices`: React/Next.js changes
- `planning-with-files`: long or research-heavy tasks

## Manual Skills
- `web-design-guidelines`: UI/accessibility/design audits
- `skill-factory`: generate new Claude skills from templates
- `text-to-speech`: generate speech audio from text

## Commands
- `/route`, `/design`, `/routing-stats`, `/self-optimize`, `/benchmark`

## MANDATORY Testing Protocol

### The Iron Law
Every source file MUST have a corresponding test file. No exceptions. No "later."
Tests are written FIRST (TDD), not after. The boulder never stops.

### TDD Cycle (RED -> GREEN -> REFACTOR)
1. **RED**: Write a failing test describing desired behavior
2. **GREEN**: Write MINIMUM code to pass the test
3. **REFACTOR**: Clean up while keeping tests green
4. **REPEAT** for every function, method, and code path

### Required Test Categories (write ALL — not optional)
| Category | What to test |
|----------|-------------|
| Happy path | Normal inputs -> expected outputs (3+ variations) |
| Edge cases | Empty, null, undefined, zero, NaN, max values, unicode, emojis |
| Error handling | Invalid inputs throw/return proper errors with correct types |
| Boundary | Off-by-one, min/max, overflow, timeout |
| Security | SQL/XSS/command injection, auth bypass, path traversal |
| Integration | Component interactions, API contracts |
| Async/Race | Concurrent access, promise rejection, timeout |
| State | State transitions, side effects, cleanup |
| Regression | Exact scenario that caused a bug |

### Minimum Requirements
- 5+ test cases per exported function/method
- 3+ edge case tests per function
- 100% coverage of error paths
- 100% coverage of public API surface
- Mock external deps, test real logic
- Test BOTH success AND failure scenarios
- Use realistic test data, not "foo"/"bar"
- Coverage: 80%+ overall, 100% new code

### Completion Gate
Before claiming "done", ALL must be true:
- [ ] Every modified source file has a test file
- [ ] Every new function has 5+ test cases covering ALL 9 categories
- [ ] Edge cases covered (null, empty, boundary, unicode, overflow)
- [ ] Error paths have explicit tests with correct error types
- [ ] Security-sensitive code has injection tests
- [ ] Tests passing (show actual output)
- [ ] No skipped/disabled/TODO tests
- [ ] Build, lint, typecheck all pass

## Non-Negotiables
- Ask concise product-intent questions when behavior, scope, or acceptance criteria are unclear; never guess missing requirements
- Do not ask the user for technical implementation choices unless unavoidable
- Read files before editing and re-read after more than 5 tool calls
- Never claim tested, verified, or reviewed unless the command or review actually ran
- After edits: run actual repo validators, then code review, then summarize with evidence
- Prefer direct tools for one-step work; use agents to save cost on search, planning, review, and validation
- After compaction: re-read `CLAUDE.md`, recent git log, and active files
- NEVER skip writing tests. Tests are mandatory, not optional. They are part of the definition of "done."
- NEVER truncate, abbreviate, or give partial answers. Complete implementations only.
- NEVER write "etc.", "...", "TODO", or "implement later" — write the full code.
- Search the codebase THOROUGHLY before writing any code (3+ queries minimum).
- Analyze 3+ alternatives before any implementation decision.
