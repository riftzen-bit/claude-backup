---
name: Lume IDE project
description: Context-first AI-native IDE built with Tauri v2 + CodeMirror 6 + React 19 — ALL 8 PHASES COMPLETE
type: project
---

## Lume IDE — COMPLETE

**What:** Desktop IDE — context-first, spatial canvas, AI-native, "Luminous Depth" visual design.

**Tech stack:** Tauri v2 (Rust) + React 19 + CodeMirror 6 + Zustand + Vite 8

**Stats:** 119 source files, 42 test files, 488 tests, ~12,500 lines of code

**All 8 Phases DONE:**
1. Core Shell — Tauri + layout + themes (39 tests)
2. Editor — CodeMirror 6 + tabs + splits (+83 tests)
3. File System — Rust fs commands + FileTree + FileSearch (+47 tests)
4. Terminal — xterm.js + PTY + tabs (+54 tests)
5. Context System — SQLite contexts + home screen (+62 tests)
6. AI Integration — Anthropic/OpenAI + chat + autonomy slider (+71 tests)
7. Spatial Canvas — @xyflow/react + file cards + dependency edges (+51 tests)
8. LSP Intelligence — lsp-types + diagnostics + hover + completions (+81 tests)

**Key files:**
- Spec: `docs/superpowers/specs/2026-03-14-lume-ide-design.md`
- Plans: `docs/superpowers/plans/2026-03-14-lume-phase{1-8}-*.md`

**To run:** `npm run tauri dev` (requires Rust toolchain)
