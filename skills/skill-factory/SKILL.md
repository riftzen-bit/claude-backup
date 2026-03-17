---
name: skill-factory
description: Generate production-ready Claude skills from templates. Covers all 5 workflow patterns (sequential, multi-service, iterative, smart-router, domain-expert) and 3 categories (document, workflow, MCP). Use when user says "create a skill", "new skill", "build a skill", "skill template", or "generate SKILL.md".
---

# Skill Factory

Generate production-ready skills from battle-tested templates.

## Step 1: Identify Use Case

Ask the user ONE question:
- "What workflow do you want to automate? Describe the trigger and expected outcome."

Then classify into:

| Category | Signal | Template |
|----------|--------|----------|
| Document/Asset | "generate", "create report", "build page" | `references/template-doc-generator.md` |
| Workflow Automation | "process", "pipeline", "multi-step" | `references/template-workflow-automator.md` |
| MCP Enhancement | "integrate with [service]", "use [tool] API" | `references/template-mcp-enhancer.md` |

## Step 2: Choose Architecture

First decide: is the workflow predictable or open-ended?
See `references/architecture-patterns.md` for the full decision framework.

| Predictable? | Architecture | Anthropic Pattern |
|-------------|-------------|-------------------|
| YES, fixed steps | Prompt Chaining | Workflow |
| YES, input-dependent routing | Routing | Workflow |
| YES, independent subtasks | Parallelization | Workflow |
| PARTIALLY, dynamic decomposition | Orchestrator-Workers | Workflow |
| PARTIALLY, quality via iteration | Evaluator-Optimizer | Workflow |
| NO, open-ended | Autonomous Agent | Agent |

## Step 3: Select Skill Template

Match to content template:

| Pattern | When | Template |
|---------|------|----------|
| Sequential / Chaining | Steps must run in order | `references/template-sequential.md` |
| Multi-Service / Parallel | Spans 2+ services or independent subtasks | `references/template-multi-service.md` |
| Iterative / Eval-Optimizer | Output improves with loops | `references/template-iterative.md` |
| Smart Router / Routing | Same goal, different tools by context | `references/template-smart-router.md` |
| Domain Expert | Specialized knowledge beyond tool access | `references/template-domain-expert.md` |

## Step 4: Generate SKILL.md

1. Read the selected template from `references/`
2. Replace ALL placeholders (marked with `{{...}}`)
3. Write SKILL.md to `~/.claude/skills/{{skill-name}}/SKILL.md`
4. If the skill needs reference docs, create `references/` subfolder

## Step 5: Validate

Run validation checklist from `references/quality-checklist.md`:

1. File named exactly `SKILL.md` (case-sensitive)
2. Folder named in kebab-case
3. YAML frontmatter has `---` delimiters
4. `name` field: kebab-case, no spaces, no capitals
5. `description` includes WHAT + WHEN (trigger phrases)
6. No XML angle brackets in frontmatter
7. Instructions are specific and actionable
8. Error handling included
9. Examples provided

## Step 6: Test Plan

Generate test cases:

```
Should trigger:
- "[exact phrase user would say]"
- "[paraphrased version]"
- "[related task]"

Should NOT trigger:
- "[unrelated but similar topic]"
- "[too broad query]"
```

## Composable Agent Pattern

If the skill needs a dedicated agent, create `~/.claude/agents/{{agent-name}}.md`:

```markdown
---
name: {{agent-name}}
description: {{what + when}}
tools: {{minimal tool list}}
model: {{haiku|sonnet|opus based on complexity}}
---

[Agent system prompt - keep under 80 lines]
```

Routing guide:
- haiku: search, format, validate, simple transforms
- sonnet: code review, analysis, refactor, testing
- opus: architecture, deep debug, security, ambiguous tasks

## Rules

1. Every generated skill MUST have trigger phrases in description
2. Keep SKILL.md under 5000 words - use `references/` for details
3. Instructions use bullet points and numbered lists, not prose
4. Include error handling section with common failure modes
5. Add negative triggers if scope is narrow ("Do NOT use for...")
6. Critical instructions go at TOP with `##` headers
