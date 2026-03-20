---
name: clarify-product-intent-and-report-verification-evidence
description: Ask concise product questions when intent is unclear, route cheaper subtasks away from Opus, and never claim verification without command evidence
type: feedback
created: 2026-03-19
---

When a coding request is underspecified, ask concise product questions before editing. Do not guess missing behavior just to finish fast.

Because Paul is a non-programmer, only ask about product intent, desired behavior, edge cases, or acceptance criteria. Do not ask him to choose libraries, architectures, or implementation details unless there is no safe default.

Use cheaper specialists for file search, planning, review, and validation. Keep Opus focused on orchestration, ambiguity, architecture, and security-sensitive judgment.

Verification must be real:
- discover the repo's actual validator commands
- run them
- report exact command + exit code + key output
- say explicitly if anything was skipped, unavailable, or still failing

Never present a checklist as completed unless the underlying commands actually ran.
