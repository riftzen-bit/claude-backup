---
name: Model Routing Plugin
description: Multi-model orchestrator for Claude Code - Opus leader dispatches to Haiku/Sonnet/Opus/Gemini with anti-collision for parallel agents
type: project
---

Building a multi-model routing plugin integrated into Claude Code.

**Architecture:** Opus 4.6 acts as leader/orchestrator, classifies tasks, dispatches to cheapest capable model. Anthropic models via Agent tool, Gemini via real tmux worker.

**Why:** Using Opus for everything wastes 60-80% cost. Simple tasks don't need deep reasoning. Gemini excels at frontend visual design.

**How to apply:** Route SIMPLE→Haiku, MEDIUM→Sonnet, COMPLEX→Opus, FRONTEND→Gemini. Auto-escalate on failure. Anti-collision via file partitioning + worktree isolation.

**Phase Plan:**
1. Phase 1 (DONE): Router Rule + Model Map + Hook injection
2. Phase 2 (DONE): Orchestrator Skill `/route` + Cost tracking `/routing-stats`
3. Phase 3 (DONE): Stats dashboard command
4. Phase 3.5 (DONE): Anti-collision (file partitioning, worktree isolation) + Gemini integration
5. Phase 3.6 (DONE 2026-03-14): Smart Routing Redesign — fix routing skip problem
6. Phase 4 (DONE 2026-03-14): Real Gemini tmux Worker
7. Phase 5: Package as ECC plugin for community

**Phase 4 changes (2026-03-14): Gemini Real tmux Worker**
- Replaced old `timeout 180 gemini -p "..."` Bash dispatch with real tmux worker
- Gemini now runs in split tmux pane with `--sandbox false -y` (filesystem access + auto-approve)
- Gemini edits files directly, Opus validates via `git diff` before keeping
- Git safety net: stash + branch before Gemini touches files, merge/revert after
- Models: gemini-3.1-pro-preview (primary) → gemini-3-flash-preview (fallback) → Opus
- `claude` alias → `claude-tmux` wrapper (auto-launch tmux session "Work")
- Wrapper in `~/.local/bin/claude-tmux` — safe from omarchy updates
- Tested: tmux split/send-keys/capture works, Gemini file editing confirmed with gemini-2.5-pro
- Known: gemini-3.1-pro-preview frequently rate-limited (429 MODEL_CAPACITY_EXHAUSTED)
- Known: gemini CLI may exit 0 on rate limit — always verify changes via git diff

**Files:**
- `~/.claude/rules/common/08-model-routing.md` — smart conditional routing rule (every session)
- `~/.claude/hooks/remind.sh` — routing-focused enforcement hook (every message)
- `~/.claude/hooks/pre-agent-routing.sh` — routing guard + collision check (every Agent call)
- `~/.claude/commands/route.md` — `/route` orchestrator skill
- `~/.claude/commands/design.md` — `/design` real Gemini tmux worker (9-step workflow)
- `~/.claude/commands/routing-stats.md` — `/routing-stats` cost dashboard
- `~/.local/bin/claude-tmux` — auto-tmux wrapper for claude (omarchy-safe)

**OMC Research (2026-03-14):**
Studied oh-my-claudecode (9.7k stars) deeply. Key findings:
- Their tmux approach is over-engineered (400KB, file-based JSONL messaging, retry Enter 6x)
- Our approach: simpler, uses git diff for communication instead of inbox/outbox
- Patterns worth stealing later: Continuation Enforcement, Same-failure 3x exit, Critic agent pre-commitment predictions, Ralph PRD pattern, Trace/Investigation agent
