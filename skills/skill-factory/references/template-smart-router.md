# Template: Context-Aware Smart Router

Use when: Same outcome needed but different tools/approaches depending on context.

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: {{Outcome description}} with automatic tool/approach selection based on {{context factors}}. Routes to the best approach for {{use case}}. Use when user says "{{trigger 1}}", "{{trigger 2}}", or "{{trigger 3}}".
---

# {{Skill Display Name}}

## Decision Tree

### Evaluate Context
Check these factors in order:
1. {{Factor 1}}: {{how to detect}} -> {{which approach}}
2. {{Factor 2}}: {{how to detect}} -> {{which approach}}
3. {{Factor 3}}: {{how to detect}} -> {{which approach}}
4. Default: {{fallback approach}}

### Route: {{Approach A}}
When: {{condition}}
Tool: {{specific tool/service}}
Steps:
1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

### Route: {{Approach B}}
When: {{condition}}
Tool: {{specific tool/service}}
Steps:
1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

### Route: {{Approach C}} (Default)
When: No other route matches
Tool: {{specific tool/service}}
Steps:
1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}

## Transparency

After routing, tell the user:
"Using {{approach}} because {{reason}}. If you prefer a different approach, let me know."

## Fallback Chain

If primary route fails:
1. Try next best route
2. If all routes fail, ask user for guidance

## Error Handling

### Context detection fails
1. Ask user: "I need to know {{factor}} to choose the best approach. {{options}}?"
2. Route based on user response

### Selected tool unavailable
1. Log which tool is unavailable
2. Fall back to next route
3. Inform user: "{{Tool}} unavailable, using {{alternative}} instead"

## Examples

### Example 1: {{Context A scenario}}
User says: "{{trigger}}"
Context detected: {{factor value}}
Route selected: {{Approach A}}
Result: {{outcome}}

### Example 2: {{Context B scenario}}
User says: "{{same trigger}}"
Context detected: {{different factor value}}
Route selected: {{Approach B}}
Result: {{same outcome, different path}}
```

## Key Techniques

- Clear decision criteria (deterministic, not vibes)
- Fallback options when primary route fails
- Transparency about which route was chosen and why
- Same trigger phrase can go to different routes
- User can override routing decision
