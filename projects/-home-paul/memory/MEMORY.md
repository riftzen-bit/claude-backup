# Memory

## User Preferences
- Language: Vietnamese (conversations), English (rules/code)
- Model: Opus 4.6 with max effort (always)
- Rules in ENGLISH for best Claude comprehension
- Proactive, autonomous behavior preferred
- NEVER add AI attribution lines in PRs, commits, or output
- [No AI writing style](feedback_no_ai_writing_style.md) — public comments must sound human, no bold headers/bullet lists/corporate tone
- Token efficiency: be concise, no filler, user pays per token
- Always READ before acting — never guess, never hallucinate
- Direct tools (Grep/Glob/Read) for simple tasks, agents only for complex parallel work
- Hates writing long prompts — set up auto rules instead of requiring prompt engineering
- Frontend design: anti-slop rules baked into 06-frontend.md, auto-active every conversation
- No need to trigger frontend-design skill manually — core principles already in rules
- **Auto-inject rule**: [deep-understanding-before-code](feedback_deep_understanding_first.md) — understand codebase → multi-option analysis → propose plan → get approval → then code
- [X interaction style](feedback_x_interaction.md) — use Sonnet for social media, 100% natural voice, continuous until cancelled

## Self-Improvement (from Anthropic docs, 2026-03-11)
- Opus 4.6 overthinks — commit to approach, don't deliberate
- Opus 4.6 overtriggers on "CRITICAL/MUST" language — use clear direct language instead
- Context = finite resource with diminishing returns ("context rot")
- Just-in-time loading > pre-loading all context
- Never say "done/fixed" without running verification
- Re-read files before editing if >5 tool calls since last read
- Anchor to filesystem (git status, actual files) not conversation memory
- After compaction: re-read memory files, CLAUDE.md, git log to re-orient

## Global Configuration (updated 2026-03-13)

### Global CLAUDE.md: `~/.claude/CLAUDE.md` (routing hub, <50 lines)
### Global Rules: `~/.claude/rules/common/` — 9 files
| File | Content |
|------|---------|
| `00-mandatory-mindset.md` | Always-on: understand → analyze → propose → approve |
| `01-workflow.md` | Dev lifecycle, agents, scope, context mgmt, token efficiency |
| `02-code-quality.md` | Codebase-first, simplicity, immutability, conventions |
| `03-testing.md` | TDD RED/GREEN/REFACTOR, anti-vibe-testing, zero-error loop |
| `04-safety.md` | Security, verify imports, dependencies, data correctness |
| `05-production.md` | Performance, resilience, concurrency, cleanup, platform |
| `06-frontend.md` | Anti-slop design (auto-active), CSS, accessibility, responsive |
| `07-self-optimization.md` | **Auto-active**: Reflect→Abstract→Write loop, promotion thresholds, config health checks, feedback integration, context budget discipline |
| `08-model-routing.md` | **Auto-active**: Opus orchestrator routes SIMPLE→Haiku, MEDIUM→Sonnet, COMPLEX→Opus, FRONTEND→Gemini tmux worker |

### TypeScript Rules (5 files): `~/.claude/rules/typescript/`
### Command: `/self-optimize` — deep audit of ALL config (on-demand)

### Auto-Inject Mechanisms (100% deterministic):
1. `~/.claude/CLAUDE.md` — loaded every session, every project
2. `~/.claude/rules/common/*.md` — loaded every session, every project
3. `hooks/remind.sh` (UserPromptSubmit) — fired every message
4. `hooks/post-tool.sh` (PostToolUse) — fired every tool use

## Active Projects
- [Model Routing Plugin](project_model_routing.md) — Opus orchestrator + Haiku/Sonnet/Gemini tmux worker, Phase 4 done

## Installed Plugins (updated 2026-03-15)
- everything-claude-code (ECC) — agents, skills, instincts
- frontend-design — anti-slop UI generation
- learning-output-style — educational mode
- code-review — PR/code review
- plugin-dev — plugin creation workflow
- ralph-wiggum — iterative loop (ralph-loop)
- vtsls — TypeScript LSP (ENABLE_LSP_TOOLS=1 in .bashrc)
- superpowers — brainstorming, plans, TDD, debugging skills
- security-guidance — security patterns
- claude-hud / claude-ultimate-hud — status line

## Custom Agents (`~/.claude/agents/`)
- open-source-librarian — library research, GitHub permalinks, context7
- media-interpreter — PDFs, images, diagrams extraction

## Custom Skills (`~/.claude/skills/`)
- vercel-react-best-practices — 45 React/Next.js perf rules
- planning-with-files — Manus-style persistent planning
- web-design-guidelines — UI/UX audit

## Key Stats
- AI code: 1.7x bugs, 2.29x concurrency bugs, 8x excessive I/O
- 62% security flaws, 21.7% hallucinated packages
- AI tests: 90% coverage but 4% actual bug detection
- 94.8% sites fail WCAG — AI makes it worse
