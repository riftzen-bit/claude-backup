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

Use spread operator for immutable updates:

```typescript
// WRONG: Mutation
function updateUser(user, name) {
  user.name = name  // MUTATION!
  return user
}

// CORRECT: Immutability
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

## Error Handling

Use async/await with try-catch:

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('Detailed user-friendly message')
}
```

## Input Validation

Use Zod for schema-based validation:

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

## Console.log

- No `console.log` in production code — use structured logging
- PostToolUse hook warns on console.log in edited files

## Security

- Never hardcode secrets — use `process.env` + startup validation
- Use Zod for all external input validation at boundaries
- Use `security-reviewer` agent for comprehensive audits before commits

## Testing

- Playwright for E2E testing of critical user flows
- Use `e2e-runner` agent for E2E test generation/maintenance
- Vitest preferred for unit tests (detect from project config)
