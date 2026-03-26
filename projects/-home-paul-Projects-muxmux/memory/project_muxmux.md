---
name: MuxMux Project
description: Tauri v2 + React + TS developer workspace app with Tape Deck theme — terminal, Monaco editor, browser, docking layout
type: project
---

Desktop developer workspace at /home/paul/Projects/muxmux. Tauri v2 + React + TypeScript.

**Phase 1 (MVP) complete:** Dashboard, file tree, Monaco editor, terminal with split panes, Tape Deck theme.
**Wayland fix:** `WEBKIT_DISABLE_DMABUF_RENDERER=1` in main.rs required for GBM buffer errors.
**Spec:** docs/superpowers/specs/2026-03-23-muxmux-design.md
**Phase 1 Plan:** docs/superpowers/plans/2026-03-23-phase1-mvp.md

**Why:** Paul's public product for the developer community — a Tape Deck themed workspace combining terminal, editor, and browser.
**How to apply:** Reference spec for Phase 2-4 requirements. Use subagent-driven development for implementation.

## Updates (2026-03-25)
- Chrome-style workspace tabs added (WorkspaceTabBar.tsx) — multi-workspace open/switch/rename/close
- Split panes limited to 4 (was 8) to avoid cramped terminals
- Terminal CSS fully audited: xterm bg overrides, flexlayout tab bg, SplitContainer pane gaps all fixed
- 18 AGENTS.md files generated for codebase documentation
- workspace-store: added openWorkspaceIds, switchWorkspace(), closeWorkspaceTab()

## Next Steps
- Develop all preset layouts fully (Browser, Code Only, Full Terminal, etc.) — user says UI feels small/cramped
- Per-workspace terminal state isolation (terminal-store keyed by workspace ID)
- Per-workspace layout state isolation (layout-store keyed by workspace ID)
- UI space optimization — maximize content area, reduce chrome
- Plan file: docs/workspace-tabs-plan.md (Phase 4-7 pending)
