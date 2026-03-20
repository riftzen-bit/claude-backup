---
name: benchmark
description: Run an automated quality benchmark on the Claude Code setup — line budgets, hook registrations, memory hygiene, settings safety, agents, skills, commands, and token budget.
---

# Setup Quality Benchmark (100-point scale)

Run this Python script and report results:

```bash
python3 - <<'PY'
import json
import os
import re
import subprocess
from pathlib import Path

root = Path.home() / ".claude"
memory_dir = root / "projects" / "-home-paul" / "memory"

def lines(path: Path) -> int:
    return len(path.read_text(encoding="utf-8").splitlines())

def md_links(text: str):
    return re.findall(r'\]\(([^)]+\.md)\)', text)

def section_bullets(text: str, heading: str):
    pattern = rf'^## {re.escape(heading)}\n(?P<body>.*?)(?:\n## |\Z)'
    match = re.search(pattern, text, re.M | re.S)
    if not match:
        return []
    return re.findall(r'^- `?([a-z0-9-]+)`?:', match.group('body'), re.M)

def score_ratio(passed: int, total: int, points: int) -> int:
    if total == 0:
        return 0
    return round(points * passed / total)

settings = json.loads((root / "settings.json").read_text(encoding="utf-8"))
claude_text = (root / "CLAUDE.md").read_text(encoding="utf-8")
memory_text = (memory_dir / "MEMORY.md").read_text(encoding="utf-8")
enforce_lines = lines(root / "enforce.md")

rule_files = sorted((root / "rules" / "common").glob("*.md")) + sorted((root / "rules" / "typescript").glob("*.md"))
agent_files = sorted((root / "agents").glob("*.md"))
skill_files = sorted((root / "skills").glob("*/SKILL.md"))
command_files = sorted((root / "commands").glob("*.md"))
memory_files = sorted(memory_dir.glob("*.md"))

hook_entries = []
for event, groups in settings.get("hooks", {}).items():
    for group in groups:
        for hook in group.get("hooks", []):
            hook_entries.append((event, hook.get("command", "")))

script_hook_paths = []
inline_hooks = 0
for _, command in hook_entries:
    first = command.split()[0] if command else ""
    if first.startswith("/home/paul/.claude/hooks/") and first.endswith(".sh"):
        script_hook_paths.append(Path(first))
    else:
        inline_hooks += 1

script_hook_status = []
for path in sorted(set(script_hook_paths)):
    syntax = subprocess.run(["/bin/bash", "-n", str(path)], capture_output=True, text=True)
    script_hook_status.append((path, path.exists(), os.access(path, os.X_OK), syntax.returncode == 0))

auto_skills = section_bullets(claude_text, "Auto Skills")
auto_skill_set = {name for name in auto_skills}
installed_skill_set = {path.parent.name for path in skill_files}
optional_skills = sorted(installed_skill_set - auto_skill_set)

agent_ok = 0
for path in agent_files:
    text = path.read_text(encoding="utf-8")
    if re.search(r'^model:', text, re.M) and re.search(r'^tools:', text, re.M) and re.search(r'^max_turns:', text, re.M):
        agent_ok += 1

command_ok = 0
for path in command_files:
    text = path.read_text(encoding="utf-8")
    name_ok = re.search(rf'^name:\s*{re.escape(path.stem)}\s*$', text, re.M)
    frontmatter_ok = text.startswith("---\n")
    if name_ok and frontmatter_ok:
        command_ok += 1

memory_leafs = [path for path in memory_files if path.name != "MEMORY.md"]
memory_frontmatter_ok = 0
for path in memory_leafs:
    text = path.read_text(encoding="utf-8")
    if text.startswith("---\n") and re.search(r'^type:\s*\S+', text, re.M):
        memory_frontmatter_ok += 1

memory_links = md_links(memory_text)
memory_links_ok = sum((memory_dir / link).exists() for link in memory_links)
all_memory_links_ok = 0
all_memory_link_total = 0
for path in memory_files:
    for link in md_links(path.read_text(encoding="utf-8")):
        all_memory_link_total += 1
        if (path.parent / link).exists():
            all_memory_links_ok += 1

claude_lines = lines(root / "CLAUDE.md")
rules_lines = sum(lines(path) for path in rule_files)
memory_lines = lines(memory_dir / "MEMORY.md")
always_loaded_lines = claude_lines + enforce_lines + rules_lines + memory_lines
est_tokens = always_loaded_lines * 10
context_pct = est_tokens / 1_000_000 * 100

print("═══════════════════════════════════════════════")
print("   CLAUDE CODE SETUP BENCHMARK v3 (100 pts)")
print("═══════════════════════════════════════════════")

total = 0

print("\n[1. Line Budget — 15 pts]")
s = 0
checks = [
    (claude_lines <= 50, f"CLAUDE.md: {claude_lines}/50"),
    (rules_lines <= 600, f"Rules: {rules_lines}/600"),
    (memory_lines <= 200, f"Memory: {memory_lines}/200"),
]
for ok, label in checks:
    print(f"  {label} {'✓' if ok else '✗'}")
    s += 5 if ok else 0
print(f"  Score: {s}/15")
total += s

print("\n[2. Hooks — 15 pts]")
s = 0
script_ok = sum(1 for _, exists, executable, syntax_ok in script_hook_status if exists and executable and syntax_ok)
script_total = len(script_hook_status)
for path, exists, executable, syntax_ok in script_hook_status:
    status = "✓" if exists and executable and syntax_ok else "✗"
    print(f"  {path.name}: {status}")
s += score_ratio(script_ok, script_total, 10)
entry_ok = sum(1 for _, command in hook_entries if command)
s += 5 if entry_ok == len(hook_entries) else 0
print(f"  Hook events: {len(settings.get('hooks', {}))}")
print(f"  Hook actions: {len(hook_entries)} (inline: {inline_hooks}, script-backed: {script_total})")
print(f"  Score: {s}/15")
total += s

print("\n[3. Memory — 15 pts]")
s = 0
frontmatter_ok = memory_frontmatter_ok == len(memory_leafs)
links_ok = memory_links_ok == len(memory_links)
all_links_ok = all_memory_links_ok == all_memory_link_total
print(f"  Leaf frontmatter: {memory_frontmatter_ok}/{len(memory_leafs)} {'✓' if frontmatter_ok else '✗'}")
print(f"  MEMORY.md links: {memory_links_ok}/{len(memory_links)} {'✓' if links_ok else '✗'}")
print(f"  All memory links: {all_memory_links_ok}/{all_memory_link_total} {'✓' if all_links_ok else '✗'}")
s += 5 if frontmatter_ok else 0
s += 5 if links_ok else 0
s += 5 if all_links_ok else 0
print(f"  Score: {s}/15")
total += s

print("\n[4. Settings — 15 pts]")
s = 0
safe_prompt = settings.get("skipDangerousModePermissionPrompt") is False
tilde_paths = sum(1 for _, command in hook_entries if "~/" in command)
stale_security = len(list(root.glob("security_warnings_state_*.json")))
print("  Valid JSON: ✓")
print(f"  Dangerous-mode confirmation: {'✓' if safe_prompt else '✗'}")
print(f"  Tilde command paths: {tilde_paths} {'✓' if tilde_paths == 0 else '✗'}")
print(f"  Stale security files: {stale_security} {'✓' if stale_security == 0 else '✗'}")
s += 5
s += 5 if safe_prompt else 0
s += 5 if stale_security == 0 else 0
print(f"  Score: {s}/15")
total += s

print("\n[5. Agents — 10 pts]")
s = score_ratio(agent_ok, len(agent_files), 10)
for path in agent_files:
    text = path.read_text(encoding="utf-8")
    has_model = bool(re.search(r'^model:', text, re.M))
    has_tools = bool(re.search(r'^tools:', text, re.M))
    has_turns = bool(re.search(r'^max_turns:', text, re.M))
    print(f"  {path.stem}: model={'✓' if has_model else '✗'} tools={'✓' if has_tools else '✗'} max_turns={'✓' if has_turns else '✗'}")
print(f"  Score: {s}/10")
total += s

print("\n[6. Skills — 10 pts]")
s = 0
print(f"  Installed skills: {len(skill_files)} {'✓' if len(skill_files) >= 3 else '✗'}")
auto_ok = sum(1 for name in auto_skills if (root / 'skills' / name / 'SKILL.md').exists())
print(f"  Auto skills present on disk: {auto_ok}/{len(auto_skills)} {'✓' if auto_ok == len(auto_skills) else '✗'}")
print(f"  Optional installed skills: {', '.join(optional_skills) if optional_skills else 'none'}")
s += 5 if len(skill_files) >= 3 else 0
s += 5 if auto_ok == len(auto_skills) else 0
print(f"  Score: {s}/10")
total += s

print("\n[7. Commands — 10 pts]")
s = 0
print(f"  Custom commands: {len(command_files)} {'✓' if len(command_files) >= 4 else '✗'}")
print(f"  Frontmatter + name match: {command_ok}/{len(command_files)} {'✓' if command_ok == len(command_files) else '✗'}")
s += 5 if len(command_files) >= 4 else 0
s += 5 if command_ok == len(command_files) else 0
print(f"  Score: {s}/10")
total += s

print("\n[8. Token Budget — 10 pts]")
if est_tokens < 8000:
    s = 10
    rating = '✓ (excellent)'
elif est_tokens < 15000:
    s = 7
    rating = '○ (good)'
else:
    s = 3
    rating = '✗ (review needed)'
print(f"  Always-loaded lines: {always_loaded_lines}")
print(f"  Always-loaded tokens: ~{est_tokens}")
print(f"  Context usage: ~{context_pct:.2f}% of 1M")
print(f"  Budget: {rating}")
print(f"  Score: {s}/10")
total += s

print("\n═══════════════════════════════════════════════")
print(f"  TOTAL SCORE: {total} / 100")
print("═══════════════════════════════════════════════")
PY
```

## Scoring Breakdown
| Category | Max | Checks |
|----------|-----|--------|
| Line budget | 15 | CLAUDE.md ≤50, rules ≤600, memory ≤200 |
| Hooks | 15 | Hook actions parsed from settings, script-backed hooks exist + pass syntax |
| Memory | 15 | Frontmatter + valid markdown links across memory files |
| Settings | 15 | Valid JSON, dangerous confirmation on, no stale security files |
| Agents | 10 | model + tools + max_turns coverage across all agents |
| Skills | 10 | ≥3 installed skills, all auto skills present on disk |
| Commands | 10 | ≥4 commands, frontmatter + `name` match filename |
| Token budget | 10 | Includes `CLAUDE.md` + `enforce.md` + rules + memory |

Manual deep audits for duplication, architecture drift, and security/privacy should still use `/self-optimize` or a dedicated review agent.
