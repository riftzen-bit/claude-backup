# Template: Domain-Specific Intelligence

Use when: Skill adds specialized knowledge beyond what tools provide. Compliance, best practices, institutional knowledge.

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: Applies {{domain}} expertise to {{task}}. Embeds {{knowledge type}} including {{key areas}}. Use when user says "{{trigger 1}}", "{{trigger 2}}", or works with {{domain-specific terms}}.
---

# {{Skill Display Name}}

## Domain Knowledge

### {{Knowledge Area 1}}
{{Rules, constraints, or best practices}}
- {{Rule 1}}
- {{Rule 2}}
- {{Rule 3}}

### {{Knowledge Area 2}}
{{Rules, constraints, or best practices}}
- {{Rule 1}}
- {{Rule 2}}

## Workflow

### Pre-Check (Compliance/Validation)
Before any action, verify:
1. {{Pre-condition 1}}
2. {{Pre-condition 2}}
3. {{Pre-condition 3}}

IF pre-check fails:
- {{What to do}}
- Do NOT proceed until resolved

### Processing
1. {{Main action}}
2. Apply domain rules:
   - {{Rule application 1}}
   - {{Rule application 2}}
3. {{Post-action validation}}

### Audit Trail
Log all decisions:
- What was checked
- What was decided
- Why (reference specific domain rule)

## Domain Rules Reference

| Rule | Applies When | Action Required |
|------|-------------|-----------------|
| {{Rule 1}} | {{Condition}} | {{Required action}} |
| {{Rule 2}} | {{Condition}} | {{Required action}} |
| {{Rule 3}} | {{Condition}} | {{Required action}} |

## Red Flags

These conditions require immediate user attention:
- {{Red flag 1}}: {{why it matters}}
- {{Red flag 2}}: {{why it matters}}
- {{Red flag 3}}: {{why it matters}}

## Error Handling

### Domain rule conflict
1. List conflicting rules
2. State which rule takes precedence and why
3. Ask user to confirm if precedence is ambiguous

### Missing domain context
1. Ask user for {{specific missing info}}
2. Do NOT guess or assume domain-specific values

## Examples

### Example 1: {{Common scenario}}
User says: "{{trigger}}"
Domain rules applied: {{which rules}}
Result: {{outcome with compliance/best-practice embedded}}

### Example 2: {{Edge case}}
User says: "{{trigger}}"
Red flag detected: {{what was flagged}}
Action: {{how it was handled}}
```

## Key Techniques

- Domain expertise embedded directly in instructions
- Compliance/validation BEFORE action (not after)
- Comprehensive audit trail
- Red flags for dangerous edge cases
- Rules reference table for deterministic application
- Never guess domain-specific values
