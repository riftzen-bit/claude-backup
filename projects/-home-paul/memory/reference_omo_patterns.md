---
name: OmO patterns adapted
description: Deep adaptation from Oh My OpenAgent v3.11.0 codebase — 6-section delegation, 4-phase verification, notepad system, Prometheus planner, auto-continue, explore-before-ask, 8-section compaction
type: reference
---

Source: github.com/code-yeongyu/oh-my-openagent (SUL-1.0 license)
Codebase: 1,695 files, 45MB, ~160k LOC TypeScript, Bun runtime

## Iteration 1 (2026-03-24) — Surface patterns

1. **Structured delegation** (from Atlas 6-section) → simplified to 4-section
2. **Intent classification** (from Prometheus 7-type) → simplified to 5-type
3. **Search discipline** (from Explore agent) → repo-scout.md
4. **Cross-tool rules** → session-start.sh + remind.sh

## Iteration 2 (2026-03-25) — Deep codebase analysis + full adaptation

After cloning and analyzing entire OmO codebase with 6 parallel agents:

5. **6-section delegation** (from Atlas) → `08-agent-discipline.md` + `remind.sh` + `pre-write-guard.sh` + `enforce.md`
   - TASK / EXPECTED OUTCOME / SCOPE / MUST DO / MUST NOT DO / CONTEXT

6. **4-phase verification** (from Atlas verification protocol) → `post-tool.sh` + `10-auto-continue.md`
   - READ → CHECK → VERIFY → GATE

7. **Notepad system** (from `.sisyphus/notepads/`) → `09-notepad-system.md` + `session-start.sh`
   - `.claude/notepads/{task-name}/` with learnings.md, decisions.md, issues.md
   - Auto-created on session start, detected on compaction recovery

8. **Prometheus-style planner** (4-phase) → `planner.md`
   - Phase 0: Classify Intent
   - Phase 1: Silent Exploration (explore before asking)
   - Phase 2: Plan Generation with parallel waves

9. **Explore-before-ask** (from Prometheus "Two Kinds of Unknowns") → `10-auto-continue.md` + `enforce.md` + `planner.md`
   - Discoverable facts → EXPLORE first
   - Preferences/tradeoffs → ASK with 2-4 options

10. **Auto-continue** (from Atlas auto-continue policy) → `10-auto-continue.md` + `enforce.md`
    - No permission-seeking between clear steps
    - STOP only for errors or product-intent decisions

11. **8-section compaction recovery** (from OmO Compaction Context Injector) → `post-compact.sh`
    - Structured checklist: requests, goal, completed, remaining, active files, constraints, subagents, verification state
    - "RESUME, don't RESTART"

## OmO Features NOT Adapted (and why)

- **Hashline edit** — Claude Code Edit uses exact string matching; different but equivalent safety
- **Comment checker** — LLM-based Go binary; too heavy. Anti-AI rules cover this
- **Named mythology agents** — Branding, not substance
- **ultrawork keyword** — `/effort max` serves same purpose
- **OpenClaw notifications** — Discord/Telegram bridge; not needed currently
- **Boulder.json session tracking** — save-session/resume-session skills cover this
- **Category-based model routing** — Our 5-tier routing (haiku/sonnet/opus) is simpler and sufficient
- **Model-specific prompts** (Claude/GPT/Gemini variants) — We only use Claude; not needed
- **Sisyphus-Junior constrained worker** — Our subagent_type system handles this differently
- **Background agent circuit breakers** — Claude Code Agent tool handles timeouts
