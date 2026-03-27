```
     ██████╗██╗      █████╗ ██╗   ██╗██████╗ ███████╗
    ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██╔════╝
    ██║     ██║     ███████║██║   ██║██║  ██║█████╗
    ██║     ██║     ██╔══██║██║   ██║██║  ██║██╔══╝
    ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝███████╗
     ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
               P O W E R   C O N F I G
```

> Stop babysitting your AI. This config makes Claude Code behave like a senior engineer — it reads before editing, tests before shipping, reviews its own work, and never claims "done" without proof.

---

## The Problem

Out of the box, Claude Code will happily:
- Edit files it hasn't read
- Claim "fixed!" without running tests
- Hallucinate package names and install them
- Use the most expensive model for trivial tasks
- Skip code review entirely

This config fixes all of that.

---

## What You Get

```
13 rules          Enforced engineering discipline — not suggestions, rules
 7 agents         Cost-routed specialists (haiku $0.002 → opus $0.105 per task)
12 hooks          Automated guardrails on every action
 5 commands       /route, /design, /routing-stats, /self-optimize, /benchmark
 7 skills         From TDD enforcement to anti-AI-looking UI design
10 plugins        Superpowers, ECC, HUD, LSP, security, code review, Ralph loop
```

---

## Install

### Linux / macOS

```bash
git clone https://github.com/riftzen-bit/claude-backup.git
cd claude-backup && chmod +x install.sh && ./install.sh
```

### Windows (WSL)

```bash
# From WSL terminal:
git clone https://github.com/riftzen-bit/claude-backup.git
cd claude-backup && chmod +x install.sh && ./install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/riftzen-bit/claude-backup.git
cd claude-backup
.\install.ps1
```

> **Note:** Claude Code hooks require bash. On Windows, run Claude Code from WSL or Git Bash — not native PowerShell. The PowerShell installer copies files to the right place, but you still need WSL/Git Bash to use Claude Code.

Then open `~/.claude/CLAUDE.md` and replace `[Your name]` and `[Your language]`.

<details>
<summary><b>Manual install (no script)</b></summary>

```bash
cp -r config/* ~/.claude/
cp config/gitignore ~/.claude/.gitignore
chmod +x ~/.claude/hooks/*.sh
sed "s|__HOME__|$HOME|g" ~/.claude/settings.json > ~/.claude/settings.json.tmp \
  && mv ~/.claude/settings.json.tmp ~/.claude/settings.json
```
</details>

---

## How It Works

### The Enforcement Loop

Every single message you send triggers this chain:

```
┌─────────────────────────────────────────────────────────────┐
│  YOU TYPE A MESSAGE                                         │
│                                                             │
│  ┌─ UserPromptSubmit ─────────────────────────────────────┐ │
│  │  remind.sh injects enforce.md                          │ │
│  │  → "re-read before edit, verify before claiming done"  │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                  │
│  ┌─ PreToolUse ───────────────────────────────────────────┐ │
│  │  pre-write-guard.sh catches edits + mutating commands  │ │
│  │  → "did you read this file first? tests exist?"        │ │
│  │                                                        │ │
│  │  pre-edit-reread-guard.sh tracks file read timestamps  │ │
│  │  → "this file is stale — re-read before editing!"      │ │
│  │                                                        │ │
│  │  pre-agent-routing.sh validates model assignment       │ │
│  │  → "haiku for search, sonnet for review, not opus"     │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                  │
│  ┌─ PostToolUse ──────────────────────────────────────────┐ │
│  │  post-tool.sh reviews the change (5-phase TDD)         │ │
│  │  → "re-read, write tests, run validators, verify"      │ │
│  │                                                        │ │
│  │  test-enforcer.sh checks for missing test files        │ │
│  │  → "no test file for this source? create it NOW"       │ │
│  │                                                        │ │
│  │  Hallucination guard catches fake packages             │ │
│  │  → "MODULE_NOT_FOUND? verify it exists first"          │ │
│  │                                                        │ │
│  │  notify.sh pings your desktop                          │ │
│  └────────────────────────────────────────────────────────┘ │
│                          ↓                                  │
│  ┌─ Context Recovery ────────────────────────────────────┐  │
│  │  PreCompact saves state before memory wipe             │  │
│  │  post-compact.sh restores full context after           │  │
│  │  → no more "what were we doing?" after compaction      │  │
│  └────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Model Routing — Stop Burning Money

Without routing, every task hits Opus at $15/$75 per million tokens. With routing:

```
┌──────────────┬──────────┬───────────────────────────────────────┐
│ Model        │ Cost     │ Handles                               │
├──────────────┼──────────┼───────────────────────────────────────┤
│ Haiku        │ 1x       │ File search, grep, formatting, docs   │
│ Sonnet       │ 12x      │ Planning, review, refactor, tests     │
│ Opus         │ 60x      │ Architecture, security, ambiguity     │
│ Gemini       │ external │ UI design (opt-in only via /design)   │
└──────────────┴──────────┴───────────────────────────────────────┘

1 Opus call = 60 Haiku calls. Route aggressively.
```

Seven specialist agents, each pinned to the cheapest model that works:

```
repo-scout ──────── haiku     Fast file discovery, validator detection
media-interpreter ─ haiku     PDFs, images, diagrams
planner ─────────── sonnet    Implementation plans, risk mapping
code-reviewer ───── sonnet    Post-edit correctness review
validator ────────── sonnet    Run actual build/test/lint commands
open-source-lib ─── sonnet    Library research with GitHub permalinks
security-reviewer ─ opus      Secrets, injection, auth review
```

### The Rules

Thirteen files in `rules/` that load automatically:

```
00-mandatory-mindset    Never edit without reading. Never claim done without proof.
01-workflow             Orient → scope → plan → code → validate → review → commit
02-code-quality         Match existing patterns. Simplicity over abstraction.
03-testing              TDD: red → green → refactor. 80% coverage minimum.
04-safety               Verify imports exist. Parameterized queries. No secrets in code.
05-production           Check for N+1 queries, unbounded SELECTs, missing timeouts.
06-self-optimization    Promote repeated patterns to rules. Consolidate at 30 memories.
07-model-routing        Route cheap. Retry one tier higher on failure.
08-agent-discipline     6-section delegation format. Intent classification before action.
09-notepad-system       Accumulate wisdom across multi-step tasks via notepads.
10-auto-continue        Explore before asking. Auto-continue between clear steps.
────────────────────
typescript/coding-style Path-scoped to *.ts/*.tsx — immutability, Zod, no console.log
typescript/patterns     Path-scoped to *.ts/*.tsx — detect existing API patterns first
```

---

## Skill Packs

The base install includes 7 custom skills. Add more from these curated collections:

<details>
<summary><b>Anthropic Official — 12 document & creative skills</b></summary>

PDF processing, Word docs, spreadsheets, presentations, canvas design, web artifacts, algorithmic art, themes, MCP builder, webapp testing.

```bash
git clone --depth 1 https://github.com/anthropics/skills.git /tmp/anthropic-skills
for s in pdf docx xlsx pptx doc-coauthoring canvas-design \
         web-artifacts-builder brand-guidelines algorithmic-art \
         theme-factory mcp-builder webapp-testing; do
  cp -r /tmp/anthropic-skills/skills/$s ~/.claude/skills/
done
rm -rf /tmp/anthropic-skills
```

Dependencies for document skills:
```bash
# pandoc — Ubuntu: apt install pandoc | Arch: pacman -S pandoc-cli | macOS: brew install pandoc
# Python packages
python3 -m venv ~/.local/share/doc-tools
~/.local/share/doc-tools/bin/pip install pypdf markitdown
```
</details>

<details>
<summary><b>Marketing — 33 growth & conversion skills</b></summary>

Copywriting, CRO, A/B testing, email sequences, paid ads, pricing strategy, launch planning, referral programs, sales enablement, schema markup, analytics tracking, and more.

```bash
git clone --depth 1 https://github.com/coreyhaines31/marketingskills.git /tmp/mkt
cp -r /tmp/mkt/skills/*/ ~/.claude/skills/ && rm -rf /tmp/mkt
```
</details>

<details>
<summary><b>SEO — 13 technical SEO skills</b></summary>

Technical audits, schema markup, sitemaps, content optimization, local SEO, image SEO, hreflang, programmatic SEO, competitor pages, AI search optimization.

```bash
git clone --depth 1 https://github.com/AgriciDaniel/claude-seo.git /tmp/seo
cp -r /tmp/seo/skills/*/ ~/.claude/skills/ && rm -rf /tmp/seo
```
</details>

<details>
<summary><b>Deep Research — 8-phase research with citations</b></summary>

Multi-source synthesis, citation tracking, verification pipeline, credibility scoring. Triggers on "deep research", "comprehensive analysis", "research report".

```bash
git clone --depth 1 https://github.com/199-biotechnologies/claude-deep-research-skill.git /tmp/dr
mkdir -p ~/.claude/skills/deep-research
cp -r /tmp/dr/{SKILL.md,reference,templates,scripts} ~/.claude/skills/deep-research/
rm -rf /tmp/dr
```
</details>

---

## Customization

**Language** — Edit `~/.claude/CLAUDE.md` identity section. For UI language, add `"language": "your-language"` to `settings.json`.

**Auto-approve everything** — Add `"skipDangerousModePermissionPrompt": true` to `settings.json`. Removed by default for safety.

**Completion sound** — The Stop hook plays a sound when Claude finishes. Linux (`paplay`) and macOS (`afplay`) both supported. Edit the Stop hook in `settings.json` to change or disable.

**Add your own rules** — Drop `.md` files into `~/.claude/rules/common/`. They load automatically. Use YAML frontmatter `paths:` to scope rules to specific file patterns.

---

## File Map

```
~/.claude/
│
├── CLAUDE.md                 ← Start here. Set your name and language.
├── enforce.md                ← Injected into every message via hook.
├── settings.json             ← Hooks, plugins, env vars, preferences.
├── model-routing.json        ← Task → model mapping for /route command.
├── .gitignore                ← Keeps secrets and cache out of git.
│
├── agents/                   ← 7 specialist definitions
│   ├── repo-scout.md             haiku — fast file discovery
│   ├── planner.md                sonnet — implementation plans
│   ├── code-reviewer.md          sonnet — post-edit review
│   ├── validator.md              sonnet — run actual validators
│   ├── security-reviewer.md      opus — pre-commit security scan
│   ├── open-source-librarian.md  sonnet — library research
│   └── media-interpreter.md      haiku — PDFs, images, diagrams
│
├── commands/                 ← 5 slash commands
│   ├── route.md                  Decompose → classify → dispatch → aggregate
│   ├── design.md                 Gemini tmux worker for UI tasks
│   ├── routing-stats.md          Session cost analysis
│   ├── self-optimize.md          Deep config audit
│   └── benchmark.md              100-point quality score
│
├── hooks/                    ← 12 automated guardrails
│   ├── remind.sh                 Inject enforce.md + context every message
│   ├── pre-write-guard.sh        TDD guard before edits + mutating commands
│   ├── pre-edit-reread-guard.sh  Track file reads, block stale edits
│   ├── pre-agent-routing.sh      Model assignment + collision check
│   ├── post-tool.sh              5-phase TDD review + hallucination guard
│   ├── test-enforcer.sh          Demand test files for modified sources
│   ├── ralph-stop-hook.sh        Ralph loop — prevent stop until done
│   ├── notify.sh                 Desktop notification on file changes
│   ├── session-start.sh          Token auto-refresh + project detection
│   ├── post-compact.sh           Restore context after compaction
│   ├── subagent-stop.sh          Log agent completions
│   └── ecc-observe.sh            Optional ECC learning (disabled)
│
├── rules/
│   ├── common/               ← 11 universal engineering rules
│   │   ├── 00-mandatory-mindset.md
│   │   ├── 01-workflow.md
│   │   ├── 02-code-quality.md
│   │   ├── 03-testing.md
│   │   ├── 04-safety.md
│   │   ├── 05-production.md
│   │   ├── 06-self-optimization.md
│   │   ├── 07-model-routing.md
│   │   ├── 08-agent-discipline.md
│   │   ├── 09-notepad-system.md
│   │   └── 10-auto-continue.md
│   └── typescript/           ← 2 path-scoped rules (*.ts, *.tsx)
│       ├── coding-style.md
│       └── patterns.md
│
└── skills/                   ← 7 built-in + optional packs
    ├── execution-guard/          Auto: TDD + verification discipline
    ├── anti-ai-design/           Auto: distinctive UI, not AI slop
    ├── planning-with-files/      Auto: persistent markdown plans
    ├── vercel-react-best-practices/  Auto: React/Next.js patterns
    ├── web-design-guidelines/    Manual: UI/accessibility audits
    ├── skill-factory/            Manual: generate new skills
    └── text-to-speech/           Manual: multi-provider TTS
```

---

## Platform Support

| | Linux | macOS | Windows (WSL/Git Bash) |
|---|---|---|---|
| Installer | `install.sh` | `install.sh` | `install.ps1` or `install.sh` in WSL |
| Hooks | native bash | bash 3.2+ compatible | bash via WSL/Git Bash |
| Notifications | `notify-send` | `osascript` | `powershell.exe` toast |
| Completion sound | `paplay` | `afplay` | `powershell.exe` SystemSounds |
| Path handling | `$HOME` | `$HOME` | `$HOME` (WSL) / `$USERPROFILE` (PS) |
| Python hooks | `python3` | `python3` | `python3` via WSL |

All fallbacks chain with `|| true` — if a platform command is unavailable, it silently skips. Nothing breaks.

---

## Credits

Built on the shoulders of:

[Superpowers](https://github.com/obra/superpowers) — Jesse Vincent's battle-tested skill collection
[Everything Claude Code](https://github.com/affaan-m/everything-claude-code) — Affaan M's comprehensive plugin
[Claude Ultimate HUD](https://github.com/hadamyeedady12-dev/claude-ultimate-hud) — Real-time status line
[Marketing Skills](https://github.com/coreyhaines31/marketingskills) — Corey Haines' 33 marketing skills
[Claude SEO](https://github.com/AgriciDaniel/claude-seo) — Agrici Daniel's 13 SEO skills
[Anthropic Skills](https://github.com/anthropics/skills) — Official document & creative skills

---

<sub>Tested across 7 audit rounds. 6 bugs caught and fixed. Cross-platform verified. Zero known issues.</sub>
