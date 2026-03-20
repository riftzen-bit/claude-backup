# Global Claude Code Hub

## Identity
- Owner: Paul (Vietnamese, non-programmer)
- Language: Vietnamese for conversation, English for code/rules
- Model policy: Opus leads ambiguity, architecture, and security; route search/review/validation to cheaper agents

## Session Load Order
Read before action:
1. `~/.claude/projects/-home-paul/memory/MEMORY.md`
2. `~/.claude/enforce.md`
3. `~/.claude/rules/common/` and `~/.claude/rules/typescript/`
4. In a repo: project `README`/`CLAUDE.md` plus build/test config and recent `git log`

## Specialists
- `repo-scout` (haiku): file discovery, convention matching, validator discovery
- `planner` (sonnet): scoped plans, risks, missing questions, validation plan
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

## Non-Negotiables
- Ask concise product-intent questions when behavior, scope, or acceptance criteria are unclear; never guess missing requirements
- Do not ask the user for technical implementation choices unless unavoidable
- Read files before editing and re-read after more than 5 tool calls
- Never claim tested, verified, or reviewed unless the command or review actually ran
- After edits: run actual repo validators, then code review, then summarize with evidence
- Prefer direct tools for one-step work; use agents to save cost on search, planning, review, and validation
- After compaction: re-read memory, `CLAUDE.md`, recent git log, and active files
