# Task Plan: OpenCode Migration — Stronger Than Claude Code

## Goal
Port all Claude Code config to OpenCode AND enhance with OpenCode-unique capabilities so OpenCode > Claude Code

## Phases
- [ ] Phase 1: Create directory structure
- [ ] Phase 2: Port rules as instruction files
- [ ] Phase 3: Create AGENTS.md (global + OpenCode enhancements)
- [ ] Phase 4: Create opencode.json config
- [ ] Phase 5: Create plugins (enforcement, memory, verification, code-review)
- [ ] Phase 6: Verify all files created correctly

## Architecture Decisions
- Instructions via `opencode.json` array (like Claude Code's rules/)
- Plugins via TypeScript (replaces bash hooks — MORE powerful)
- AGENTS.md enhanced with OpenCode-specific advantages (LSP, fuzzy edit, multiedit)
- Memory via plugin (session.compacted event + file-based)
- Enforcement via plugin (tool.execute.before/after events)

## OpenCode Advantages to Leverage
1. LSP diagnostics after every edit (built-in)
2. Fuzzy edit matching (9 strategies)
3. Multiedit (atomic batch edits)
4. FileTime assertions (stale edit prevention)
5. Plugin events: tool.execute.before can MODIFY tool args
6. Compaction hooks: can inject custom context
7. File watcher events
8. Shell env injection

## Status
**Phase 1** — Starting
