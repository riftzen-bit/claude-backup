---
name: Subagent Must Include All Rules
description: When dispatching agents, ALWAYS include TDD, design rules, verification, and testing requirements in the prompt. Agents don't inherit rules automatically.
type: feedback
---

When launching subagents, ALWAYS include these in the prompt:

1. **TDD**: "Write a failing test first, then implement, then verify test passes"
2. **Design**: "No cyan/purple glow, no neon colors, no AI-looking design. Use existing warm theme variables."
3. **Verification**: "Run `npx tsc --noEmit` and show output before finishing"
4. **Match patterns**: "Read 2-3 existing files of the same type to match conventions"
5. **No unnecessary changes**: "Only modify what's needed, don't add comments/docstrings to unchanged code"

**Why:** On 2026-03-11, all 4 dispatched agents skipped TDD and security checks because the prompts didn't mention these requirements. Agents are blank slates — they only know what you tell them.

**How to apply:** Before every `Agent` tool call, verify the prompt includes all 5 items above. Add a "Rules:" section at the end of every agent prompt.
