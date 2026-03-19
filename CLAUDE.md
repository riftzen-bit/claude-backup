# Global Configuration Hub

## Identity
- Owner: Paul (non-programmer, Vietnamese speaker)
- Model: Opus 4.6, max effort, always
- Language: Vietnamese (conversation), English (code/rules)

## Configuration Map
All rules auto-loaded from `~/.claude/rules/`:
- `common/00-07`: Engineering mindset, workflow, code quality, testing, safety, production, self-optimization, model routing
- `typescript/`: TS-specific coding style, patterns

## Custom Agents (`~/.claude/agents/`)
- `open-source-librarian` (sonnet): Library research with GitHub permalinks + context7
- `media-interpreter` (haiku): Extract info from PDFs, images, diagrams

## Custom Skills (`~/.claude/skills/`)
- `anti-ai-design`: Auto-trigger frontend skill — AI fingerprint blacklist + curated alternatives + verification
- `vercel-react-best-practices`: 45 React/Next.js performance rules from Vercel
- `planning-with-files`: Manus-style persistent markdown planning
- `web-design-guidelines`: UI accessibility/design audit
- `skill-factory`: Generate production-ready skill files from templates
- `text-to-speech`: Multi-provider TTS (ElevenLabs, OpenAI, Google, fal.ai, edge-tts)

## Custom Commands (`~/.claude/commands/`)
- `/route`: Decompose task → dispatch to cheapest capable model
- `/design`: Dispatch UI tasks to Gemini tmux worker, Opus validates
- `/routing-stats`: Show model routing stats and cost savings
- `/self-optimize`: Deep audit all configuration
- `/benchmark`: Automated quality benchmark

## Enforcement
- `~/.claude/enforce.md` — injected into EVERY message via UserPromptSubmit hook
- SessionStart[compact] → re-injects enforce.md after compaction
- PostToolUse → self-review + hallucination detection
- PreToolUse → routing guard (Agent), ECC observation (*)
- PreCompact → save state | Stop → completion sound

## Memory
- Index: `~/.claude/projects/{project}/memory/MEMORY.md`
- Always read memory index at session start

## Key Behaviors
- Proactive, autonomous — handle everything end-to-end
- Zero hallucination — verify before stating, search when unsure
- Token efficient, never add AI attribution
- Never claim "done" without running verification
- After compaction: re-read memory, CLAUDE.md, git log
- Direct tools for simple tasks, agents for parallel work
