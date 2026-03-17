# Template: Sequential Workflow Orchestration

Use when: Steps must execute in a specific order with dependencies between them.

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: {{What it does in one sentence}}. Handles {{step count}} sequential steps: {{brief step list}}. Use when user says "{{trigger phrase 1}}", "{{trigger phrase 2}}", or "{{trigger phrase 3}}".
---

# {{Skill Display Name}}

## Workflow

### Step 1: {{First Step Name}}
{{Action description}}
- Input: {{what this step needs}}
- Output: {{what this step produces}}
- Validation: {{how to verify success}}

### Step 2: {{Second Step Name}}
{{Action description}}
- Input: {{output from Step 1}}
- Output: {{what this step produces}}
- Validation: {{how to verify success}}
- Depends on: Step 1 ({{specific dependency}})

### Step 3: {{Third Step Name}}
{{Action description}}
- Input: {{output from Step 2}}
- Output: {{what this step produces}}
- Validation: {{how to verify success}}
- Depends on: Step 2 ({{specific dependency}})

## Error Handling

### Step N fails
1. Log the error with context
2. {{Rollback instruction for this step}}
3. {{Recovery action}}

### Validation fails between steps
1. Do NOT proceed to next step
2. Report which validation failed and why
3. Ask user whether to retry or abort

## Examples

### Example 1: {{Common scenario}}
User says: "{{trigger phrase}}"
Result: {{expected outcome}}
```

## Key Techniques

- Explicit step ordering with numbered steps
- Dependencies declared between steps
- Validation gate before proceeding
- Rollback instructions for each step
- Each step documents its Input/Output contract
