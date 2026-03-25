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

## Config Overview (updated 2026-03-25, iteration 9)
- Global CLAUDE.md: concise routing + execution policy hub
- Enforcement: OmO-style injection at every touchpoint — `remind.sh` (per-message: enforce + agents + routing + delegation + cross-tool + project + git), `pre-write-guard.sh` (per-tool: discipline for read, full guard for mutate, routing for agent), `post-tool.sh` (per-tool: review for edit, hallucination for bash, verify for agent)
- Rules: `common/00-08` + `typescript/` — 08 = agent discipline (structured delegation, intent classification, cross-tool rules)
- Hooks: 7 event keys / 11 actions — `remind.sh`, `pre-write-guard.sh`, `post-tool.sh`, `notify.sh`, `pre-agent-routing.sh`, `session-start.sh`, `post-compact.sh`, `subagent-stop.sh`, `ecc-observe.sh`, plus inline `PreCompact` and `Stop`
- Auto-cleanup: session-start.sh auto-purges stale session IDs (7d), routing logs (14d), security state files, cross-rules cache (1d), plugin .sh permissions (workaround #20432)
- Commands: `/route`, `/design`, `/routing-stats`, `/self-optimize`, `/benchmark`
- Enabled plugins (10): everything-claude-code, frontend-design, code-review, superpowers, security-guidance, claude-ultimate-hud, typescript-lsp, vtsls, parallel-agents, ralph-loop
- Learning plugin disabled: it conflicted with Paul's end-to-end workflow and added token-heavy teaching prompts
- ECC observe disabled by default: requires explicit opt-in and a pinned observer path
- Agents: repo-scout, planner, code-reviewer, validator, security-reviewer, open-source-librarian, media-interpreter
- Skills (66 total): core auto = execution-guard, anti-ai-design, vercel-react-best-practices, planning-with-files; manual = web-design-guidelines, skill-factory, text-to-speech; Anthropic official = pdf, docx, xlsx, pptx, doc-coauthoring, canvas-design, web-artifacts-builder, brand-guidelines, algorithmic-art, theme-factory, mcp-builder, webapp-testing; community = deep-research; marketing (33 skills from coreyhaines31); SEO (13 skills from AgriciDaniel)
- Doc tools venv: `/home/paul/.local/share/doc-tools/` (pypdf, markitdown); system: pandoc 3.5, LibreOffice 26.2
- Env: `CLAUDE_CODE_NEW_INIT=1` enabled (experimental /init for new projects)
- OpenCode: AGENTS.md + enforce.md + rules via instructions array
- [OmO patterns adapted](reference_omo_patterns.md) — structured delegation, intent classification, cross-tool rules, search discipline from Oh My OpenAgent
