# Template: MCP Enhancement

Use when: Adding workflow guidance on top of an existing MCP server's tool access.

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: Enhances {{MCP server name}} integration with best-practice workflows for {{use case}}. Coordinates {{tool list}} calls in optimal sequence. Use when user says "{{trigger 1}}", "{{trigger 2}}", or mentions "{{service name}}".
metadata:
  mcp-server: {{server-name}}
  version: 1.0.0
---

# {{Skill Display Name}}

## MCP Server: {{server-name}}

### Available Tools
- `{{tool_1}}`: {{what it does}}
- `{{tool_2}}`: {{what it does}}
- `{{tool_3}}`: {{what it does}}

### Connection Check
Before any workflow, verify MCP is connected:
1. Try a simple read operation: `{{tool_1}}` with minimal params
2. If connection refused: Settings > Extensions > {{Service}} > Reconnect
3. If auth error: Check API key in MCP config

## Workflows

### Workflow 1: {{Common Task}}
Use when: {{trigger condition}}

1. Call `{{tool_1}}` with parameters:
   - {{param}}: {{value/source}}
2. Parse response, extract {{data}}
3. Call `{{tool_2}}` with:
   - {{param}}: {{value from step 1}}
4. Validate result: {{check}}

### Workflow 2: {{Another Common Task}}
Use when: {{trigger condition}}

1. Call `{{tool_3}}` to {{action}}
2. {{Process result}}
3. Call `{{tool_1}}` to {{verify}}

## Best Practices

- {{Practice 1}}: {{why}}
- {{Practice 2}}: {{why}}
- {{Practice 3}}: {{why}}

## Error Handling

### MCP Connection Issues
1. Verify server running: Settings > Extensions
2. Confirm API key valid and not expired
3. Check permissions/scopes granted
4. Try reconnecting: Settings > Extensions > {{Service}} > Reconnect

### API Rate Limiting
1. Wait and retry with backoff
2. Batch operations where possible
3. Cache results for repeated lookups

### Tool Name Mismatch
Skill references correct tool names as of {{date}}.
If tool not found, check MCP server documentation for renamed/deprecated tools.

## Examples

### Example 1: {{Common scenario}}
User says: "{{trigger}}"
MCP calls made:
1. `{{tool_1}}({{params}})` -> {{result}}
2. `{{tool_2}}({{params}})` -> {{result}}
Outcome: {{what user gets}}
```

## Key Techniques

- Document available MCP tools upfront
- Connection verification before workflows
- Explicit tool call sequences with parameters
- Error handling specific to MCP (connection, auth, rate limiting)
- Tool names are case-sensitive - match MCP server docs exactly
- Context the user would otherwise need to specify manually
