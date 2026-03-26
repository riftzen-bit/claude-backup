# Code Quality

## Read and Match Before Writing

Before writing any code:
1. Find related files/modules in the codebase
2. Search for existing similar code — reuse over rewrite
3. Match project naming, structure, import style, error handling patterns
4. Follow the project's established patterns exactly

Priority: use existing code > extend existing code > write new code (last resort).

## Simplicity

- Start with the simplest approach. Add complexity only with evidence it's needed
- Do not create abstractions until the pattern repeats 3+ times
- Do not add features, refactor code, or make improvements beyond what was asked
- Do not add docstrings, comments, or type annotations to unchanged code
- Do not add error handling for scenarios that can't happen
- Do not add dependencies for < 20 lines of code or to use one function
- Three similar lines of code is better than a premature abstraction

## Immutability

Prefer immutable patterns: return new objects rather than mutating in place. This prevents hidden side effects and enables safe concurrency.

## File Organization

- 200-400 lines typical, 800 max per file
- Functions under 50 lines
- No deep nesting (>4 levels)
- Organize by feature/domain, not by type

## Error Handling — One Pattern Per Project

Check which pattern the project uses (try/catch, Result/Either, error-first callbacks, etc.) and use exactly the same pattern everywhere. Do not mix patterns.

## Configuration

- Load config from environment variables or config files, not hardcoded values
- Validate env vars at startup with schema validation
- One centralized config module — import it everywhere
- Secrets: never log, never include in error responses, never commit

## API Consistency

When adding endpoints, read 3+ existing endpoints and match: URL naming, HTTP methods, request/response format, pagination, auth pattern, error format.

## Dependency Direction

Dependencies flow one direction (DAG). If A imports B and B imports A, extract shared code to a third module.

## Anti-Patterns

Before editing, check for these AI-generated code smells:
- **Scope creep**: "Does this change solve ONLY the request?" — check references against scope
- **Premature abstraction**: "Does this pattern repeat 3+ times?" — if no, keep it inline
- **Over-validation**: 15 error checks for 3 inputs is a smell — match existing error handling
- **Documentation bloat**: Added JSDoc/comments everywhere? Match existing doc style, not more
- **Invented patterns**: Using a new pattern when the codebase has an existing one? Use existing
