# Notepad System

## Purpose

Accumulate wisdom across multi-step tasks. Subagents are stateless — notepads carry forward learnings, decisions, and issues so later tasks benefit from earlier discoveries.

## Structure

For multi-step work, create a notepad directory:
```
.claude/notepads/{task-name}/
  ├── learnings.md   # Conventions, patterns discovered during work
  ├── decisions.md   # Architectural choices made and why
  └── issues.md      # Problems found, gotchas, blockers
```

## Rules

- Create notepad at the START of multi-step work (3+ tasks)
- Read notepad BEFORE starting each new task in the sequence
- Append to notepad AFTER completing each task (new learnings only)
- Include notepad paths in CONTEXT section when delegating to subagents
- Single-step work does not need a notepad
- Notepad content is cumulative — never overwrite, only append
