# Testing

## TDD Process

1. **RED**: Write tests describing expected behavior. Run them — they fail
2. **GREEN**: Write minimal code to make tests pass. Run them — they pass
3. **REFACTOR**: Improve code while keeping tests green

Every change needs a test: new function, bug fix, API endpoint, logic change, error handling, edge cases. No exceptions for "too small" or "too simple."

## Anti-Vibe-Testing

- Mock only external dependencies, never the system under test
- Assert behavior, not implementation details
- Never write tests that just assert the implementation returns what it returns
- Every test fails first (RED) — a test that never failed proves nothing
- If coverage jumps >30% in one session, review test quality not just quantity
- Prefer integration tests over heavily-mocked unit tests for AI-generated code
- Before writing tests, assess test infrastructure: detect framework, check for existing test patterns, decide TDD vs tests-after based on project conventions

## Test Structure (Arrange-Act-Assert)

Every test: set up data → call function → verify result. Follow project's existing naming convention. If none exists: `src/utils/foo.ts` → `src/utils/__tests__/foo.test.ts`, `lib/auth.py` → `tests/test_auth.py`.

## Test Minimums

- 5+ test cases per exported function/method
- 3+ edge case tests per function (null, empty, boundary, overflow)
- 100% coverage of error paths and public API surface
- Test categories: happy path, edge cases, error handling, boundary, security, integration, async/race, state, regression

## Coverage

- Minimum: 80% overall
- Core business logic: 100%
- Run coverage check after every TDD cycle

## Validation Discovery

- Detect the repo's real validator commands before coding (`package.json`, `pyproject.toml`, `go.mod`, Makefile, CI config, etc.)
- If a validator does not exist, say so explicitly instead of pretending it passed
- If the repo has no usable test harness, state that clearly and use the closest available safety net

## Zero-Error Loop

After every code change, auto-run all applicable checks:
- Build/compile, type check, lint, unit tests

If errors found:
1. Analyze root cause (not symptoms)
2. Fix root cause — priority: type errors > build > lint > test failures
3. Re-run all checks
4. Repeat until clean or 10 iterations

Report status after each iteration: `[Loop N] Errors: X -> Y`
For every validator, record: command, exit code, and key output lines
When clean: `[CLEAN] Build: OK | Types: OK | Lint: OK | Tests: OK`
