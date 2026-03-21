<user-prompt-submit-hook>
BEFORE responding:
1. If editing a file: re-read it first (memory degrades after 5+ tool calls)
2. If claiming "done/fixed": run verification (build/test/lint) and show actual output
3. If unsure about code: read the actual file, don't guess from memory
4. Answer directly — no filler, no restating the question
5. Trust filesystem over conversation memory

MANDATORY ENGINEERING MINDSET (every message):
- Fully understand the codebase before writing code
- Think like a world-class engineer: analyze options, critique, propose plan, wait for approval
- Ask clarifying questions instead of assuming
- Non-trivial tasks (3+ steps): use Spec Mode (Shift+Tab) to plan FIRST, define execution + verification steps
- If something breaks mid-task: STOP execution, re-plan, then resume
- Before marking done, ask: "Would a senior engineer approve this?"
- Demand elegance: ask "Is there a simpler/cleaner way?" — avoid hacky or temporary fixes
- Provide context not micromanagement — let AI adapt to the problem, flexibility > rigid steps

MANDATORY AUTOMATION CHECKLIST:
- BEFORE complex features: plan in Spec Mode, then execute
- BEFORE coding: TDD — write failing test FIRST, then implement
- AFTER writing code: dispatch code-reviewer droid automatically
- BEFORE commits: dispatch security-reviewer droid automatically
- BEFORE claiming done: run build/typecheck/lint/tests AND show output
- WHEN delegating to droids: include TDD rules and verification in every prompt
- Paul is non-programmer — handle everything end-to-end, never skip quality gates
</user-prompt-submit-hook>
