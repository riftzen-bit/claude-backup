# Template: Workflow Automation

Use when: Multi-step processes that benefit from consistent methodology.

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: Automates {{workflow name}} with step-by-step validation gates. Handles {{input type}} through {{process}} to produce {{output type}}. Use when user says "{{trigger 1}}", "{{trigger 2}}", or "{{trigger 3}}".
---

# {{Skill Display Name}}

## Prerequisites
- {{Required tool/access 1}}
- {{Required tool/access 2}}

## Workflow

### Gate 0: Validate Inputs
Before starting, check:
- {{Input validation 1}}
- {{Input validation 2}}
IF invalid: Stop and report what's missing.

### Step 1: {{Name}}
Action: {{what to do}}
Tool: {{which tool to use}}
Expected output: {{what success looks like}}
Gate: {{validation before proceeding}}

### Step 2: {{Name}}
Action: {{what to do}}
Tool: {{which tool to use}}
Expected output: {{what success looks like}}
Gate: {{validation before proceeding}}

### Step 3: {{Name}}
Action: {{what to do}}
Tool: {{which tool to use}}
Expected output: {{what success looks like}}
Gate: {{validation before proceeding}}

### Final: Report
Summarize:
- What was done
- What was produced
- Any warnings or notes

## Validation Gates

| Gate | Check | Pass | Fail Action |
|------|-------|------|-------------|
| 0 | {{Input check}} | {{Criteria}} | Stop, report missing |
| 1 | {{Step 1 check}} | {{Criteria}} | Retry once, then ask user |
| 2 | {{Step 2 check}} | {{Criteria}} | Retry once, then ask user |

## Error Handling

### Tool not available
1. Report which tool is needed
2. Suggest manual alternative if possible

### Step fails after retry
1. Report which step failed and why
2. Save progress so far
3. Ask user how to proceed

## Templates for Common Structures

### {{Structure 1}}
```
{{template content}}
```

### {{Structure 2}}
```
{{template content}}
```
```

## Key Techniques

- Validation gates between every step (not just at end)
- Prerequisites checked upfront
- Templates for common output structures
- Progress saved on failure (don't lose work)
- Built-in review and improvement suggestions
