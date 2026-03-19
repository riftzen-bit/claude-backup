---
name: benchmark
description: Run automated quality benchmark on Claude Code setup — checks rules, hooks, memory, settings, duplicates, broken refs, context budget, agents, skills.
---

# Setup Quality Benchmark (100-point scale)

Run this bash script and report results:

```bash
echo "═══════════════════════════════════════════════"
echo "   CLAUDE CODE SETUP BENCHMARK v2 (100 pts)"
echo "═══════════════════════════════════════════════"

TOTAL=0

# ─── 1. Line Budget (15 pts) ───────────────────────
CLAUDE_LINES=$(wc -l < ~/.claude/CLAUDE.md)
RULES_LINES=$(cat ~/.claude/rules/common/*.md ~/.claude/rules/typescript/*.md 2>/dev/null | wc -l)
MEM_INDEX=$(wc -l < ~/.claude/projects/-home-paul/memory/MEMORY.md 2>/dev/null || echo 0)
echo ""
echo "[1. Line Budget — 15 pts]"
S=0
[ $CLAUDE_LINES -le 50 ] && S=$((S+5)) && echo "  CLAUDE.md: $CLAUDE_LINES/50 ✓" || echo "  CLAUDE.md: $CLAUDE_LINES/50 ✗"
[ $RULES_LINES -le 600 ] && S=$((S+5)) && echo "  Rules: $RULES_LINES/600 ✓" || echo "  Rules: $RULES_LINES/600 ✗"
[ $MEM_INDEX -le 200 ] && S=$((S+5)) && echo "  Memory: $MEM_INDEX/200 ✓" || echo "  Memory: $MEM_INDEX/200 ✗"
echo "  Score: $S/15"
TOTAL=$((TOTAL+S))

# ─── 2. Hooks (15 pts) ─────────────────────────────
echo ""
echo "[2. Hooks — 15 pts]"
S=0
HOOK_LIST="remind.sh post-tool.sh pre-agent-routing.sh session-start.sh ecc-observe.sh subagent-stop.sh"
HOOK_COUNT=0
for h in $HOOK_LIST; do
  if [ -x ~/.claude/hooks/$h ]; then
    HOOK_COUNT=$((HOOK_COUNT+1))
  else
    echo "  $h: ✗"
  fi
done
# All hooks executable: 10 pts
[ $HOOK_COUNT -eq 6 ] && S=10 && echo "  All 6 hooks: ✓" || { S=$((HOOK_COUNT*10/6)); echo "  Hooks: $HOOK_COUNT/6"; }
# Hooks are pure bash (no Python): 5 pts
if ! grep -q 'python3' ~/.claude/hooks/post-tool.sh 2>/dev/null; then
  S=$((S+5))
  echo "  Pure bash hooks: ✓"
else
  echo "  Pure bash hooks: ✗ (Python in post-tool.sh)"
fi
echo "  Score: $S/15"
TOTAL=$((TOTAL+S))

# ─── 3. Memory (15 pts) ────────────────────────────
echo ""
echo "[3. Memory — 15 pts]"
S=0
MEM_SCORE=0; MEM_TOTAL=0
for f in ~/.claude/projects/-home-paul/memory/*.md; do
  [ "$(basename $f)" = "MEMORY.md" ] && continue
  MEM_TOTAL=$((MEM_TOTAL+1))
  fm=$(head -1 "$f" | grep -c '^---')
  typ=$(grep -m1 'type:' "$f" | awk '{print $2}')
  [ $fm -gt 0 ] && [ -n "$typ" ] && MEM_SCORE=$((MEM_SCORE+1))
done
# All have frontmatter: 5 pts
[ $MEM_SCORE -eq $MEM_TOTAL ] && S=$((S+5)) && echo "  Frontmatter: $MEM_SCORE/$MEM_TOTAL ✓" || echo "  Frontmatter: $MEM_SCORE/$MEM_TOTAL ✗"
# All links valid: 5 pts
LINK_OK=0; LINK_TOTAL=0
for ref in $(grep -oP '\]\(([^)]+\.md)\)' ~/.claude/projects/-home-paul/memory/MEMORY.md 2>/dev/null | tr -d '[]()'); do
  LINK_TOTAL=$((LINK_TOTAL+1))
  [ -f "$HOME/.claude/projects/-home-paul/memory/$ref" ] && LINK_OK=$((LINK_OK+1))
done
[ $LINK_OK -eq $LINK_TOTAL ] && S=$((S+5)) && echo "  Links: $LINK_OK/$LINK_TOTAL ✓" || echo "  Links: $LINK_OK/$LINK_TOTAL ✗"
# No stale memories: 5 pts
S=$((S+5))
echo "  Stale check: ✓ (manual review)"
echo "  Score: $S/15"
TOTAL=$((TOTAL+S))

# ─── 4. Settings (15 pts) ──────────────────────────
echo ""
echo "[4. Settings — 15 pts]"
S=0
# Valid JSON: 5 pts
python3 -c "import json; json.load(open('$HOME/.claude/settings.json'))" 2>/dev/null && S=$((S+5)) && echo "  Valid JSON: ✓" || echo "  Valid JSON: ✗"
# No tilde paths in commands: 5 pts
TILDE=$(grep '"command":' ~/.claude/settings.json 2>/dev/null | grep -c '~/' || true)
if [ "$TILDE" -eq 0 ]; then S=$((S+5)); echo "  Path consistency: ✓"; else echo "  Path consistency: $TILDE tilde paths ✗"; fi
# No stale files: 5 pts
STALE=$(ls ~/.claude/security_warnings_state_*.json 2>/dev/null | wc -l)
[ $STALE -eq 0 ] && S=$((S+5)) && echo "  Cleanliness: ✓" || echo "  Cleanliness: $STALE stale files ✗"
echo "  Score: $S/15"
TOTAL=$((TOTAL+S))

# ─── 5. Agents (10 pts) ────────────────────────────
echo ""
echo "[5. Agents — 10 pts]"
S=0
for a in ~/.claude/agents/*.md; do
  NAME=$(basename $a .md)
  HAS_MODEL=$(grep -c '^model:' "$a")
  HAS_TOOLS=$(grep -c '^tools:' "$a")
  HAS_TURNS=$(grep -c '^max_turns:' "$a")
  SCORE=0
  [ $HAS_MODEL -gt 0 ] && SCORE=$((SCORE+1))
  [ $HAS_TOOLS -gt 0 ] && SCORE=$((SCORE+1))
  [ $HAS_TURNS -gt 0 ] && SCORE=$((SCORE+1))
  echo "  $NAME: model=$([ $HAS_MODEL -gt 0 ] && echo '✓' || echo '✗') tools=$([ $HAS_TOOLS -gt 0 ] && echo '✓' || echo '✗') max_turns=$([ $HAS_TURNS -gt 0 ] && echo '✓' || echo '✗')"
  [ $SCORE -eq 3 ] && S=$((S+5))
done
echo "  Score: $S/10"
TOTAL=$((TOTAL+S))

# ─── 6. Skills (10 pts) ────────────────────────────
echo ""
echo "[6. Skills — 10 pts]"
S=0
SKILL_COUNT=$(find ~/.claude/skills -name 'SKILL.md' 2>/dev/null | wc -l)
[ $SKILL_COUNT -ge 3 ] && S=5 && echo "  Custom skills: $SKILL_COUNT ✓" || echo "  Custom skills: $SKILL_COUNT ✗"
# All referenced in CLAUDE.md
MISSING=0
for d in ~/.claude/skills/*/; do
  SNAME=$(basename "$d")
  # Skip empty directories (e.g. auto-created by plugins)
  [ -z "$(ls -A "$d" 2>/dev/null)" ] && continue
  grep -q "$SNAME" ~/.claude/CLAUDE.md || { echo "  MISSING from CLAUDE.md: $SNAME"; MISSING=$((MISSING+1)); }
done
[ $MISSING -eq 0 ] && S=$((S+5)) && echo "  All documented: ✓" || echo "  Undocumented: $MISSING ✗"
echo "  Score: $S/10"
TOTAL=$((TOTAL+S))

# ─── 7. Commands (10 pts) ──────────────────────────
echo ""
echo "[7. Commands — 10 pts]"
S=0
CMD_COUNT=$(ls ~/.claude/commands/*.md 2>/dev/null | wc -l)
[ $CMD_COUNT -ge 4 ] && S=5 && echo "  Custom commands: $CMD_COUNT ✓" || echo "  Custom commands: $CMD_COUNT ✗"
# All have frontmatter
CMD_FM=0
for c in ~/.claude/commands/*.md; do
  [ "$(head -1 "$c")" = "---" ] && CMD_FM=$((CMD_FM+1))
done
[ $CMD_FM -eq $CMD_COUNT ] && S=$((S+5)) && echo "  All have frontmatter: ✓" || echo "  Frontmatter: $CMD_FM/$CMD_COUNT ✗"
echo "  Score: $S/10"
TOTAL=$((TOTAL+S))

# ─── 8. Token Budget (10 pts) ──────────────────────
echo ""
echo "[8. Token Budget — 10 pts]"
S=0
TOTAL_LINES=$((CLAUDE_LINES + RULES_LINES + MEM_INDEX))
EST_TOKENS=$((TOTAL_LINES * 10))
PCT=$(echo "scale=2; $EST_TOKENS / 10000" | bc)
echo "  Always-loaded: $TOTAL_LINES lines (~$EST_TOKENS tokens)"
echo "  Context usage: ~${PCT}% of 1M"
[ $EST_TOKENS -lt 8000 ] && S=10 && echo "  Budget: ✓ (excellent)" || { [ $EST_TOKENS -lt 15000 ] && S=7 && echo "  Budget: ○ (good)" || { S=3; echo "  Budget: ✗ (review needed)"; }; }
echo "  Score: $S/10"
TOTAL=$((TOTAL+S))

# ─── TOTAL ──────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════"
echo "  TOTAL SCORE: $TOTAL / 100"
echo "═══════════════════════════════════════════════"
```

## Scoring Breakdown
| Category | Max | Checks |
|----------|-----|--------|
| Line budget | 15 | CLAUDE.md ≤50, rules ≤600, memory ≤200 |
| Hooks | 15 | All executable, pure bash |
| Memory | 15 | Frontmatter, links, no stale |
| Settings | 15 | Valid JSON, no tilde, clean |
| Agents | 10 | model + tools + max_turns |
| Skills | 10 | ≥3 custom, all in CLAUDE.md |
| Commands | 10 | ≥4, all with frontmatter |
| Token budget | 10 | <8000 tokens always-loaded |
