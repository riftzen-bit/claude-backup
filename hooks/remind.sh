#!/bin/bash
# UserPromptSubmit — OmO-style comprehensive injection on every user message
# Transparent, structured, clearly visible — like Oh My OpenAgent's message transform

STATE_DIR="/home/paul/.claude/state"
mkdir -p "$STATE_DIR"

# ══════════════════════════════════════════════════════════
# SECTION 1: Core enforcement (from enforce.md)
# ══════════════════════════════════════════════════════════
ENFORCE_FILE="/home/paul/.claude/enforce.md"
[ -f "$ENFORCE_FILE" ] && cat "$ENFORCE_FILE"

# ══════════════════════════════════════════════════════════
# SECTION 2: Agent roster + routing table
# ══════════════════════════════════════════════════════════
cat <<'AGENTS'

<agent-roster>
SPECIALIST AGENTS — delegate aggressively (1 Opus = 60 Haiku)
┌────────────────────┬─────────┬─────────────────────────────────────┐
│ Agent              │ Model   │ Capabilities                        │
├────────────────────┼─────────┼─────────────────────────────────────┤
│ repo-scout         │ haiku   │ File discovery, validators, cross-  │
│                    │         │ tool rules, convention matching     │
│ planner            │ sonnet  │ Intent classification, plans, risks │
│ code-reviewer      │ sonnet  │ Post-edit quality review            │
│ validator          │ sonnet  │ Build/typecheck/lint/tests runner   │
│ security-reviewer  │ opus    │ Pre-commit security scan            │
│ open-source-librarian│sonnet │ Library/docs/source research        │
│ media-interpreter  │ haiku   │ PDFs, images, diagrams extraction   │
└────────────────────┴─────────┴─────────────────────────────────────┘
</agent-roster>

<intent-routing>
CLASSIFY BEFORE ACTING — adapt depth to complexity:
Trivial  (<10 lines, 1 file)  → do directly, no planning
Simple   (1-2 files, clear)   → 1-2 questions max, then execute
Medium   (3-5 files, scoped)  → brief plan, validate approach, execute
Complex  (5+ files, arch)     → full plan with user review first
Research (unclear path)       → investigate, propose options, then plan
Default: Simple unless evidence says otherwise.
</intent-routing>

<delegation-format>
STRUCTURED DELEGATION — for every subagent prompt:
1. TASK: exact requirement (quote user's words)
2. EXPECTED OUTCOME: files/behavior/output expected
3. SCOPE: what to touch and what NOT to touch
4. CONTEXT: conventions, decisions, gotchas from codebase
Skip irrelevant sections. Include TDD rules + verification commands for coding work.
</delegation-format>

AGENTS

# ══════════════════════════════════════════════════════════
# SECTION 3: Cross-tool rules injection (cached per directory)
# ══════════════════════════════════════════════════════════
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
  printf '<cross-tool-context>\n'
  cat "$RULES_CACHE"
  printf '</cross-tool-context>\n'
fi

# ══════════════════════════════════════════════════════════
# SECTION 4: Project type detection (skip home directory)
# ══════════════════════════════════════════════════════════
PROJECT_LANGS=""
if [ "$(pwd)" != "$HOME" ]; then
  [ -f "package.json" ] && PROJECT_LANGS="javascript"
  [ -f "tsconfig.json" ] && PROJECT_LANGS="typescript"
  [ -f "pyproject.toml" ] || [ -f "setup.py" ] && PROJECT_LANGS="python"
  [ -f "go.mod" ] && PROJECT_LANGS="go"
  [ -f "Cargo.toml" ] && PROJECT_LANGS="rust"
  [ -f "build.gradle.kts" ] || [ -f "build.gradle" ] && PROJECT_LANGS="kotlin/java"
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

  printf '<project-context>\n'
  printf 'Project type: {"languages":["%s"],"frameworks":[%s],"primary":"%s","projectDir":"%s"}\n' \
    "$PROJECT_LANGS" \
    "$([ -n "$FRAMEWORKS" ] && printf '"%s"' "$FRAMEWORKS" || printf '')" \
    "$PROJECT_LANGS" \
    "$(pwd)"
  printf '</project-context>\n'
fi

# ══════════════════════════════════════════════════════════
# SECTION 5: Git context (branch + recent changes)
# ══════════════════════════════════════════════════════════
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  DIRTY=$(git diff --name-only 2>/dev/null | head -5)
  STAGED=$(git diff --cached --name-only 2>/dev/null | head -5)

  if [ -n "$BRANCH" ]; then
    printf '<git-context>\n'
    printf 'Branch: %s\n' "$BRANCH"
    [ -n "$DIRTY" ] && printf 'Modified: %s\n' "$(echo "$DIRTY" | tr '\n' ', ' | sed 's/,$//')"
    [ -n "$STAGED" ] && printf 'Staged: %s\n' "$(echo "$STAGED" | tr '\n' ', ' | sed 's/,$//')"
    printf '</git-context>\n'
  fi
fi
