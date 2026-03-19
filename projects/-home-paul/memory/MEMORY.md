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
- [Glow dot is AI](feedback_cursor_dot_is_ai.md) — glowing dot/orb effects with bloom/pulse look AI-generated, avoid
- [More AI patterns v2](feedback_more_ai_patterns.md) — numbered features, hero voids, eyebrow text, centered CTAs, punchy headlines
- [Left alignment + verify](feedback_left_alignment_verify.md) — content hugs left, right side empty void; verify visually before done
- [Creative layout](feedback_creative_layout.md) — stop picking template layouts, design unique layout per content like human designers

## Self-Knowledge (Opus 4.6)
- Overthinks — commit to approach, don't deliberate
- Overtriggers on "CRITICAL/MUST" — use clear direct language
- Context = finite resource — just-in-time loading > pre-loading
- Anchor to filesystem, not conversation memory
- After compaction: re-read memory, CLAUDE.md, git log

## Active Projects
- [Model Routing Plugin](project_model_routing.md) — Phase 4 done, Phase 5 pending

## Config Overview (updated 2026-03-19, iteration 5)
- Global CLAUDE.md: routing hub (49 lines)
- Enforcement: enforce.md (21 lines) injected EVERY message — HARD BLOCKS + AFTER CODE only
- Rules: `common/00-07` (8 files) + `typescript/` (2 files) — ~347 lines total
- Hooks (8 events): remind.sh, post-tool.sh, pre-agent-routing.sh, session-start.sh, post-compact.sh, subagent-stop.sh, ecc-observe.sh, PreCompact, Stop
- Commands: /route, /design (117 lines), /routing-stats, /self-optimize, /benchmark
- Plugins (8): ECC, frontend-design, learning-output-style, code-review, superpowers, security-guidance, claude-ultimate-hud, typescript-lsp
- Agents: open-source-librarian (sonnet, max_turns=15), media-interpreter (haiku, max_turns=5)
- Skills: anti-ai-design, vercel-react-best-practices, planning-with-files, web-design-guidelines, skill-factory, text-to-speech
- OpenCode: AGENTS.md (25 lines) + enforce.md + rules via instructions array
