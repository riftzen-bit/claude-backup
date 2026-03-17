# Template: Iterative Refinement

Use when: Output quality improves with repeated passes. Reports, documents, code generation.

## SKILL.md Template

```markdown
---
name: {{skill-name}}
description: {{Generates/creates}} {{output type}} with iterative quality refinement. Produces initial draft, validates against {{criteria}}, and refines until {{quality threshold}}. Use when user says "{{trigger 1}}", "{{trigger 2}}", or "{{trigger 3}}".
---

# {{Skill Display Name}}

## Workflow

### Initial Draft
1. {{Gather input data/context}}
2. {{Generate first draft}}
3. Save to temporary file

### Quality Check
Run validation against these criteria:
- [ ] {{Quality criterion 1}}
- [ ] {{Quality criterion 2}}
- [ ] {{Quality criterion 3}}
- [ ] {{Quality criterion 4}}

### Refinement Loop
For each identified issue:
1. Address the specific issue
2. Regenerate affected sections only
3. Re-validate
4. Repeat until quality threshold met

Maximum iterations: {{3-5}}

### Finalization
1. Apply final formatting
2. Generate summary of changes made
3. Save final version

## Quality Criteria

| Criterion | Check Method | Pass Threshold |
|-----------|-------------|----------------|
| {{Criterion 1}} | {{How to check}} | {{What passes}} |
| {{Criterion 2}} | {{How to check}} | {{What passes}} |
| {{Criterion 3}} | {{How to check}} | {{What passes}} |

## Validation Script (optional)

If quality checks can be automated, create `scripts/validate.py`:
```python
# Validate {{output type}} against quality criteria
# Return list of issues found
```

## Error Handling

### Refinement loop exceeds max iterations
1. Stop refining
2. Present current version with remaining issues listed
3. Ask user: "These issues remain. Accept current version or continue refining?"

### Quality criteria conflict
1. List conflicting criteria
2. Ask user to prioritize

## Examples

### Example 1: {{Common scenario}}
User says: "{{trigger phrase}}"
Draft: {{initial output description}}
Issues found: {{example issues}}
After refinement: {{improved output}}
```

## Key Techniques

- Explicit quality criteria (not vibes)
- Iterative improvement with max cap
- Validate ONLY against defined criteria
- Fix issues surgically, don't regenerate entire output
- Know when to stop
