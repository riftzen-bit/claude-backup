---
name: Mandatory Pre-Action Checklist
description: CRITICAL — Must check EVERY time before responding, coding, or committing. Never skip any step. Created after Paul caught violations on 2026-03-11.
type: feedback
---

## NEVER VIOLATE THESE RULES AGAIN

Paul explicitly said: "tự chỉnh chính bạn để KHÔNG BAO GIỜ VI PHẠM LẠI 100%"

### PRE-RESPONSE CHECKLIST (before EVERY message)

1. **Check skills** — Does any superpowers skill apply? Even 1% chance = invoke it.
   - Creative/feature work → invoke `superpowers:brainstorming` FIRST
   - Planning multi-step → invoke `superpowers:writing-plans` FIRST
   - Bug/test failure → invoke `superpowers:systematic-debugging` FIRST
   - Completing work → invoke `superpowers:verification-before-completion` FIRST

2. **Re-read files** before editing (memory may be stale after 5+ tool calls)

3. **Trust filesystem** over conversation memory

### PRE-CODING CHECKLIST

4. **Propose plan → wait for approval** unless user explicitly says "tự quyết/tự làm"
   - Even with "tự quyết", still briefly list what you'll do before doing it

5. **TDD — NO EXCEPTIONS**
   - Write failing test FIRST (RED)
   - Write minimal code to pass (GREEN)
   - Refactor (REFACTOR)
   - Paul's rule 03-testing.md: "Every change needs a test. No exceptions for 'too small' or 'too simple.'"

### POST-CODING CHECKLIST

6. **Run verification** — build/typecheck/lint/test before claiming done
   - Show actual output, never claim success without proof

7. **Code reviewer agent** — MUST dispatch after writing/modifying code
   - Use `superpowers:requesting-code-review` or `code-reviewer` agent

8. **Security reviewer agent** — MUST dispatch before commits
   - Use `security-reviewer` agent for any code handling input/auth/API

### PRE-COMMIT CHECKLIST

9. **All tests pass** — verified with actual output shown
10. **Code review done** — agent dispatched and findings addressed
11. **Security review done** — for relevant changes

### WHEN DISPATCHING SUBAGENTS

12. **Include ALL rules** in agent prompts:
    - TDD requirement
    - Design rules (no AI slop, warm palettes)
    - Match existing code patterns
    - Run verification before finishing

**Why:** Paul caught me violating TDD, skipping brainstorming, skipping code review, and skipping security review on 2026-03-11. Trust is earned through consistency. One violation = broken trust.

**How to apply:** Mentally run through this checklist BEFORE every single response. If any item is not met, stop and address it before proceeding.
