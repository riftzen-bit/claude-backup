---
name: self-optimize
description: Deep audit and optimization of Claude Code configuration — CLAUDE.md, hooks, rules, agents, skills, commands, plugins, settings, and memory.
---

# Self-Optimization Deep Audit

## Step 1: Read Everything

Read ALL configuration files:
1. `~/.claude/CLAUDE.md`
2. `~/.claude/enforce.md`
3. `~/.claude/settings.json`
4. All files in `~/.claude/rules/`
5. All files in `~/.claude/hooks/`
6. All files in `~/.claude/agents/`
7. All files in `~/.claude/skills/`
8. All files in `~/.claude/commands/`
9. `~/.claude/projects/-home-paul/memory/MEMORY.md` plus linked memory files
10. `./CLAUDE.md` / `./README*` if in a project, then run `git log --oneline -20`

## Step 2: Status Report

Output a report with:
- Each config file: name, line count, purpose, quality rating (1-5)
- Total always-loaded tokens estimate (`CLAUDE.md` + `enforce.md` + memory index + always-read rules)
- Plugins: count, each with purpose and hook coverage
- Plugin conflicts or redundant token-heavy plugins
- Commands: count, quality rating
- Agents and skills: count, trigger quality, stale references
- MCP servers: list active ones
- Duplicate content found across files
- Missing capabilities detected

## Step 3: Optimize Each Layer

**CLAUDE.md**: Under 50 lines. Routing + enforcement summary only. Every line prevents a specific mistake.

**enforce.md**: Short, strict, and evidence-based. No acknowledgement noise.

**Rules**: Supplementary. Avoid accidental overlap in inventories/counts; intentional runtime reinforcement in `CLAUDE.md`, `enforce.md`, hooks, and skills is allowed when it prevents real mistakes.

**Hooks**: Low-noise, no fake acknowledgement requirements, and no stale instructions.

**Agents/Skills**: Only reference specialists that actually exist. Triggers must be concrete.

**Plugins**: Check all hooks are working. Disable conflicting or token-heavy plugins that fight the user's workflow.

**Commands**: Relevant to Claude Code paths. Self-contained prompts.

## Step 4: Execute Changes

For each change:
1. Show WHAT and WHY
2. Show BEFORE as the minimum relevant snippet or diff context — never dump entire files by default
3. Make the change
4. Show AFTER as the minimum relevant snippet or diff
5. Verify

Redaction rule:
- Never print secrets, tokens, credentials, or private notes from config/memory files into the transcript
- If sensitive content is present, summarize or redact it by default

## Step 5: Verification

```
FINAL CHECKLIST:
[ ] CLAUDE.md: ___/50 lines
[ ] Always-loaded core config is concise
[ ] No accidental duplicate inventories/counts across files (intentional enforcement echoes are allowed)
[ ] Hooks are low-noise and valid
[ ] Only useful plugins remain enabled
[ ] All commands reference Claude Code paths
[ ] All referenced agents/skills actually exist
[ ] MCP: only necessary servers
[ ] Always-loaded config < 15% context window
```
