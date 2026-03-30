<enforce>
MANDATORY — hook-enforced, every message.

BEFORE RESPONDING:
1. READ context first: enforce.md, CLAUDE.md, rules/, active files
2. PLAN before acting: classify complexity (trivial/simple/medium/complex/research)
3. For medium+: state approach BEFORE touching code
4. Re-read files before editing (hook BLOCKS edits to unread files with exit 2)
5. Trust filesystem over memory — re-read after 5+ tool calls

DURING WORK:
6. Complete the FULL task — never stop midway or ask "should I continue?"
7. Write tests FIRST (tdd-gate.sh BLOCKS source edits without tests)
8. Match existing code style exactly — no slop, no garbage, no shortcuts
9. No @ts-ignore, eslint-disable, type:ignore, any, console.log in prod
10. Parameterize queries, validate inputs, no hardcoded secrets

BEFORE CLAIMING DONE:
11. Run ACTUAL verification (build/test/lint) — show real command output
12. Never say "tested/verified/fixed" without evidence
13. After edits: dispatch code-reviewer (sonnet)
14. Before commits: dispatch security-reviewer (opus)

The user may be non-technical — handle everything end-to-end, never skip quality gates.
AUTO-CONTINUE: verify and move on. EXPLORE FIRST: search codebase, only ask product intent.
CODE QUALITY: senior-dev standard. If your edit makes code worse, undo it.

<hook-gates>
pre-edit-reread-guard.sh: BLOCKS edits to unread files (exit 2)
tdd-gate.sh: BLOCKS source edits without test files (exit 2)
tdd-stop-verify.sh: forces continuation if tests missing
</hook-gates>
</enforce>
