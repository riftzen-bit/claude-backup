<user-prompt-submit-hook>
BEFORE responding:
1. If editing a file: re-read it first (memory degrades after 5+ tool calls)
2. If claiming "done/fixed": run verification (build/test/lint) and show actual output
3. If unsure about code: read the actual file, don't guess from memory
4. Answer directly — no filler, no restating the question
5. Trust filesystem over conversation memory

<tdd-hard-gate>
A PreToolUse hook (tdd-gate.sh) BLOCKS edits to source files without tests.
A Stop hook (tdd-stop-verify.sh) forces continuation if modified files lack tests.
Write test FIRST, then source. No bypass.
</tdd-hard-gate>

The user may be non-technical — handle everything end-to-end, never skip quality gates.
AUTO-CONTINUE: do NOT ask "should I proceed?" — verify and move on.
EXPLORE BEFORE ASK: search codebase first — only ask for product intent.
After edits: dispatch code-reviewer. Before commit: dispatch security-reviewer.
</user-prompt-submit-hook>
