# Template: Multi-Service Coordination

Use when: Workflow spans 2+ external services (MCP servers, APIs, tools).

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: Coordinates {{service list}} to {{outcome}}. Manages data flow between services with validation at each phase. Use when user says "{{trigger 1}}", "{{trigger 2}}", or mentions {{service names}} together.
---

# {{Skill Display Name}}

## Services Required
- {{Service 1}}: {{what it provides}} (via {{MCP/API/built-in}})
- {{Service 2}}: {{what it provides}} (via {{MCP/API/built-in}})
- {{Service 3}}: {{what it provides}} (via {{MCP/API/built-in}})

## Workflow Phases

### Phase 1: {{Data Gathering}} ({{Service 1}})
1. {{Action using service 1}}
2. {{Extract/transform data}}
3. {{Store intermediate result}}
- Validate: {{check before moving to phase 2}}

### Phase 2: {{Processing}} ({{Service 2}})
1. {{Action using service 2 with data from phase 1}}
2. {{Transform/enrich}}
3. {{Store result}}
- Validate: {{check before moving to phase 3}}

### Phase 3: {{Delivery}} ({{Service 3}})
1. {{Action using service 3 with data from phase 2}}
2. {{Format output}}
3. {{Confirm delivery}}

## Data Passing Between Services

| From | To | Data | Format |
|------|----|------|--------|
| {{Service 1}} | {{Service 2}} | {{data description}} | {{format}} |
| {{Service 2}} | {{Service 3}} | {{data description}} | {{format}} |

## Error Handling

### {{Service N}} connection fails
1. Verify MCP server is connected (Settings > Extensions)
2. Check API key validity
3. Test service independently: "Use [Service] MCP to [simple action]"

### Data format mismatch between services
1. Log raw output from source service
2. Transform to expected format
3. If transform fails, ask user for manual input

## Examples

### Example 1: {{Common scenario}}
User says: "{{trigger phrase}}"
Actions:
1. {{Phase 1 action}} via {{Service 1}}
2. {{Phase 2 action}} via {{Service 2}}
3. {{Phase 3 action}} via {{Service 3}}
Result: {{outcome}}
```

## Key Techniques

- Clear phase separation with service ownership
- Data passing contract between phases
- Validation before moving to next phase
- Centralized error handling per service
- Service independence testing
