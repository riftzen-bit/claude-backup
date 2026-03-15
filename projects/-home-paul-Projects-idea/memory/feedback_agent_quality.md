---
name: Agent dispatch quality and design feedback
description: Launch more agents, write better prompts, fix design, don't ship half-done
type: feedback
---

Paul's feedback on Phase 1-8 build:
- Components exist in isolation but NOT wired into the main app — useless
- Design is ugly (lines in search bar, no polish)
- No welcome/onboarding screen
- Missing thousands of features — shipped skeleton, not product
- Agent dispatching was too conservative — should launch 10+ agents in parallel
- Prompts for subagents were too generic — need detailed, high-quality prompts with specific design requirements

**Why:** Paul expected a polished, working app — not isolated components with placeholder text. The "done" claim was premature.

**How to apply:**
1. Launch many agents in parallel (10+) when tasks don't share files
2. Write detailed prompts with exact design requirements, color values, spacing, animations
3. Always integrate components into the main app — isolated components = not shipped
4. Include design polish in every task — no "placeholder" text, no ugly defaults
5. Welcome screen and onboarding are table stakes, not optional
6. Never claim "done" until the app actually works end-to-end as a user would experience it
