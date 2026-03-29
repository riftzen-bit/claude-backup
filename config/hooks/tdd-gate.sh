#!/bin/bash
# PreToolUse hook — HARD TDD GATE (exit 2 = BLOCK)
# Blocks source file edits when no corresponding test file exists.
# Forces TDD: write test FIRST, then implementation. No bypass.

INPUT_JSON=$(cat)

RESULT=$(INPUT_JSON="$INPUT_JSON" python3 - <<'PY'
import json
import os
import sys

def find_first(obj, keys):
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key in keys and isinstance(value, str) and value.strip():
                return value.strip()
            found = find_first(value, keys)
            if found:
                return found
    elif isinstance(obj, list):
        for item in obj:
            found = find_first(item, keys)
            if found:
                return found
    return ""

def find_all_paths(obj, keys):
    paths = []
    if isinstance(obj, dict):
        for key, value in obj.items():
            if key in keys and isinstance(value, str) and value.strip():
                paths.append(value.strip())
            paths.extend(find_all_paths(value, keys))
    elif isinstance(obj, list):
        for item in obj:
            paths.extend(find_all_paths(item, keys))
    return paths

raw = os.environ.get("INPUT_JSON", "")
try:
    data = json.loads(raw)
except Exception:
    data = {}

tool_name = find_first(data, {"tool_name", "tool"})

EDIT_TOOLS = {"ApplyPatch", "Edit", "MultiEdit", "Write", "NotebookEdit"}
if tool_name not in EDIT_TOOLS:
    sys.exit(0)

file_paths = find_all_paths(data, {"file_path", "path", "filePath"})
if not file_paths:
    sys.exit(0)

# ── Config ──

TESTABLE_EXT = {
    ".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs",
    ".py", ".go", ".rs", ".rb", ".java", ".kt",
    ".cs", ".cpp", ".c", ".swift", ".php",
    ".vue", ".svelte",
}

TEST_INDICATORS = [
    ".test.", ".spec.", "_test.", "_spec.",
    "test_",
    "/__tests__/", "/__test__/", "/tests/", "/test/", "/spec/",
    "/fixtures/", "/mocks/", "/stubs/", "/fakes/",
    "/testutils/", "/test-utils/", "/testing/",
    "/e2e/", "/cypress/", "/playwright/",
]

EXEMPT_PATTERNS = [
    # Config
    ".config.", "config/", "configs/",
    ".eslint", ".prettier", "tsconfig", "jest.config", "vitest.config",
    "playwright.config", "webpack.config", "vite.config", "rollup.config",
    "babel.config", ".babelrc", "next.config", "nuxt.config",
    "tailwind.config", "postcss.config", "drizzle.config",
    # Package/lock
    "package.json", "package-lock", "yarn.lock", "pnpm-lock", "bun.lock",
    # Text/docs
    ".gitignore", ".env", "readme", "claude.md", "agents.md",
    "changelog", "license", "contributing",
    # Build/infra
    "makefile", "dockerfile", "docker-compose", ".dockerignore",
    "ci.yml", "cd.yml", ".github/",
    # Static assets
    ".css", ".scss", ".less", ".sass", ".html", ".md", ".txt",
    ".json", ".yaml", ".yml", ".toml", ".xml", ".graphql", ".gql",
    ".svg", ".png", ".jpg", ".gif", ".ico", ".webp",
    # Database
    "migration", "seed", "schema.prisma", "drizzle/",
    # Type-only (no runtime logic)
    ".d.ts", "types.ts", "types/", "interfaces/",
    # Barrel re-export files (no logic)
    "index.ts", "index.js", "index.tsx", "index.jsx",
    # Rust module files (declarations only)
    "mod.rs", "lib.rs",
    # Claude Code config
    ".claude/", "/.claude/",
    # Build output
    "dist/", "build/", "out/", ".next/", "node_modules/",
    "__pycache__/", "target/", "vendor/",
    # Stories
    ".stories.", ".storybook",
    # Scripts
    "scripts/", "bin/",
    # Shell
    ".sh",
]

EXEMPT_DIRS = [
    os.path.expanduser("~/.claude"),
    os.path.expanduser("~/.config"),
    os.path.expanduser("~/.local"),
    "/etc/",
]

TEST_PATTERNS = {
    ".ts":     [".test.ts", ".spec.ts", "_test.ts"],
    ".tsx":    [".test.tsx", ".spec.tsx", "_test.tsx"],
    ".js":     [".test.js", ".spec.js", "_test.js"],
    ".jsx":    [".test.jsx", ".spec.jsx", "_test.jsx"],
    ".mjs":    [".test.mjs", ".spec.mjs"],
    ".cjs":    [".test.cjs", ".spec.cjs"],
    ".py":     ["_test.py", "test_"],
    ".go":     ["_test.go"],
    ".rs":     ["_test.rs"],
    ".rb":     ["_spec.rb", "_test.rb"],
    ".java":   ["Test.java", "Tests.java"],
    ".kt":     ["Test.kt", "Tests.kt"],
    ".cs":     ["Tests.cs", "Test.cs"],
    ".cpp":    ["_test.cpp", "_tests.cpp"],
    ".c":      ["_test.c"],
    ".swift":  ["Tests.swift"],
    ".php":    ["Test.php"],
    ".vue":    [".test.ts", ".spec.ts", ".test.js", ".spec.js"],
    ".svelte": [".test.ts", ".spec.ts", ".test.js", ".spec.js"],
}

TEST_DIRS = ["__tests__", "tests", "test", "spec", "__test__"]

def is_test_file(fp):
    fp_lower = fp.lower()
    if os.path.basename(fp).lower().startswith("test_"):
        return True
    return any(ind in fp_lower for ind in TEST_INDICATORS)

def is_exempt(fp):
    for d in EXEMPT_DIRS:
        if fp.startswith(d):
            return True
    fp_lower = fp.lower()
    bn_lower = os.path.basename(fp).lower()
    return any(p in fp_lower or p in bn_lower for p in EXEMPT_PATTERNS)

def find_test(src, ext):
    d = os.path.dirname(src)
    name = os.path.splitext(os.path.basename(src))[0]
    pats = TEST_PATTERNS.get(ext, [])
    # Same dir
    for pat in pats:
        c = os.path.join(d, f"test_{name}{ext}") if pat.startswith("test_") else os.path.join(d, f"{name}{pat}")
        if os.path.exists(c):
            return c
    # Test dirs (same + parent level)
    for td in TEST_DIRS:
        for pat in pats:
            c = os.path.join(d, td, f"test_{name}{ext}") if pat.startswith("test_") else os.path.join(d, td, f"{name}{pat}")
            if os.path.exists(c):
                return c
        parent = os.path.dirname(d)
        if parent and parent != d:
            for pat in pats:
                c = os.path.join(parent, td, f"test_{name}{ext}") if pat.startswith("test_") else os.path.join(parent, td, f"{name}{pat}")
                if os.path.exists(c):
                    return c
    return None

def suggest_test(src, ext):
    d = os.path.dirname(src)
    name = os.path.splitext(os.path.basename(src))[0]
    pats = TEST_PATTERNS.get(ext, [])
    if not pats:
        return os.path.join(d, f"{name}.test{ext}")
    pat = pats[0]
    tests_dir = os.path.join(d, "__tests__")
    if os.path.isdir(tests_dir):
        if pat.startswith("test_"):
            return os.path.join(tests_dir, f"test_{name}{ext}")
        return os.path.join(tests_dir, f"{name}{pat}")
    if pat.startswith("test_"):
        return os.path.join(d, f"test_{name}{ext}")
    return os.path.join(d, f"{name}{pat}")

# ── Check each file ──
blocked = []
for fp in file_paths:
    if not fp:
        continue
    _, ext = os.path.splitext(fp)
    if ext not in TESTABLE_EXT:
        continue
    if is_test_file(fp):
        continue
    if is_exempt(fp):
        continue
    if find_test(fp, ext) is None:
        blocked.append({"src": fp, "test": suggest_test(fp, ext)})

if blocked:
    print("BLOCK")
    for b in blocked:
        print(f"SRC:{b['src']}")
        print(f"TEST:{b['test']}")
else:
    print("OK")
PY
)

STATUS=$(echo "$RESULT" | head -1)

if [ "$STATUS" = "BLOCK" ]; then
    cat <<'HEADER'
TDD GATE — EDIT BLOCKED (exit 2)
No test file found. You MUST write the test FIRST.
This is hardware-enforced — there is no way to skip or bypass.

TDD cycle: RED (failing test) -> GREEN (implementation) -> REFACTOR

Source files blocked (no test exists):
HEADER

    echo "$RESULT" | tail -n +2 | while IFS= read -r line; do
        case "$line" in
            SRC:*)  printf '  [BLOCKED] %s\n' "${line#SRC:}" ;;
            TEST:*) printf '  [CREATE]  %s\n\n' "${line#TEST:}" ;;
        esac
    done

    cat <<'FOOTER'
REQUIRED — write the test file with:
  1. HAPPY PATH: normal inputs -> expected outputs
  2. EDGE CASES: empty, null, zero, boundary values
  3. ERROR HANDLING: invalid inputs -> proper errors
  4. BOUNDARY: off-by-one, min/max, overflow
  5. SECURITY: injection, auth bypass (if applicable)

Min 5 test cases per function. Create the test NOW, then retry this edit.
FOOTER

    exit 2
fi

exit 0
