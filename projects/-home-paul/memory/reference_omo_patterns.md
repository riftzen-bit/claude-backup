---
name: OmO patterns adapted
description: Patterns adapted from Oh My OpenAgent v3.13.1 for Claude Code — structured delegation, intent classification, cross-tool rules, search discipline
type: reference
---

Source: github.com/code-yeongyu/oh-my-openagent (43k stars, SUL-1.0 license)
Installed in OpenCode at: `~/.local/share/mise/installs/node/22.22.0/lib/node_modules/oh-my-openagent/`
Config: `~/.config/opencode/oh-my-opencode.json`

## Adapted Patterns (2026-03-24)

1. **Structured agent delegation** (from Atlas) → rule `08-agent-discipline.md`
   - TASK / EXPECTED OUTCOME / SCOPE / CONTEXT format for subagent prompts

2. **Intent classification** (from Prometheus) → rule `08-agent-discipline.md` + `planner.md`
   - Trivial/Simple/Medium/Complex/Research classification before acting

3. **Search discipline** (from Explore agent) → `repo-scout.md`
   - Analyze intent before search, 3+ parallel tools, absolute paths, find ALL matches

4. **Cross-tool rules reader** → `session-start.sh` + rule `08-agent-discipline.md`
   - Reads .cursor/rules, .github/copilot-instructions.md, AGENTS.md, .windsurfrules, .clinerules

## OmO Features NOT Adapted (and why)

- **Hashline edit** — Claude Code's Edit tool already uses exact string matching; different mechanism but similar safety
- **Comment checker binary** — Uses LLM-based detection via Go binary; too heavy. Our anti-AI rules cover this
- **Named mythology agents** — Branding, not substance. Our agents already have clear roles
- **ultrawork keyword** — We have `/effort max` which serves the same purpose
- **init-deep** — Generates hierarchical AGENTS.md; could be a future skill if needed
- **Background agent depth/descendant limits** — Claude Code's Agent tool already handles this
