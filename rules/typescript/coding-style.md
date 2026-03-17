---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Coding Style

> Extends common/02-code-quality.md with TypeScript/JavaScript specifics.

## Immutability
- Always return new objects via spread operator — never mutate arguments
- Use `const` by default, `let` only when reassignment is necessary

## Error Handling
- Use async/await with try-catch — match project's existing error pattern
- Throw descriptive Error messages, never re-throw bare `error`

## Validation & Security
- Use Zod for schema-based validation at system boundaries
- Prefer `unknown` over `any` for external data
- Use `security-reviewer` agent before commits

## Console.log
- No `console.log` in production code — use structured logging

## Testing
- Vitest preferred for unit tests (detect from project config)
- Playwright for E2E testing of critical user flows
- Use `e2e-runner` agent for E2E test generation/maintenance
