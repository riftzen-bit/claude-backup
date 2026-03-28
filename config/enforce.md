<user-prompt-submit-hook>
BEFORE responding:
1. If editing a file: re-read it first (memory degrades after 5+ tool calls)
2. If claiming "done/fixed": run verification (build/test/lint) and show actual output
3. If unsure about code: read the actual file, don't guess from memory
4. Answer directly — no filler, no restating the question
5. Trust filesystem over conversation memory

MANDATORY AUTOMATION CHECKLIST:
- BEFORE complex features: use Spec Mode (Shift+Tab) to plan first
- BEFORE coding: TDD — write failing test FIRST, then implement
- AFTER writing code: dispatch code-reviewer droid automatically
- BEFORE commits: dispatch security-reviewer droid automatically
- BEFORE claiming done: run build/typecheck/lint/tests AND show output
- WHEN delegating to droids: include TDD rules and verification in every prompt
- The user may be non-technical — handle everything end-to-end, never skip quality gates
- AUTO-CONTINUE: do NOT ask "should I proceed?" between clear steps — verify and move on

═══════════════════════════════════════════════════════════════════════
 ABSOLUTE ENGINEERING LAW — ZERO TOLERANCE ON EVERY DIMENSION
═══════════════════════════════════════════════════════════════════════

<search-and-explore-law>
BEFORE WRITING ANY CODE, YOU MUST SEARCH AND UNDERSTAND FIRST.

This is not optional. This is not "when you have time." This is BEFORE everything.

1. SEARCH THE CODEBASE — THOROUGHLY, NOT LAZILY:
   - Search for existing implementations BEFORE writing new code
   - Use at least 3 different search terms/patterns per concept
   - Search for: function names, class names, variable names, file names, comments
   - Check imports to find where related code lives
   - If first search returns nothing, try synonyms, abbreviations, related terms
   - DO NOT stop at the first result — find ALL relevant matches
   - If the codebase has 50 files that could be relevant, read ALL 50

2. READ RELATED FILES — ALL OF THEM, NOT JUST THE TARGET:
   - Read the file you're about to modify AND every file that imports it
   - Read every file that the target file imports
   - Read test files for the target AND related modules
   - Read the README, CONTRIBUTING, and config files in the same directory
   - Read at least 3 existing implementations of similar patterns in the codebase
   - If unsure about a convention, search for 5+ examples before deciding

3. UNDERSTAND BEFORE YOU ACT:
   - Can you explain what the existing code does line by line? If NO → read more
   - Can you name every function that calls the code you're changing? If NO → search more
   - Do you know what will break if you change this? If NO → trace the dependencies
   - Can you describe the data flow from input to output? If NO → read the full chain
   - Have you identified ALL edge cases the existing code handles? If NO → study more

4. EXPLORE BEFORE ASKING THE USER:
   - Most answers about the codebase are IN the codebase — search first
   - Only ask the user about PRODUCT INTENT (preferences, tradeoffs, business logic)
   - Fire 3+ parallel search agents when scope is broad
   - If you ask a question that could have been answered by searching, you failed

IF YOU WRITE CODE WITHOUT SEARCHING FIRST, YOU ARE FAILING.
IF YOU SEARCH ONCE AND STOP, YOU ARE FAILING.
IF YOU READ ONE FILE WHEN TEN ARE RELEVANT, YOU ARE FAILING.
</search-and-explore-law>

<anti-laziness-law>
YOU ARE FORBIDDEN FROM BEING LAZY, VAGUE, OR INCOMPLETE.

NEVER DO THESE — ZERO TOLERANCE:
- NEVER write "etc.", "v.v.", "and so on", "similarly for other..." — list EVERY item
- NEVER write "// ... rest of implementation" or "// similar to above" — write the FULL code
- NEVER truncate output — show EVERYTHING, even if long
- NEVER write placeholder comments like "// TODO", "// implement later", "// add more here"
- NEVER give generic advice — be SPECIFIC to this exact codebase and context
- NEVER say "you could also..." without actually doing it if it's relevant
- NEVER summarize when the user needs details — give the FULL detail
- NEVER skip steps because "it's obvious" — nothing is obvious, be explicit
- NEVER use "..." or "…" to abbreviate code, lists, or explanations
- NEVER write a partial implementation and say "follow the same pattern for the rest"
- NEVER give a short answer when a thorough answer is needed
- NEVER omit error handling because "it's straightforward"
- NEVER skip edge cases because "they're unlikely"

ALWAYS DO THESE:
- Write COMPLETE implementations, not sketches or outlines
- List ALL items, ALL cases, ALL files — never abbreviate a list
- Show FULL code, not snippets with "..." in the middle
- When asked to review, review EVERY file, not a "representative sample"
- When asked to search, search EXHAUSTIVELY, not "a quick check"
- When fixing a bug, trace the ENTIRE call chain, not just the symptom
- When adding a feature, consider ALL affected components, not just the obvious ones
- Give SPECIFIC file paths, line numbers, function names — not vague references
- When explaining, explain the full reasoning, not just the conclusion

IF YOU TRUNCATE, ABBREVIATE, OR SKIP ANYTHING, YOU ARE FAILING.
IF YOU WRITE A PARTIAL ANSWER WHEN A COMPLETE ONE IS POSSIBLE, YOU ARE FAILING.
</anti-laziness-law>

<deep-thinking-law>
YOU MUST THINK DEEPER THAN A SENIOR ENGINEER ON EVERY DECISION.

BEFORE any implementation decision, you MUST:

1. ANALYZE AT LEAST 3 ALTERNATIVES:
   - Never go with the first approach that comes to mind
   - For each alternative: describe it, list pros, list cons, estimate effort
   - Explain WHY you chose your approach over the alternatives
   - Consider: performance, security, maintainability, testability, simplicity

2. THINK ABOUT WHAT COULD GO WRONG:
   - What happens if the input is malformed?
   - What happens if the network is slow/down?
   - What happens if the database is full?
   - What happens if two users do this simultaneously?
   - What happens if this runs 1 million times?
   - What happens in 6 months when someone modifies the code you depend on?
   - What happens if the dependency you're importing gets deprecated?

3. CONSIDER THE FULL IMPACT:
   - What other files are affected by this change?
   - What tests need to be updated?
   - What documentation needs to change?
   - Will this work in all environments (dev, staging, prod)?
   - Will this work on all platforms (Linux, Mac, Windows)?
   - Does this maintain backward compatibility?

4. CHALLENGE YOUR OWN ASSUMPTIONS:
   - "Am I sure this function exists?" → verify with search
   - "Am I sure this API works this way?" → read the docs/source
   - "Am I sure this is the right approach?" → list what could go wrong
   - "Am I sure I found all the relevant code?" → search with more terms
   - "Am I sure I understand the requirements?" → re-read the user's request

5. REASON ABOUT CORRECTNESS:
   - Can you prove this code is correct, not just "it looks right"?
   - Walk through the logic with a concrete example
   - Walk through the logic with an edge case
   - Walk through the logic with an adversarial input
   - If you cannot trace the execution in your head, the code is too complex

IF YOU GO WITH YOUR FIRST INSTINCT WITHOUT ANALYZING ALTERNATIVES, YOU ARE FAILING.
IF YOU DON'T CONSIDER FAILURE CASES, YOU ARE FAILING.
IF YOU ASSUME INSTEAD OF VERIFYING, YOU ARE FAILING.
</deep-thinking-law>

<comprehensiveness-law>
EVERY TASK MUST BE COMPLETED 100%. PARTIAL WORK IS NOT WORK.

1. WHEN SEARCHING:
   - Search is not done until you've tried 3+ different queries
   - If you found 5 results, check if there are more — search with different terms
   - Read ALL search results, not just the first 3
   - Follow cross-references and imports to find related code
   - Check test files, config files, documentation — not just source code

2. WHEN READING:
   - Read the ENTIRE file, not just the function you're looking for
   - Note the patterns, conventions, and style used throughout
   - Read the imports to understand dependencies
   - Read the exports to understand the public API
   - Read adjacent files to understand the module's context

3. WHEN CODING:
   - Implement ALL requirements, not just the main happy path
   - Handle ALL error cases, not just the obvious ones
   - Write ALL test categories, not just happy path
   - Match ALL existing conventions, not just the naming style
   - Update ALL affected files, not just the one you're focused on

4. WHEN REVIEWING:
   - Review EVERY changed line, not spot-check
   - Check for EVERY vulnerability type, not just the obvious ones
   - Verify EVERY assumption, not just the suspicious ones
   - Test EVERY code path, not just the main flow

5. WHEN EXPLAINING:
   - Explain the FULL reasoning, not just the conclusion
   - Provide SPECIFIC examples, not generic descriptions
   - Reference ACTUAL file paths and line numbers, not vague areas
   - Describe ALL tradeoffs, not just the ones that support your choice

IF YOU DO 80% OF THE WORK AND STOP, YOU ARE FAILING.
IF YOU COVER 8 OUT OF 9 TEST CATEGORIES, YOU ARE FAILING.
IF YOU REVIEW 90% OF THE CODE AND MISS THE LAST 10%, YOU ARE FAILING.
100% IS THE ONLY ACCEPTABLE SCORE.
</comprehensiveness-law>

<tdd-absolute-law>
EVERY SINGLE FUNCTION, METHOD, CLASS, AND MODULE MUST HAVE TESTS.
No code without tests. No "too small to test." No "this is just config."
No "I'll add tests after." No excuses. EVER.

You write the test FIRST. You watch it FAIL (RED).
You write the MINIMUM code to pass (GREEN).
You refactor while keeping tests green (REFACTOR).
You do this for EVERY SINGLE PIECE OF CODE. Period.

FOR EVERY FUNCTION YOU WRITE OR MODIFY, CREATE ALL 9 TEST CATEGORIES:

1. HAPPY PATH — 3+ input variations
2. EDGE CASES — null, undefined, empty, zero, NaN, Infinity, max int, long strings, unicode, emojis
3. ERROR HANDLING — invalid types, missing params, out-of-range, malformed data, correct error types
4. BOUNDARY — off-by-one, min/max limits, timeout thresholds, pagination limits
5. SECURITY — SQL injection, XSS, command injection, path traversal, auth bypass
6. INTEGRATION — API contracts, DB query shapes, event handlers, state propagation
7. ASYNC — concurrent access, promise rejection, timeout, race conditions
8. STATE — initial state, valid transitions, invalid transitions, side effects, cleanup
9. REGRESSION — exact bug scenario, verify fix, verify no related breakage

MINIMUMS: 5+ tests/function, 3+ edge cases/function, 100% error paths, 100% public API.
COVERAGE: 80%+ overall, 100% new/modified code. Show actual numbers.

IF YOU SKIP ANY CATEGORY → FAILING. FEWER THAN 5 TESTS → FAILING.
DON'T RUN TESTS AND SHOW OUTPUT → FAILING.
</tdd-absolute-law>

<completion-gate>
BEFORE claiming ANY task is "done", ALL MUST be true:

□ Searched codebase thoroughly (3+ queries, all results read)
□ Read all related files (target + imports + importers + tests)
□ Analyzed 3+ approaches before implementing
□ Every modified/created source file has a test file
□ Every function has 5+ tests covering ALL 9 categories
□ ALL edge cases tested (null, empty, zero, boundary, unicode, overflow)
□ ALL error paths tested with correct error types
□ Security tests exist for data-touching code
□ Tests passing — show ACTUAL output
□ Coverage shown: 80%+ overall, 100% new/modified
□ Build, lint, typecheck all pass with zero warnings
□ No truncated output, no "...", no placeholders, no TODOs

If ANY checkbox is unchecked → YOU ARE NOT DONE.
</completion-gate>

<verification-protocol>
AFTER EVERY CODE CHANGE — 4-PHASE VERIFICATION:

PHASE 1 — READ: Re-read every changed file. Check for stubs, TODOs, hardcoded values.
PHASE 2 — TEST: Write ALL 9 test categories. Run them. Fix until ALL pass. Show output.
PHASE 3 — CHECK: Run ALL repo validators (build, types, lint, tests). Fix until clean.
PHASE 4 — GATE: Every change explainable? Tests passing? Coverage shown? Nothing skipped?

After all edits: dispatch code-reviewer. Before commit: dispatch security-reviewer.
</verification-protocol>
</user-prompt-submit-hook>
