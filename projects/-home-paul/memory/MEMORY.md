# Memory

## User
- Language: Vietnamese (conversations), English (rules/code)
- Model policy: Opus leads ambiguity/architecture/security; cheaper specialists handle search, review, and validation
- Non-programmer — proactive autonomous behavior preferred
- Token-conscious: concise, no filler, every token costs money
- Hates prompt engineering — auto rules over manual instructions
- [No AI writing style](feedback_no_ai_writing_style.md) — public comments sound human
- [deep-understanding-before-code](feedback_deep_understanding_first.md) — understand → analyze → clarify if needed → then code
- [clarify + verify + route](feedback_clarify_verify_route.md) — ask when intent is unclear, split work by model, report validator evidence honestly
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
- [Model Routing Plugin](project_model_routing.md) — Phase 5 partially delivered
- [Parallel Agents Plugin](project_parallel_agents.md) — v1.0.0 installed, tested, ready for GitHub

## Config Overview (updated 2026-03-25, iteration 11 — full OmO adaptation)
- Rules: 454 lines across `common/00-10` — anti-patterns, anti-duplication, context window mgmt, explore-before-ask, notepad, auto-continue, 6-section delegation, 4-phase verification
- Agents: 562 lines across 7 agents — all upgraded with OmO-depth prompts (intent analysis, 4-phase verification, pragmatic minimalism, zero-error loop, gap analysis, date awareness, anti-pattern detection)
- Hooks: 803 lines across 8 hooks — per-message injection (6 sections: enforce + roster + routing + delegation + cross-tool + project + git + todo-continuation), per-tool injection (4-phase edit review, directory AGENTS.md context, hallucination guard, 6-section agent routing with anti-duplication), 8-section compaction recovery, notepad auto-init
- [OmO patterns adapted](reference_omo_patterns.md) — comprehensive 3-iteration adaptation from full codebase analysis
- Plugins (10), Agents (7), Skills (66+), Commands (5)
