#!/bin/bash
# PreToolUse hook — HARD TDD BLOCKER
# BLOCKS source file edits when NO corresponding test file exists.
# Forces strict TDD: write the test FIRST, then the implementation.
# Exit 2 = BLOCK the tool call. Claude MUST write the test file first.
# Exit 0 = allow (test exists, or file is exempt).

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

# Only block edit tools
edit_tools = {"ApplyPatch", "Edit", "MultiEdit", "Write", "NotebookEdit"}
if tool_name not in edit_tools:
    sys.exit(0)

file_paths = find_all_paths(data, {"file_path", "path", "filePath"})
if not file_paths:
    sys.exit(0)

# Testable source extensions
TESTABLE = {
    ".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs",
    ".py", ".go", ".rs", ".rb", ".java", ".kt",
    ".cs", ".cpp", ".c", ".swift", ".php",
    ".vue", ".svelte",
}

# Exempt patterns — never block these
EXEMPT = [
    "test", "spec", "__test__", "__tests__", ".test.", ".spec.",
    "fixture", "mock", "stub", "fake",
    ".config.", "config/", ".eslint", ".prettier", "tsconfig",
    "package.json", "package-lock", "yarn.lock", "pnpm-lock",
    ".gitignore", ".env", "README", "CLAUDE.md", "AGENTS.md",
    "Makefile", "Dockerfile", "docker-compose",
    ".css", ".scss", ".less", ".sass", ".html",
    "migration", "seed", "schema.prisma",
    ".d.ts", "types.ts", "types/", "interfaces/",
    "__mocks__/", "testutils", "test-utils",
    ".stories.", ".storybook",
    # Claude Code config files
    ".claude/", "enforce.md", "hooks/", "agents/", "rules/",
    "commands/", "skills/", "plugins/", ".omc/",
    # Non-code
    ".md", ".json", ".yaml", ".yml", ".toml", ".xml",
    ".sh", ".bash", ".zsh",
]

# Test file patterns by extension
TEST_PATTERNS = {
    ".ts":  [".test.ts", ".spec.ts", "_test.ts"],
    ".tsx": [".test.tsx", ".spec.tsx", "_test.tsx"],
    ".js":  [".test.js", ".spec.js", "_test.js"],
    ".jsx": [".test.jsx", ".spec.jsx", "_test.jsx"],
    ".mjs": [".test.mjs", ".spec.mjs"],
    ".cjs": [".test.cjs", ".spec.cjs"],
    ".py":  ["_test.py", "test_"],
    ".go":  ["_test.go"],
    ".rs":  ["_test.rs"],
    ".rb":  ["_spec.rb", "_test.rb"],
    ".java":["Test.java", "Tests.java"],
    ".kt":  ["Test.kt", "Tests.kt"],
    ".cs":  ["Tests.cs", "Test.cs"],
    ".cpp": ["_test.cpp", "_tests.cpp"],
    ".c":   ["_test.c"],
    ".swift":["Tests.swift"],
    ".php": ["Test.php"],
    ".vue": [".test.ts", ".spec.ts", ".test.js", ".spec.js"],
    ".svelte": [".test.ts", ".spec.ts", ".test.js", ".spec.js"],
}

TEST_DIRS = ["__tests__", "tests", "test", "spec", "__test__"]

blocked = []

for fp in file_paths:
    if not fp:
        continue

    _, ext = os.path.splitext(fp)
    basename = os.path.basename(fp)

    # Skip non-testable extensions
    if ext not in TESTABLE:
        continue

    # Skip exempt patterns
    fp_lower = fp.lower()
    basename_lower = basename.lower()
    if any(pat in fp_lower or pat in basename_lower for pat in EXEMPT):
        continue

    # Check if a test file exists anywhere
    dir_name = os.path.dirname(fp)
    name_no_ext = os.path.splitext(basename)[0]
    patterns = TEST_PATTERNS.get(ext, [])

    test_found = False
    suggested_path = ""

    for pat in patterns:
        if pat.startswith("test_"):
            candidate = os.path.join(dir_name, f"test_{name_no_ext}{ext}")
        else:
            candidate = os.path.join(dir_name, f"{name_no_ext}{pat}")
        if not suggested_path:
            suggested_path = candidate
        if os.path.exists(candidate):
            test_found = True
            break

    if not test_found:
        for test_dir in TEST_DIRS:
            for pat in patterns:
                if pat.startswith("test_"):
                    candidate = os.path.join(dir_name, test_dir, f"test_{name_no_ext}{ext}")
                else:
                    candidate = os.path.join(dir_name, test_dir, f"{name_no_ext}{pat}")
                if not suggested_path or "__tests__" in candidate:
                    suggested_path = candidate
                if os.path.exists(candidate):
                    test_found = True
                    break
            # Check parent dir's test directory
            parent = os.path.dirname(dir_name)
            if parent:
                for pat in patterns:
                    if pat.startswith("test_"):
                        candidate = os.path.join(parent, test_dir, f"test_{name_no_ext}{ext}")
                    else:
                        candidate = os.path.join(parent, test_dir, f"{name_no_ext}{pat}")
                    if os.path.exists(candidate):
                        test_found = True
                        break
            if test_found:
                break

    if not test_found:
        if not suggested_path:
            suggested_path = os.path.join(dir_name, f"{name_no_ext}.test{ext}")
        blocked.append((fp, suggested_path))

if blocked:
    print("BLOCK")
    for src, test in blocked:
        print(f"{src}|{test}")
else:
    print("OK")
PY
)

STATUS=$(echo "$RESULT" | head -1)

if [ "$STATUS" = "BLOCK" ]; then
    # Output the blocking reason
    cat <<'HEADER'
╔══════════════════════════════════════════════════════════════════════════╗
║  TDD BLOCKER — EDIT REJECTED — NO TEST FILE EXISTS                     ║
║                                                                        ║
║  You CANNOT edit this source file because no test file was found.      ║
║  TDD means: write the TEST FIRST, then the implementation.             ║
║  This is non-negotiable. The tool call has been BLOCKED.               ║
╚══════════════════════════════════════════════════════════════════════════╝

BLOCKED FILES:
HEADER

    echo "$RESULT" | tail -n +2 | while IFS='|' read -r src test; do
        printf '  Source: %s\n' "$src"
        printf '  Create test FIRST: %s\n\n' "$test"
    done

    cat <<'FOOTER'
WHAT TO DO NOW:
1. Create the test file at the suggested path above
2. Write failing tests that describe the expected behavior (RED phase)
3. THEN come back and edit the source file (GREEN phase)

Required test categories:
  - Happy path (normal inputs → expected outputs)
  - Edge cases (null, empty, zero, boundary values)
  - Error handling (invalid inputs → proper errors)
  - Security (injection, auth bypass — if applicable)

Minimum: 5 test cases per function, 3 edge cases per function.
The boulder never stops. Tests are NOT optional.
FOOTER

    # EXIT 2 = BLOCK THE TOOL CALL
    exit 2
fi

exit 0
