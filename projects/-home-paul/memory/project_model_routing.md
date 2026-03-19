---
name: Model Routing Plugin
description: Multi-model orchestrator — Opus dispatches to Haiku/Sonnet/Opus/Gemini. Phase 4 done, Phase 5 pending (ECC plugin packaging).
type: project
created: 2026-03-14
updated: 2026-03-17
---

Multi-model routing integrated into Claude Code setup.

**Why:** Opus for everything wastes 60-80% cost. Simple tasks don't need deep reasoning.

**How to apply:** Route SIMPLE→Haiku, MEDIUM→Sonnet, COMPLEX→Opus, FRONTEND→Gemini tmux worker.

**Status:** Phase 1-4 done (2026-03-14). Phase 5 pending: package as ECC plugin.

**Key files:** rules/common/07-model-routing.md, hooks/remind.sh, hooks/pre-agent-routing.sh, commands/route.md, commands/design.md, commands/routing-stats.md

**Known issues:**
- gemini-3.1-pro-preview frequently rate-limited (429)
- gemini CLI may exit 0 on rate limit — always verify via git diff
