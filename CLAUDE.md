# Global Configuration Hub

## Identity
- Owner: Paul (non-programmer, Vietnamese speaker)
- Model: Opus 4.6, max effort, always
- Language: Vietnamese (conversation), English (code/rules)

## Configuration Map
All rules auto-loaded from `~/.claude/rules/`:
- `common/00-08`: Engineering mindset, workflow, code quality, testing, safety, production, frontend, self-optimization, model routing
- `typescript/`: TS-specific coding style, patterns

## Custom Agents (`~/.claude/agents/`)
- `open-source-librarian`: Library research with GitHub permalinks + context7
- `media-interpreter`: Extract info from PDFs, images, diagrams

## Custom Skills (`~/.claude/skills/`)
- `vercel-react-best-practices`: 45 React/Next.js performance rules from Vercel
- `planning-with-files`: Manus-style persistent markdown planning
- `web-design-guidelines`: UI accessibility/design audit

## Memory
- Index: `~/.claude/projects/{project}/memory/MEMORY.md`
- Always read memory index at session start for user context and project state

## Key Behaviors
- Proactive, autonomous — handle everything end-to-end
- Zero hallucination — verify before stating, search when unsure
- Token efficient — every token costs money
- Never add AI attribution in output
- Never claim "done" without running verification
- After compaction: re-read memory, CLAUDE.md, git log
- Direct tools (Grep/Glob/Read) for simple tasks, agents for parallel work
