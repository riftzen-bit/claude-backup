#!/bin/bash
# Stop hook — TDD FINAL VERIFICATION
# If modified source files have no test files, output a message to force
# the agent loop to continue (non-empty stdout = agent keeps running).

# Only run in git repos with changes
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

MODIFIED=$(
    (git diff --name-only 2>/dev/null
     git diff --cached --name-only 2>/dev/null) | sort -u
)
[ -z "$MODIFIED" ] && exit 0

RESULT=$(MODIFIED="$MODIFIED" python3 - <<'PY'
import os, sys

modified = [f.strip() for f in os.environ.get("MODIFIED", "").strip().split('\n') if f.strip()]
if not modified:
    sys.exit(0)

TESTABLE = {".ts",".tsx",".js",".jsx",".mjs",".cjs",".py",".go",".rs",".rb",".java",".kt",".cs",".cpp",".c",".swift",".php",".vue",".svelte"}
TEST_IND = [".test.",".spec.","_test.","_spec.","test_","/__tests__/","/tests/","/test/","/spec/"]
EXEMPT = [".config.","config/",".eslint",".prettier","tsconfig","jest.config","vitest.config","package.json","package-lock","yarn.lock","pnpm-lock",".gitignore",".env","readme","claude.md","agents.md","makefile","dockerfile",".css",".scss",".html",".md",".json",".yaml",".yml",".toml",".d.ts","types.ts","types/","interfaces/","index.ts","index.js","index.tsx","index.jsx","mod.rs","lib.rs","migration","seed","schema.prisma",".stories.","scripts/","bin/",".claude/","dist/","build/","node_modules/",".sh"]

TEST_PATS = {
    ".ts":[".test.ts",".spec.ts"],".tsx":[".test.tsx",".spec.tsx"],
    ".js":[".test.js",".spec.js"],".jsx":[".test.jsx",".spec.jsx"],
    ".py":["_test.py","test_"],".go":["_test.go"],".rs":["_test.rs"],
    ".rb":["_spec.rb"],".java":["Test.java"],".kt":["Test.kt"],
    ".cpp":["_test.cpp"],".c":["_test.c"],".swift":["Tests.swift"],
    ".php":["Test.php"],".vue":[".test.ts",".spec.ts"],".svelte":[".test.ts",".spec.ts"],
}
TDIRS = ["__tests__","tests","test","spec"]

missing = []
for f in modified:
    _,ext = os.path.splitext(f)
    if ext not in TESTABLE:
        continue
    fl = f.lower()
    bl = os.path.basename(f).lower()
    if any(t in fl for t in TEST_IND) or bl.startswith("test_"):
        continue
    if any(p in fl or p in bl for p in EXEMPT):
        continue
    d = os.path.dirname(f)
    n = os.path.splitext(os.path.basename(f))[0]
    pats = TEST_PATS.get(ext,[])
    found = False
    for pat in pats:
        c = os.path.join(d, f"test_{n}{ext}") if pat.startswith("test_") else os.path.join(d, f"{n}{pat}")
        if os.path.exists(c):
            found = True; break
    if not found:
        for td in TDIRS:
            for pat in pats:
                c = os.path.join(d,td,f"test_{n}{ext}") if pat.startswith("test_") else os.path.join(d,td,f"{n}{pat}")
                if os.path.exists(c):
                    found = True; break
            if found: break
    if not found:
        missing.append(f)

if missing:
    print("MISSING")
    for m in missing:
        print(m)
PY
)

STATUS=$(echo "$RESULT" | head -1)

if [ "$STATUS" = "MISSING" ]; then
    FILES=$(echo "$RESULT" | tail -n +2 | sed 's/^/  - /')
    cat <<EOF
TDD STOP GATE — Cannot finish yet. Modified source files have no tests:
${FILES}

Write tests for ALL files above, run them, and verify they pass before completing.
EOF
fi

exit 0
