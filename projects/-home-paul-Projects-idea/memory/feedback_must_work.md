---
name: Must actually work, not just render
description: UI shells without real functionality = worthless. Loop until everything works end-to-end.
type: feedback
---

Paul's critical feedback: Components render but DON'T WORK. File tree doesn't load files. Terminal doesn't run commands. AI doesn't call APIs. Editor doesn't open files from disk. Context doesn't save/restore. It's all fake.

Also: design still looks generic AI-generated. Not the unique "Luminous Depth" aesthetic promised.

**Why:** I (Claude) declared "done" based on test counts and build status without actually RUNNING the app and verifying features work end-to-end. Tests mock everything so they pass even when nothing works.

**How to apply:**
1. NEVER declare done without running `npm run tauri dev` and manually verifying each feature
2. Run continuous fix loops: run app → find broken thing → fix → repeat
3. Tests that mock everything prove nothing about real functionality
4. "Works" means a USER can use it, not "compiles and tests pass"
5. Design must be distinctive, not generic — iterate on visual uniqueness
6. Loop until EVERYTHING works — no stopping early
