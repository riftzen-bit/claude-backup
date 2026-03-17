# Composable Agent Patterns

## Agent Template

```markdown
---
name: {{agent-name}}
description: {{What it does}}. {{When to use it}}.
tools: {{comma-separated tool list}}
model: {{haiku|sonnet|opus}}
color: {{blue|green|yellow|red|magenta|cyan}}
---

{{System prompt - keep under 80 lines}}
```

## Model Selection

| Complexity | Model | Cost Ratio | Best For |
|------------|-------|------------|----------|
| Simple | haiku | 1x | Search, grep, format, validate, boilerplate |
| Medium | sonnet | 12x | Code review, refactor, bug fix, tests, analysis |
| Complex | opus | 60x | Architecture, deep debug, security, ambiguous tasks |

Rule: Use the cheapest model that reliably completes the task.

## Tool Selection

Only grant tools the agent actually needs:

| Task Type | Tools |
|-----------|-------|
| Read-only research | Glob, Grep, Read, WebFetch, WebSearch |
| Code modification | Read, Write, Edit, Bash, Grep, Glob |
| Full autonomy | All tools |

## Composability Patterns

### 1. Specialist Agent
Single responsibility. Does one thing well.
```
name: csv-validator
tools: Read, Bash, Grep
model: haiku
```

### 2. Coordinator Agent
Orchestrates other tools/agents for multi-step workflows.
```
name: release-coordinator
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
```

### 3. Reviewer Agent
Validates output from other agents or the main session.
```
name: output-reviewer
tools: Read, Grep, Glob, Bash
model: sonnet
```

## Anti-Collision Rules

When dispatching multiple agents in parallel:
1. Assign file ownership - no two agents touch the same file
2. Use `isolation: "worktree"` for parallel dispatches
3. If file overlap detected, run sequentially instead

## Agent System Prompt Structure

```
Line 1-3: Identity and role
Line 4-10: Core task description
Line 11-30: Execution patterns (what to do)
Line 31-50: Rules and constraints (what NOT to do)
Line 51-70: Output format
Line 71-80: Error handling
```
