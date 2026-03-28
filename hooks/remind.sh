#!/bin/bash
# UserPromptSubmit — OmO-style comprehensive injection on every user message
# FIXED: Uses JSON additionalContext format (plain text stdout is buggy in Claude Code)
# See: https://github.com/anthropics/claude-code/issues/13912

STATE_DIR="/home/paul/.claude/state"
mkdir -p "$STATE_DIR"

# ══════════════════════════════════════════════════════════
# BUILD CONTEXT STRING (collect all sections into one variable)
# ══════════════════════════════════════════════════════════
CTX=""

# SECTION 1: Core enforcement (from enforce.md)
ENFORCE_FILE="/home/paul/.claude/enforce.md"
[ -f "$ENFORCE_FILE" ] && CTX="$(cat "$ENFORCE_FILE")"

# SECTION 2: Agent roster + routing table
CTX="${CTX}

<agent-roster>
SPECIALIST AGENTS — delegate aggressively (1 Opus = 60 Haiku)
+--------------------+---------+-------------------------------------+
| Agent              | Model   | Capabilities                        |
+--------------------+---------+-------------------------------------+
| repo-scout         | haiku   | File discovery, convention matching |
| planner            | sonnet  | Intent classification, plans, risks |
| code-reviewer      | sonnet  | Post-edit quality review            |
| validator          | sonnet  | Build/typecheck/lint/tests runner   |
| security-reviewer  | opus    | Pre-commit security scan            |
| open-source-librarian| sonnet| Library/docs/source research        |
| media-interpreter  | haiku   | PDFs, images, diagrams extraction   |
+--------------------+---------+-------------------------------------+
</agent-roster>

<intent-routing>
CLASSIFY BEFORE ACTING — adapt depth to complexity:
Trivial  (<10 lines, 1 file)  -> do directly, no planning
Simple   (1-2 files, clear)   -> 1-2 questions max, then execute
Medium   (3-5 files, scoped)  -> brief plan, validate approach, execute
Complex  (5+ files, arch)     -> full plan with user review first
Research (unclear path)        -> investigate, propose options, then plan
Default: Simple unless evidence says otherwise.
</intent-routing>

<delegation-format>
STRUCTURED DELEGATION — 6-section prompt for every subagent:
1. TASK: exact requirement (quote user's words). Be obsessively specific.
2. EXPECTED OUTCOME: files created/modified, behavior change, verification command.
3. SCOPE: files to touch and NOT to touch.
4. MUST DO: patterns to follow, tests to write, notepad entries.
5. MUST NOT DO: scope boundaries, features to skip, files to leave alone.
6. CONTEXT: conventions, prior decisions, dependencies, gotchas.
Skip sections that don't apply. Include TDD rules + verification commands for coding work.
</delegation-format>"

# SECTION 3: Cross-tool rules injection (cached per directory)
DIR_HASH=$(printf '%s' "$(pwd)" | md5sum | cut -c1-8)
RULES_CACHE="$STATE_DIR/cross-rules-$DIR_HASH.txt"

REBUILD=0
[ ! -f "$RULES_CACHE" ] && REBUILD=1
[ "$REBUILD" = "0" ] && [ "$(find "$RULES_CACHE" -mmin +1 2>/dev/null)" ] && REBUILD=1

if [ "$REBUILD" = "1" ]; then
  CONTENT=""
  for f in .github/copilot-instructions.md .windsurfrules .clinerules AGENTS.md; do
    [ -f "$f" ] && CONTENT="${CONTENT}[Rule: ${f}]
$(head -80 "$f")

"
  done
  if [ -d ".cursor/rules" ]; then
    for f in .cursor/rules/*.md .cursor/rules/*.mdc; do
      [ -f "$f" ] && CONTENT="${CONTENT}[Rule: .cursor/rules/$(basename "$f")]
$(head -40 "$f")

"
    done
  fi
  printf '%s' "$CONTENT" > "$RULES_CACHE"
fi

if [ -s "$RULES_CACHE" ]; then
  CTX="${CTX}
<cross-tool-context>
$(cat "$RULES_CACHE")
</cross-tool-context>"
fi

# SECTION 4: Project type detection
PROJECT_LANGS=""
if [ "$(pwd)" != "$HOME" ]; then
  [ -f "package.json" ] && PROJECT_LANGS="javascript"
  [ -f "tsconfig.json" ] && PROJECT_LANGS="typescript"
  ([ -f "pyproject.toml" ] || [ -f "setup.py" ]) && PROJECT_LANGS="python"
  [ -f "go.mod" ] && PROJECT_LANGS="go"
  [ -f "Cargo.toml" ] && PROJECT_LANGS="rust"
  ([ -f "build.gradle.kts" ] || [ -f "build.gradle" ]) && PROJECT_LANGS="kotlin/java"
  [ -f "Package.swift" ] && PROJECT_LANGS="swift"
fi

if [ -n "$PROJECT_LANGS" ]; then
  FRAMEWORKS=""
  if [ -f "package.json" ]; then
    grep -q '"next"' package.json 2>/dev/null && FRAMEWORKS="nextjs"
    grep -q '"react"' package.json 2>/dev/null && FRAMEWORKS="${FRAMEWORKS:+$FRAMEWORKS,}react"
    grep -q '"vue"' package.json 2>/dev/null && FRAMEWORKS="${FRAMEWORKS:+$FRAMEWORKS,}vue"
    grep -q '"svelte"' package.json 2>/dev/null && FRAMEWORKS="${FRAMEWORKS:+$FRAMEWORKS,}svelte"
    grep -q '"express"' package.json 2>/dev/null && FRAMEWORKS="${FRAMEWORKS:+$FRAMEWORKS,}express"
  fi
  [ -f "pyproject.toml" ] && grep -q 'django' pyproject.toml 2>/dev/null && FRAMEWORKS="django"
  [ -f "pyproject.toml" ] && grep -q 'fastapi' pyproject.toml 2>/dev/null && FRAMEWORKS="${FRAMEWORKS:+$FRAMEWORKS,}fastapi"

  CTX="${CTX}
<project-context>
Project type: languages=[${PROJECT_LANGS}] frameworks=[${FRAMEWORKS}] dir=$(pwd)
</project-context>"
fi

# SECTION 5: Git context
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  DIRTY=$(git diff --name-only 2>/dev/null | head -5)
  STAGED=$(git diff --cached --name-only 2>/dev/null | head -5)

  if [ -n "$BRANCH" ]; then
    GIT_CTX="Branch: ${BRANCH}"
    [ -n "$DIRTY" ] && GIT_CTX="${GIT_CTX}\nModified: $(echo "$DIRTY" | tr '\n' ', ' | sed 's/,$//')"
    [ -n "$STAGED" ] && GIT_CTX="${GIT_CTX}\nStaged: $(echo "$STAGED" | tr '\n' ', ' | sed 's/,$//')"
    CTX="${CTX}
<git-context>
${GIT_CTX}
</git-context>"
  fi
fi

# SECTION 6: Todo continuation
if [ -d ".claude/notepads" ] && [ "$(ls -A .claude/notepads 2>/dev/null)" ]; then
  ACTIVE=$(ls -d .claude/notepads/*/ 2>/dev/null | head -1)
  if [ -n "$ACTIVE" ]; then
    TASK_NAME=$(basename "$ACTIVE")
    CTX="${CTX}
<todo-continuation>
Active work detected: ${TASK_NAME}
Read .claude/notepads/${TASK_NAME}/ before starting new work. Resume incomplete tasks first.
</todo-continuation>"
  fi
fi

# ══════════════════════════════════════════════════════════
# OUTPUT: systemMessage (visible warning) + additionalContext (full injection)
# systemMessage = shown to user as warning in UI
# additionalContext = injected into Claude's context (discrete)
# ══════════════════════════════════════════════════════════

# Count active sections for summary
SECTION_COUNT=$(echo "$CTX" | grep -o '<[a-z-]*>' | sort -u | wc -l)
CTX_LEN=${#CTX}

# Build visible summary for systemMessage
SUMMARY="[OmO Inject] ${SECTION_COUNT} sections | ${CTX_LEN} chars"
[ -n "$PROJECT_LANGS" ] && SUMMARY="${SUMMARY} | ${PROJECT_LANGS}"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 && SUMMARY="${SUMMARY} | $(git branch --show-current 2>/dev/null)"

# Output JSON with both visible message + full context injection
python3 -c "
import json, sys
ctx = sys.stdin.read()
summary = sys.argv[1]
print(json.dumps({
    'systemMessage': summary,
    'hookSpecificOutput': {
        'hookEventName': 'UserPromptSubmit',
        'additionalContext': ctx
    }
}))
" "$SUMMARY" <<< "$CTX"

exit 0
