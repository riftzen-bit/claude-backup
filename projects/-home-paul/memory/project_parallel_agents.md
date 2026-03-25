---
name: parallel-agents-plugin
description: Claude Code plugin for spawning parallel agents with automatic file conflict prevention via hooks
type: project
---

Parallel Agents plugin at `/home/paul/parallel-agents/`.

**Why:** Agent Teams feature is enabled but doesn't reliably prevent file conflicts between parallel agents. This plugin adds hook-based anti-collision protection.

**How to apply:**
- Source: TypeScript in `src/`, compiled to `dist/` via `tsc`
- Hooks: SubagentStart (inject rules), PreToolUse (block writes), PostToolUse (track), SubagentStop (release), TeammateIdle (re-kick with limit), SessionEnd (cleanup)
- Skill: `spawn-team` — guides team creation with file ownership rules
- Agents: `team-worker` (sonnet, focused subtask), `team-reviewer` (sonnet, read-only review)
- Tests: `npm test` — 25 tests (14 unit + 11 hook integration)
- Installed at: `~/.claude/plugins/cache/parallel-agents-local/parallel-agents/1.0.0/`
- Enabled in settings.json as `parallel-agents@parallel-agents-local`
- Session-scoped data prevents cross-session wipes (uses `CLAUDE_SESSION_ID` subdirs)
