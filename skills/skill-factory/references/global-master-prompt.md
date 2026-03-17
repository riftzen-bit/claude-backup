# Global Master Prompt v3.0

Synthesized from 4 sources:
1. Anthropic's official prompting best practices (Claude 4.6)
2. Building Effective Agents research
3. Complete Guide to Building Skills (PDF)
4. Community prompt engineering guide (ThamJiaHe, Feb 2026)

Use this reference when generating system prompts for skills, agents, or any Claude integration.

## Core Principles (Anthropic-Official)

### 1. Be Clear and Direct
- Show prompt to a colleague with no context — if they'd be confused, Claude will be too
- Be specific about desired output format and constraints
- Use numbered lists when order matters
- Tell Claude what to DO, not what NOT to do
- Add modifiers: "Include as many relevant features as possible. Go beyond the basics."

### 2. Provide Context/Motivation
- Explain WHY an instruction matters, not just the rule
- Claude generalizes from the explanation
- Example: "Never use ellipses" → "Your response will be read aloud by text-to-speech, so never use ellipses since TTS won't know how to pronounce them"

### 3. Use Examples (3-5)
- Wrap in tags: individual in `example`, multiples in `examples`
- Make them: relevant, diverse (cover edge cases), structured
- Include reasoning pattern in examples for thinking-enabled tasks

### 4. Structure with XML Tags
- Consistent, descriptive tag names across prompts
- Nest tags for natural hierarchy
- Separate instructions, context, examples, input
- Long documents at TOP, query at BOTTOM (up to 30% quality improvement)

### 5. Give Claude a Role
- Even one sentence in system prompt makes a difference
- Focuses behavior and tone for use case

## System Prompt Architecture

### Recommended Structure

```
[Role definition — 1-2 sentences]

[Core instructions — what to do, numbered steps]

[XML-tagged sections for:]
  <context>       — background info, domain knowledge
  <rules>         — constraints, guardrails
  <examples>      — 3-5 representative examples
  <output_format> — exact format specification

[Long documents/data at top if applicable]

[Query/task at bottom]
```

### Effective Prompting Blocks

#### Action vs Suggestion
```
-- Make Claude ACT (not just suggest):
"Change this function to improve its performance."
NOT: "Can you suggest some changes?"

-- Make Claude PROACTIVE:
<default_to_action>
By default, implement changes rather than only suggesting them.
If the user's intent is unclear, infer the most useful likely action
and proceed, using tools to discover any missing details instead of guessing.
</default_to_action>
```

#### Parallel Tool Calling
```
<use_parallel_tool_calls>
If you intend to call multiple tools and there are no dependencies
between the calls, make all independent calls in parallel.
Never use placeholders or guess missing parameters.
</use_parallel_tool_calls>
```

#### Anti-Overengineering
```
Avoid over-engineering. Only make changes that are directly requested
or clearly necessary. Keep solutions simple and focused.
- Don't add features, refactor, or make "improvements" beyond what was asked
- Don't add docstrings/comments/types to code you didn't change
- Don't add error handling for scenarios that can't happen
- Don't create abstractions for one-time operations
```

#### Anti-Hallucination
```
<investigate_before_answering>
Never speculate about code you have not opened. If the user references
a specific file, you MUST read the file before answering. Give grounded
and hallucination-free answers.
</investigate_before_answering>
```

#### Anti-Test-Hacking
```
Write general-purpose solutions using standard tools. Do not hard-code
values or create solutions that only work for specific test inputs.
Tests verify correctness, not define the solution.
```

#### Subagent Guidance
```
Use subagents when tasks can run in parallel, require isolated context,
or involve independent workstreams. For simple tasks, sequential
operations, or single-file edits, work directly.
```

#### Context Window Management
```
Your context will be automatically compacted as it approaches its limit.
Do not stop tasks early due to token budget concerns. Save progress
before context refreshes. Always be persistent and complete tasks fully.
```

#### Safety/Autonomy Balance
```
Consider reversibility and impact of actions. Take local, reversible
actions freely (editing files, running tests). For hard-to-reverse
or shared-system actions, ask before proceeding.
```

## Claude 4.6 Specific Tuning

### Do
- Use adaptive thinking (`thinking: {type: "adaptive"}`)
- Use normal language ("Use this tool when...") — not "CRITICAL: You MUST"
- Frame instructions with modifiers for quality
- Request features explicitly when desired
- Set effort parameter appropriately (low/medium/high/max)

### Don't
- Use prefilled responses (deprecated in 4.6)
- Over-prompt tool usage — previous undertriggering is now overtriggering
- Use blanket "Default to using [tool]" — use conditional "Use [tool] when..."
- Add anti-laziness prompting from older models — 4.6 is already proactive
- Say "think" when extended thinking is disabled (triggers unwanted behavior)

### Thinking Guidance
```
-- Prevent overthinking:
Choose an approach and commit to it. Avoid revisiting decisions unless
new information directly contradicts your reasoning. Pick one approach
and see it through.

-- Guide thinking:
After receiving tool results, carefully reflect on their quality and
determine optimal next steps before proceeding.

-- Reduce unnecessary thinking:
Extended thinking adds latency and should only be used when it will
meaningfully improve answer quality — typically for multi-step reasoning.
When in doubt, respond directly.
```

## Output Formatting

### Minimize Markdown
```
<avoid_excessive_markdown_and_bullet_points>
Write in clear, flowing prose using complete paragraphs. Reserve markdown
for inline code, code blocks, and simple headings. DO NOT use ordered
or unordered lists unless presenting truly discrete items or explicitly
requested. Incorporate items naturally into sentences.
</avoid_excessive_markdown_and_bullet_points>
```

### Control Verbosity
Claude 4.6 is naturally more concise. If you want MORE detail:
```
After completing a task involving tool use, provide a quick summary
of the work you've done.
```

## Multi-Session / Long-Horizon

### State Management
- Use JSON for structured state (test results, task status)
- Use freeform text for progress notes
- Use git for checkpoints and state tracking
- Write tests BEFORE starting work, track in structured format

### First vs Subsequent Sessions
- First session: set up framework (tests, scripts, plan)
- Subsequent sessions: iterate on todo-list
- Create `init.sh` for graceful server/test/lint startup

### Session Recovery
```
Review progress.txt, tests.json, and git logs.
Run integration test before implementing new features.
```

## Skill-Specific Prompt Patterns

When generating prompts for skills (see template files), apply these patterns:

| Skill Type | Prompt Pattern |
|-----------|---------------|
| Sequential | Numbered steps + validation gates + rollback |
| Router | Decision tree + transparency about chosen route |
| Iterative | Quality criteria + max iterations + stop condition |
| Multi-Service | Phase separation + data passing contract |
| Domain Expert | Pre-checks + rules table + audit trail |
| Agent | Tool loop + environment feedback + stopping conditions |

## Skill Token Efficiency (Community Research)

Skills cost ~5 tokens at discovery (name+description only).
Full SKILL.md loads only when activated. Use the **wrapper pattern**:

```
my-skill/
├── SKILL.md              # Thin wrapper (50-100 lines) — always cheap
├── implementation/
│   └── full-logic.md     # Heavy logic — loaded on demand
└── templates/
    └── examples.md       # Templates — loaded on demand
```

Rule: SKILL.md under 100 lines. Each reference file under 200 lines.

## 3-Tier Subagent Orchestration

For complex multi-agent tasks, use tiered model allocation:

| Tier | Role | Model | Cost |
|------|------|-------|------|
| 1 | Strategic orchestrator | Opus 4.6 | High |
| 2 | Domain coordinators | Sonnet 4.6 | Medium |
| 3 | Focused specialists | Sonnet 4.6 / Haiku | Low |

Assign file ownership per agent. Use `isolation: "worktree"` for parallel.
Sequential single-agent: ~45 min. Parallel 3-tier: ~10 min (90% improvement).

## Hook Patterns (Community Best Practice)

### Block at Submit, Not at Write
Let Claude finish its plan, validate at end — not during every write.
Use `UserPromptSubmit` or `PreCommit` hooks, not `PostToolUse` on every edit.

### Input Modification over Blocking
Don't block tool calls on bad input — fix the input silently:
```
IF bad input detected:
  Return { updatedInput: correctedInput }  // Claude never sees error
NOT:
  Return { blocked: true, reason: "..." }  // Interrupts flow
```

## Safety Enforcement (Critical)

CLAUDE.md constraints can be bypassed in long sessions.
Use explicit XML constraint blocks:

```
<critical_constraints>
NEVER execute destructive commands without:
1. Showing the exact command first
2. Waiting for explicit confirmation
3. Creating backup first (cp file file.bak)
</critical_constraints>
```

For long sessions: commit checkpoints every major change, restart every 2-3 hours.

## 10-Component Prompt Framework

Complete system prompt structure (role in system, rest in user):

1. **Task Context** (WHO + WHAT) — system prompt, 1-3 sentences
2. **Tone** — communication style
3. **Background** — context, domain knowledge, documents
4. **Task Description** — objective + constraints + success criteria
5. **Rules** — MUST / MUST NOT / CONSIDER
6. **Examples** — 3-5 multishot with good/bad examples
7. **Conversation History** — prior turns
8. **Immediate Task** — current request
9. **Thinking** — CoT guidance (up to 39% quality improvement)
10. **Output Format** — structure, tags, style

## Effort Parameter Quick Reference

| Effort | Token Savings | Use For |
|--------|--------------|---------|
| max | 0% (deepest) | Novel research, architecture (Opus only) |
| high | 0% (default) | Complex reasoning, agentic tasks |
| medium | ~76% fewer | Balanced quality/cost |
| low | ~50% fewer | Simple tasks, subagents, high-volume |

Key: At `medium`, Opus matches Sonnet's best SWE-bench while using 76% fewer tokens.

## Anti-Patterns (Never Do)

1. Vague instructions ("validate the data properly")
2. Relying on model to infer unstated requirements
3. Over-prompting with "CRITICAL/MUST/ALWAYS" (causes overtriggering in 4.6)
4. Using prefilled responses (deprecated — returns 400 in 4.6)
5. Mixing markdown styles in one prompt
6. Walls of text without structure (use XML tags)
7. Adding unnecessary complexity "just in case"
8. Blanket tool-use instructions instead of conditional
9. Loading all MCP servers at startup (67K token tax before conversation)
10. Running hooks on every file write instead of at submit/commit
11. Skipping RESEARCH+PLAN phase — jumping to IMPLEMENT
12. Trusting CLAUDE.md constraints alone for destructive ops — use XML blocks
