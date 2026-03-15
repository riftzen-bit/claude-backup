---
name: self-optimize
description: Deep audit and optimization of ALL Claude Code configuration — CLAUDE.md, rules, skills, agents, hooks, MCP, memory, and context budget. Run this periodically for comprehensive self-improvement.
---

# Self-Optimization Deep Audit

You are entering deep self-optimization mode. Audit and improve every layer of your configuration.

## Step 1: Read Everything

Read ALL configuration files in this order:
1. `~/.claude/CLAUDE.md` (global config)
2. `./CLAUDE.md` (project config if exists)
3. All files in `~/.claude/rules/common/` and `~/.claude/rules/typescript/`
4. All files in `.claude/rules/` (project rules if exist)
5. `~/.claude/projects/*/memory/MEMORY.md` (memory index for current project)
6. All memory files referenced in MEMORY.md
7. `~/.claude/settings.json` (global settings — check hooks, MCP, plugins)
8. `.claude/settings.json` and `.claude/settings.local.json` (project settings if exist)
9. List all files in `~/.claude/skills/` and `.claude/skills/`
10. List all files in `.claude/agents/`
11. Run `git log --oneline -20` for recent work context

## Step 2: Status Report

Output a report with:
- Each config file: name, line count, purpose, quality rating (1-5)
- Total always-loaded tokens estimate (CLAUDE.md + rules + hooks)
- Skills: count, each with description quality rating
- Agents: count, each with tool restriction assessment
- MCP servers: list active ones with token cost concern
- Memory: count, staleness check
- Hooks: count, purpose of each
- Duplicate content found across files
- Missing capabilities detected

## Step 3: Optimize Each Layer

For each layer, apply these standards:

**CLAUDE.md**: Under 50 lines global, 150 lines project. Routing hub, not encyclopedia. Every line must prevent a specific mistake.

**Rules**: Total under 500 lines. No duplicates. Every rule concrete and verifiable. Organized by domain. Glob patterns for language-specific rules.

**Skills**: Specific descriptions for accurate activation. Under 100 lines each. Reference external docs. Hardcode static values. Self-improvement step included.

**Agents**: Tool restrictions explicit. Appropriate model per agent. max_turns set. Memory enabled where useful.

**Hooks**: Mandatory review, notification, security gates present. Minimal token overhead.

**MCP**: Only necessary servers active. Cheat sheets in reference files. Direct API for single-operation needs.

**Memory**: No stale entries. No duplicates with CLAUDE.md/rules. Correct type classification. Index under 200 lines.

## Step 4: Execute Changes

For each change:
1. Show WHAT you're changing and WHY
2. Show BEFORE state (current content or line count)
3. Make the change
4. Show AFTER state
5. Verify the change is valid

## Step 5: Verification

After all changes, run:
```
FINAL CHECKLIST:
[ ] Global CLAUDE.md: ___/50 lines
[ ] Project CLAUDE.md: ___/150 lines (if exists)
[ ] Total rules: ___/500 lines
[ ] No duplicate content across files
[ ] All skills have specific descriptions
[ ] All agents have tool restrictions + max_turns
[ ] MCP: only necessary servers
[ ] Memory: no stale entries
[ ] Always-loaded config < 15% context window
[ ] Hooks: review + notification + security present
[ ] Self-improvement loop integrated in rules
```

## Step 6: Summary

Output before/after comparison:
- Lines reduced: X → Y
- Duplicates removed: N
- Skills improved: N
- Agents optimized: N
- New capabilities added: list
- Estimated token savings per session: X tokens
