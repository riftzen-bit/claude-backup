# Template: Document & Asset Creation

Use when: Creating consistent, high-quality output (documents, presentations, code, designs).

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: Creates {{document/asset type}} with {{quality standard}}. Embeds {{style/brand}} guidelines and quality checklists. Use when user says "{{trigger 1}}", "{{trigger 2}}", or "create {{asset type}}".
---

# {{Skill Display Name}}

## Style Guide

### Tone
{{formal/casual/technical/friendly}}

### Structure
Every {{document type}} follows this structure:
1. {{Section 1}}: {{purpose}}
2. {{Section 2}}: {{purpose}}
3. {{Section 3}}: {{purpose}}

### Formatting Rules
- {{Rule 1}} (e.g., headings style)
- {{Rule 2}} (e.g., code block format)
- {{Rule 3}} (e.g., image placement)

## Template

```{{format}}
{{Complete template with placeholders}}
```

## Workflow

### Step 1: Gather Input
Ask user for:
- {{Required input 1}}
- {{Required input 2}}
- {{Optional input}} (default: {{default value}})

### Step 2: Generate Draft
1. Apply template
2. Fill in sections from user input
3. Apply style guide rules

### Step 3: Quality Checklist
Before presenting to user, verify:
- [ ] {{Quality check 1}}
- [ ] {{Quality check 2}}
- [ ] {{Quality check 3}}
- [ ] {{Quality check 4}}
- [ ] No placeholder text remaining

### Step 4: Deliver
1. Save to {{output location}}
2. Present summary of what was created

## Error Handling

### Missing required input
1. Ask user for the specific missing field
2. Suggest a default if appropriate

### Template section doesn't apply
1. Skip the section
2. Note in output: "Section {{name}} omitted because {{reason}}"

## Examples

### Example 1: {{Common scenario}}
User says: "{{trigger}}"
Input gathered: {{what was collected}}
Output: {{description of generated document}}
```

## Key Techniques

- Embedded style guide (not external reference)
- Complete template structure
- Quality checklist before delivery
- No external tools required - uses Claude's built-in writing
- Placeholders clearly marked for easy identification
