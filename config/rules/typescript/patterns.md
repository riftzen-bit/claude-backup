---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Patterns

> Detect and follow the project's existing patterns. These are defaults ONLY when no existing pattern is found.

## API Responses

Before writing API handlers, read 3+ existing endpoints. Match the project's:
- Response envelope (success/data/error vs raw data vs Result type)
- Pagination format
- Error code structure

## React Hooks

- Custom hooks: prefix `use`, return typed values, cleanup in useEffect return
- Prefer derived state over useEffect for computed values
- Debounce/throttle via custom hooks, not inline timers

## Data Layer

- Repository/service pattern: detect from project, don't impose
- Always type query params and return values
- Prefer `unknown` over `any` for external data, validate with Zod
