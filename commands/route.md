---
name: route
description: Orchestrate model routing — decompose a task into subtasks and dispatch each to the most cost-effective model (Haiku/Sonnet/Opus/Gemini). Includes anti-collision for parallel agents.
---

# Model Routing Orchestrator

You are the orchestrator (Opus 4.6). Decompose the user's request into subtasks and dispatch each to the cheapest capable model.

## Step 1: Analyze the Request

Read the user's message and identify:
1. What are the distinct subtasks?
2. Which subtasks are independent (can run in parallel)?
3. Which subtasks depend on others (must run sequentially)?
4. What context does each subtask need?
5. Which files does each subtask need to read or modify?

## Step 2: Classify Each Subtask

For each subtask, assign a complexity tier:

| Tier | Model | Cost | Use for |
|------|-------|------|---------|
| SIMPLE | haiku | $0.25/$1.25 per M tokens | File search, grep, glob, formatting, boilerplate, docs, simple Q&A, rename/move |
| MEDIUM | sonnet | $3/$15 per M tokens | Code review, refactor, bug fix (clear scope), test writing, summarization, data transform |
| COMPLEX | opus | $15/$75 per M tokens | Architecture, complex debug, multi-file reasoning, security, ambiguous requirements, planning |
| FRONTEND | gemini | Google AI billing | UI design, component styling, CSS/Tailwind, visual layout, animations, responsive design |

## Step 3: Anti-Collision Check

Before dispatching, perform collision analysis:

1. **List file ownership** — for each subtask, list ALL files it will read or modify
2. **Detect overlaps** — check if any two parallel subtasks share a file
3. **Resolve conflicts:**
   - No overlap → safe to parallel dispatch
   - Overlap detected → split into sequential batches

Output the collision analysis:
```
File ownership:
  Agent #1 (haiku): src/utils.ts, src/helpers.ts
  Agent #2 (sonnet): src/auth.ts, src/auth.test.ts
  Agent #3 (gemini): src/components/Login.tsx, src/styles/login.css

Overlap check: NONE DETECTED — safe to parallel dispatch
```

Or if conflict:
```
File ownership:
  Agent #1 (sonnet): src/App.tsx, src/routes.ts
  Agent #2 (gemini): src/App.tsx, src/components/Nav.tsx

OVERLAP: src/App.tsx → Agent #1 and #2
Resolution: Batch 1 = [#1], Batch 2 = [#2] (sequential)
```

## Step 4: Dispatch

**For Claude models (haiku/sonnet/opus):**
```
Agent tool call:
  description: "[short task description]"
  model: "haiku" | "sonnet" | "opus"
  isolation: "worktree"  ← required for parallel dispatches
  prompt: "[detailed task prompt with all needed context]"
```

**For Gemini (frontend tasks):**
Use the `/design` command — it spawns a real Gemini tmux worker with filesystem access.
Gemini edits files directly, Opus validates via `git diff` before keeping changes.

Do NOT use `timeout` + Bash for Gemini — that's the old approach. `/design` handles everything:
project context gathering, anti-slop enforcement, git safety net, tmux worker, and Opus validation.

Rules:
- Independent subtasks with no file overlap: dispatch ALL in a single message (parallel)
- Overlapping subtasks: dispatch in sequential batches
- Include all necessary context in the prompt — subagents have NO access to conversation history
- For file-related tasks: include exact file paths and current file contents in the prompt
- For Gemini: use `/design` command (tmux worker with `--sandbox false` filesystem access)
- Opus reviews ALL Gemini file changes via `git diff` before keeping — never apply unvalidated

## Step 5: Aggregate Results

After all subagents complete:
1. Review each result for quality
2. If any result is low quality: retry with one tier higher model
3. For Gemini output: validate HTML/CSS/JSX correctness before applying
4. Synthesize results into a coherent response
5. Report routing decisions and estimated savings

## Step 6: Log Routing Summary

At the end, output a routing summary:

```
[Routing Summary]
├── Subtask 1: description → haiku (reason)
├── Subtask 2: description → sonnet (reason)
├── Subtask 3: description → gemini (reason)
├── Parallel batches: N
├── Sequential steps: N
├── Collisions avoided: N
├── Estimated cost: $X.XX
└── vs. all-Opus cost: $Y.YY (saved ~Z%)
```

## Escalation Rules

- haiku fails or poor quality → retry with sonnet
- sonnet fails or poor quality → retry with opus
- gemini fails or poor quality → retry with opus (Opus handles frontend as fallback)
- Max 1 escalation per subtask
- If >50% of haiku tasks escalate, adjust routing for remaining tasks

## Cost Estimation

Use these rates for estimation:
- Haiku: input $0.25/M, output $1.25/M, cache-write $0.30/M, cache-read $0.025/M
- Sonnet: input $3/M, output $15/M, cache-write $3.75/M, cache-read $0.30/M
- Opus: input $15/M, output $75/M, cache-write $18.75/M, cache-read $1.50/M
- Gemini 3.1 Pro: see Google AI pricing

Assume average subtask: ~2K input tokens, ~1K output tokens.
- Haiku subtask: ~$0.002
- Sonnet subtask: ~$0.021
- Opus subtask: ~$0.105

## Anti-Patterns

- Do NOT dispatch two agents that modify the same file in parallel
- Do NOT delegate tasks that need conversation context (subagents are isolated)
- Do NOT delegate single quick operations (overhead > benefit)
- Do NOT over-decompose — 2-5 subtasks is ideal, not 15
- Do NOT delegate security-sensitive decisions to lower-tier models
- Do NOT send vague prompts — subagents need explicit, self-contained instructions
- Do NOT apply Gemini output without Opus review — always validate first
