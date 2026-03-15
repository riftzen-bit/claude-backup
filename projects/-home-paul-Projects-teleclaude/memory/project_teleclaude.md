---
name: teleclaude-project
description: TeleClaude - open-source Telegram bot for remote Claude Code control. TypeScript/Node.js, grammY, modular architecture.
type: project
---

TeleClaude is an open-source tool that enables remote control of Claude Code CLI via Telegram bot.

**Why:** Users can control Claude Code from their phone instead of sitting at the computer. Inspired by OpenClaw's architecture.

**How to apply:**
- Spec: docs/superpowers/specs/2026-03-12-teleclaude-design.md
- Plan: docs/superpowers/plans/2026-03-12-teleclaude-implementation.md
- Architecture: 3-layer modular (Session Manager + Gateway + Channel Adapter)
- Tech: TypeScript, Node.js >=20, pnpm, grammY, Zod, pino, Vitest, tsup
- Key features: multi-session, pairing auth, streaming responses, permission approve/deny, hybrid process management
- Claude Code interaction: `claude -p --output-format stream-json --input-format stream-json --verbose --session-id <uuid>`
- Must unset CLAUDECODE env var when spawning nested Claude Code processes
