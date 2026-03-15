# Self-Optimization Protocol (Auto-Active Every Session)

## Continuous Improvement Loop

After every significant task completion, run this cycle:
1. **Reflect**: What went wrong? What was unexpectedly hard? What worked perfectly?
2. **Abstract**: Extract the general pattern from the specific incident
3. **Write**: Update the appropriate file — rules/, memory/, skills/, or CLAUDE.md

## Promotion Thresholds

- Memory learning influences behavior 2+ times → promote to `~/.claude/rules/`
- Rule exceeds 50 lines on one topic → split into rule + reference doc in project
- Workflow succeeds 3+ times → create a skill from it
- Memory reaches 30+ entries → consolidate themes, archive old entries

## Configuration Health Checks

When starting a session in any project, silently verify:
- CLAUDE.md exists and is under 150 lines (project) or 50 lines (global)
- Rules total under 800 lines across all files
- No duplicate content between CLAUDE.md, rules, and memory
- Memory files are not stale (check dates vs current date)

If any check fails, note it and fix during natural workflow — do not interrupt user.

## Feedback Integration

When the user corrects your approach:
1. Save as feedback memory immediately (type: feedback)
2. Include WHY the feedback was given and HOW TO APPLY it
3. Check if feedback contradicts any existing rule — update rule if needed
4. Never make the same mistake twice

## Session-End Awareness

Before ending any session, consider:
- Were new patterns discovered? → Update appropriate file
- Were existing rules violated? → Strengthen the rule
- Were skills suboptimal? → Add improvement notes to skill
- Was context management efficient? → Note what to change in memory

## Context Budget Discipline

- Always-loaded config (CLAUDE.md + rules + hooks) should consume <15% of context window
- MCP servers are token-expensive — each tool description loads into context
- Use reference files (lazy-loaded) over CLAUDE.md (always-loaded) for detailed content
- Sub-agents for data-heavy operations — keep main thread clean
- Compact at 60% context usage with specific retention instructions

## Anti-Degradation

- Every rule must be concrete and verifiable (not "try to..." or "strive for...")
- Every line in config must pass: "Would removing this cause specific mistakes?"
- No aspirational content — only actionable directives
- No duplicates across files — one source of truth per concept
- Archive over delete when removing content
