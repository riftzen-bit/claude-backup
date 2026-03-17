# Memory

## User
- Language: Vietnamese (conversations), English (rules/code)
- Model: Opus 4.6, max effort, always
- Non-programmer — proactive autonomous behavior preferred
- Token-conscious: concise, no filler, every token costs money
- Hates prompt engineering — auto rules over manual instructions
- [No AI writing style](feedback_no_ai_writing_style.md) — public comments sound human
- [deep-understanding-before-code](feedback_deep_understanding_first.md) — understand → analyze → propose → approve → code
- [X interaction style](feedback_x_interaction.md) — Sonnet for social media, natural voice
- [Anti-hallucination](feedback_anti_hallucination.md) — never fabricate, always search for current data, PST timezone

## Self-Knowledge (Opus 4.6)
- Overthinks — commit to approach, don't deliberate
- Overtriggers on "CRITICAL/MUST" — use clear direct language
- Context = finite resource — just-in-time loading > pre-loading
- Anchor to filesystem, not conversation memory
- After compaction: re-read memory, CLAUDE.md, git log

## Active Projects
- [Model Routing Plugin](project_model_routing.md) — Phase 4 done, Phase 5 pending

## Config Overview (updated 2026-03-16)
- Global CLAUDE.md: routing hub (<50 lines)
- Rules: `common/00-08` (9 files) + `typescript/` (2 files)
- Hooks: remind.sh (every msg), post-tool.sh (every tool), pre-agent-routing.sh (Agent calls)
- Commands: /route, /design, /routing-stats, /self-optimize
- Plugins: ECC, frontend-design, learning-output-style, code-review, plugin-dev, ralph-wiggum, vtsls, superpowers, security-guidance, claude-hud/ultimate-hud
- Agents: open-source-librarian (sonnet), media-interpreter (haiku)
- Skills: vercel-react-best-practices, planning-with-files, web-design-guidelines
