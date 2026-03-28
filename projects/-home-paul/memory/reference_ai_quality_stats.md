---
name: AI Code Quality Statistics
description: Hard data on AI-generated code quality — justifies why quality gates must never be skipped
type: reference
---

## AI Code Quality Research (2024-2025)

These statistics justify why TDD, code review, and security review gates are non-negotiable:

- **1.7x more bugs** in AI-generated code vs human-written
- **2.29x more concurrency bugs** — AI struggles with shared state and race conditions
- **8x excessive I/O** — AI over-fetches, creates N+1 queries, skips pagination
- **62% security flaws** — injection, XSS, missing auth checks, hardcoded secrets
- **21.7% hallucinated packages** — AI invents package names that don't exist (verify before import!)
- **AI tests: 90% coverage but 4% actual bug detection** — coverage != quality
- **94.8% of sites fail WCAG** — AI makes accessibility worse, not better

**How to apply:** Never skip quality gates. High coverage doesn't mean good tests. Always verify packages exist. Pay extra attention to concurrency, I/O patterns, and security in AI-generated code.
