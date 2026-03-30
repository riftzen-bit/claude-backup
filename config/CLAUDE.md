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

## Testing
TDD enforced by hooks (tdd-gate.sh). Full rules in `rules/common/03-testing.md`.

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
