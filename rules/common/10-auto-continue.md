# Autonomous Execution

## Explore Before Asking

Most questions about the codebase are answerable through exploration. Before asking the user:
1. Fire explore/search agents to find the answer in the code
2. Only ask when the question requires PRODUCT INTENT (user preferences, tradeoffs, business logic)
3. Two kinds of unknowns:
   - Discoverable facts (repo truth) → EXPLORE first, don't ask
   - Preferences/tradeoffs (user intent) → ASK with 2-4 concrete options

## Auto-Continue

When executing multi-step work with a clear plan:
- Do NOT ask "should I proceed?" between steps — just continue
- Do NOT ask for permission to run the next task — verify and move on
- STOP only when: blocked by an error you can't resolve, or a decision requires product intent
- After each step: verify → update notepad → mark task complete → start next task

## Verification Gate (from OmO's 4-Phase Protocol)

Before marking any task complete:
1. READ: Re-read every changed file
2. CHECK: Run automated validators (build, types, lint, tests)
3. VERIFY: If UI change, visually verify; if API change, test the endpoint
4. GATE: Can you explain every change? Did you see it work? Confident nothing broke?

If any gate fails, fix and re-verify — do not mark complete until all gates pass.
