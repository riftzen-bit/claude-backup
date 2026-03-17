# Execution Architecture Patterns

Source: Anthropic "Building Effective Agents" research.

Use this reference to choose the RIGHT execution architecture for a skill.

## Decision Framework

Start simple. Add complexity only when it demonstrably improves outcomes.

```
Single LLM call sufficient?
  YES → No skill needed, just good prompting
  NO  → Is the workflow predictable?
    YES → Use a WORKFLOW pattern (Steps 1-5 below)
    NO  → Use an AGENT pattern (Step 6)
```

## Workflow Patterns (predefined code paths)

### 1. Prompt Chaining
- What: Sequential LLM calls, each processing previous output
- When: Fixed subtasks needing high accuracy over speed
- Gate: Programmatic validation between steps
- Map to skill template: `template-sequential.md`

```
[LLM Call 1] → gate → [LLM Call 2] → gate → [LLM Call 3]
```

Example: Generate outline → Write sections → Review quality

### 2. Routing
- What: Classify input, direct to specialized handler
- When: Distinct categories needing separate handling
- Key: Each route has its own optimized prompt/tools
- Map to skill template: `template-smart-router.md`

```
[Input] → [Classifier] → Route A (specialized)
                        → Route B (specialized)
                        → Route C (specialized)
```

Example: Support query → general/refund/technical handlers

### 3. Parallelization
- What: Simultaneous LLM work with programmed aggregation
- When: Independent subtasks OR need consensus/voting
- Two variants:
  - Sectioning: split task into independent parts
  - Voting: multiple attempts, aggregate for confidence
- Map to skill template: `template-multi-service.md` (sectioning)

```
         ┌→ [LLM: Subtask A] →┐
[Input] →├→ [LLM: Subtask B] →├→ [Aggregate]
         └→ [LLM: Subtask C] →┘
```

Example: Review code for security + performance + style in parallel

### 4. Orchestrator-Workers
- What: Central LLM breaks task, delegates to workers, synthesizes
- When: Subtasks are NOT pre-defined but determined dynamically
- Key difference from parallelization: orchestrator decides what to do
- Map to skill template: `template-workflow-automator.md`

```
[Orchestrator] → determines subtasks → [Worker 1]
                                      → [Worker 2]
                                      → [Worker N]
               ← synthesizes results ←
```

Example: "Refactor the auth system" → orchestrator identifies files, creates tasks

### 5. Evaluator-Optimizer
- What: One LLM generates, another evaluates, loop until quality met
- When: Clear evaluation criteria AND iterative refinement adds value
- Map to skill template: `template-iterative.md`

```
[Generator] → [Output] → [Evaluator] → feedback → [Generator] → ...
                            ↓ pass
                         [Final Output]
```

Example: Write translation → evaluate naturalness → refine → repeat

## Agent Pattern (dynamic, self-directed)

### 6. Autonomous Agent
- What: LLM dynamically directs its own process and tool usage in a loop
- When: Open-ended problems, unpredictable step count
- Requirements: complex reasoning, reliable tool use, error recovery
- Map to: Agent definition (`.md` in `~/.claude/agents/`)

```
[LLM] → [Action] → [Environment Feedback] → [LLM] → ... → [Stop]
```

Key guardrails:
- Get ground truth from environment at each step
- Pause for human feedback at checkpoints
- Include stopping conditions (max iterations)
- Trust but verify - sandbox when possible

## Pattern Selection Matrix

| Signal | Pattern | Latency | Cost |
|--------|---------|---------|------|
| Fixed steps, high accuracy needed | Prompt Chaining | Medium | Low |
| Input needs classification first | Routing | Low | Low |
| Independent subtasks | Parallelization | Low | Medium |
| Dynamic task decomposition | Orchestrator-Workers | High | High |
| Quality improves with iteration | Evaluator-Optimizer | High | Medium |
| Open-ended, unpredictable steps | Autonomous Agent | Highest | Highest |

## Anti-Patterns

1. Using agents when a workflow suffices (unnecessary cost/latency)
2. Using frameworks before understanding the underlying API calls
3. Complex multi-agent systems when prompt chaining solves it
4. Not including stopping conditions in agent loops
5. Skipping evaluation criteria in iterative patterns

## Tool Design Principles (ACI)

Invest as much effort in Agent-Computer Interfaces as in Human-Computer Interfaces:

1. Give model enough tokens to reason before generating output
2. Keep formats close to natural text (avoid line counting, escaping)
3. Use poka-yoke: design args so mistakes are hard (absolute paths > relative)
4. Provide format-specific examples in tool descriptions
5. Test tools empirically - what seems obvious to humans often isn't to models
