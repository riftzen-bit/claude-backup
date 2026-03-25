# Agent Delegation & Intent Routing

## Structured Delegation

When delegating to subagents, structure prompts with relevant sections:

1. **TASK**: Quote exact requirement. Be specific.
2. **EXPECTED OUTCOME**: Files/behavior/output expected.
3. **SCOPE**: Files/areas to touch and NOT touch.
4. **CONTEXT**: Relevant conventions, decisions, gotchas from the codebase.

Skip sections that don't apply. A 3-line task doesn't need 4 sections.
Include TDD rules and verification commands when delegating coding work.

## Intent Classification

Classify before acting — adapt depth to complexity:

| Type | Signal | Approach |
|------|--------|----------|
| Trivial | Single file, <10 lines, clear fix | Do directly, no planning |
| Simple | 1-2 files, clear scope | 1-2 questions max, then execute |
| Medium | 3-5 files, scoped feature | Brief plan, validate approach, execute |
| Complex | 5+ files, architectural impact | Full plan with user review first |
| Research | Goal exists, path unclear | Investigate, propose options, then plan |

Default: Simple unless evidence says otherwise. Don't over-plan trivial work.

## Search Agent Discipline

When searching codebase (repo-scout, Explore, or direct Grep/Glob):
- Analyze intent before searching: what specifically needs to be found?
- Launch 3+ parallel searches on first action when scope is broad
- Return absolute paths with relevance reason
- Find ALL relevant matches, not just the first one
- If search results are insufficient, broaden with alternative terms

## Cross-Tool Project Context

When entering a repo, also check for instruction files from other AI tools:
- `.cursor/rules/` — Cursor rules (often contain project conventions)
- `.github/copilot-instructions.md` — GitHub Copilot instructions
- `.windsurfrules` — Windsurf rules
- `.clinerules` — Cline rules
- `AGENTS.md` — OpenCode/OmO agent instructions

These files often contain valuable project-specific context. Read them if they exist.
