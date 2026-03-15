---
name: No parallel agents on shared files
description: Never dispatch parallel agents that modify the same files — they will conflict
type: feedback
---

Phase 3 (File System) + Phase 4 (Terminal) agents ran in parallel but both modified: lib.rs, AppLayout.tsx, Cargo.toml, commands/mod.rs, useKeyboardShortcuts.ts. Result: file conflicts, wasted work.

**Why:** Agents work on isolated snapshots. When 2+ agents edit the same file, the last write wins and earlier changes are lost.

**How to apply:** Before dispatching parallel agents, check if tasks share any files. If they do, run them sequentially. Only parallelize truly independent tasks (different directories, no shared files).
