---
name: benchmark
description: Run automated quality benchmark on Claude Code setup — checks rules, hooks, memory, settings, duplicates, broken refs, context budget.
---

# Setup Quality Benchmark

Run a comprehensive automated audit of the entire Claude Code configuration.

## Checks to Run

Execute this bash script and report results:

```bash
echo "═══════════════════════════════════════════"
echo "       CLAUDE CODE SETUP BENCHMARK"
echo "═══════════════════════════════════════════"

# 1. Line counts
CLAUDE_LINES=$(wc -l < ~/.claude/CLAUDE.md)
RULES_LINES=$(cat ~/.claude/rules/common/*.md ~/.claude/rules/typescript/*.md 2>/dev/null | wc -l)
MEM_INDEX=$(wc -l < ~/.claude/projects/-home-paul/memory/MEMORY.md 2>/dev/null || echo 0)

echo ""
echo "[Lines]"
echo "  CLAUDE.md:    $CLAUDE_LINES/50  $([ $CLAUDE_LINES -le 50 ] && echo OK || echo OVER)"
echo "  Rules total:  $RULES_LINES/600 $([ $RULES_LINES -le 600 ] && echo OK || echo OVER)"
echo "  Memory index: $MEM_INDEX/200 $([ $MEM_INDEX -le 200 ] && echo OK || echo OVER)"

# 2. Hooks
echo ""
echo "[Hooks]"
for h in remind.sh post-tool.sh pre-agent-routing.sh; do
  [ -x ~/.claude/hooks/$h ] && echo "  $h: OK" || echo "  $h: MISSING/NOT EXEC"
done

# 3. Broken refs
echo ""
echo "[References]"
BROKEN=$(grep -rP '\[.*?\]\(\.\..*?\)' ~/.claude/rules/typescript/*.md 2>/dev/null | head -5)
[ -z "$BROKEN" ] && echo "  No broken refs: OK" || echo "  BROKEN: $BROKEN"

# 4. Stale files
STALE=$(ls ~/.claude/security_warnings_state_*.json 2>/dev/null | wc -l)
echo "  Stale files: $STALE $([ $STALE -eq 0 ] && echo OK || echo CLEAN_NEEDED)"

# 5. Memory frontmatter
echo ""
echo "[Memory]"
for f in ~/.claude/projects/-home-paul/memory/*.md; do
  [ "$(basename $f)" = "MEMORY.md" ] && continue
  fm=$(head -1 "$f" | grep -c '^---')
  echo "  $(basename $f .md): $([ $fm -gt 0 ] && echo OK || echo NO_FRONTMATTER)"
done

# 6. Settings
echo ""
echo "[Settings]"
python3 -c "
import json
d=json.load(open('$HOME/.claude/settings.json'))
print(f'  Language: {d.get(\"language\",\"?\")}')
print(f'  Plugins: {sum(1 for v in d.get(\"enabledPlugins\",{}).values() if v)} active')
print(f'  Hooks: {len(d.get(\"hooks\",{}))} event types')
"

echo ""
echo "═══════════════════════════════════════════"
```

## Scoring

After running, score each category:
- Lines: within limits = 10/10
- Hooks: all functional = 10/10
- References: no broken = 10/10
- Stale files: none = 10/10
- Memory: all valid = 10/10
- Settings: all correct = 10/10
- Duplicates: minimal = 10/10

Report total: X/70

## Fix Protocol

For any FAIL/OVER/MISSING result:
1. Identify root cause
2. Fix immediately
3. Re-run benchmark to verify
