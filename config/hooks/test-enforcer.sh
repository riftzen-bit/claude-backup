#!/bin/bash
# PostToolUse hook — MANDATORY test enforcement after every file edit
# Checks if tests exist for modified files and demands test creation

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
except:
    data = {}

tool_name = find_first(data, {"tool_name", "tool"})

# Only activate for edit tools
edit_tools = {"ApplyPatch", "Edit", "MultiEdit", "Write", "NotebookEdit"}
if tool_name not in edit_tools:
    sys.exit(0)

# Extract file path(s) from the tool input
file_paths = find_all_paths(data, {"file_path", "path", "filePath"})
if not file_paths:
    sys.exit(0)

# File extensions that MUST have tests
TESTABLE_EXTENSIONS = {
    ".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs",
    ".py", ".go", ".rs", ".rb", ".java", ".kt",
    ".cs", ".cpp", ".c", ".swift", ".php",
    ".vue", ".svelte",
}

# Files/dirs that are exempt from testing
EXEMPT_PATTERNS = [
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
]

# Test file naming patterns by language
TEST_PATTERNS = {
    ".ts":  [".test.ts", ".spec.ts", "_test.ts"],
    ".tsx": [".test.tsx", ".spec.tsx", "_test.tsx"],
    ".js":  [".test.js", ".spec.js", "_test.js"],
    ".jsx": [".test.jsx", ".spec.jsx", "_test.jsx"],
    ".mjs": [".test.mjs", ".spec.mjs"],
    ".cjs": [".test.cjs", ".spec.cjs"],
    ".py":  ["_test.py", "test_"],
    ".go":  ["_test.go"],
    ".rs":  ["_test.rs", "/tests/"],
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

# Test directory patterns
TEST_DIRS = ["__tests__", "tests", "test", "spec", "__test__"]

results = []

for fp in file_paths:
    if not fp:
        continue

    _, ext = os.path.splitext(fp)
    basename = os.path.basename(fp)

    # Skip non-testable files
    if ext not in TESTABLE_EXTENSIONS:
        continue

    # Skip exempt patterns
    fp_lower = fp.lower()
    basename_lower = basename.lower()
    if any(pat in fp_lower or pat in basename_lower for pat in EXEMPT_PATTERNS):
        continue

    # Check if a test file exists
    dir_name = os.path.dirname(fp)
    name_without_ext = os.path.splitext(basename)[0]
    patterns = TEST_PATTERNS.get(ext, [])

    test_found = False
    test_locations_checked = []

    for pat in patterns:
        # Same directory
        if pat.startswith("test_"):
            # Python style: test_foo.py
            candidate = os.path.join(dir_name, f"test_{name_without_ext}{ext}")
        else:
            candidate = os.path.join(dir_name, f"{name_without_ext}{pat}")
        test_locations_checked.append(candidate)
        if os.path.exists(candidate):
            test_found = True
            break

    if not test_found:
        # Check __tests__ and tests directories
        for test_dir in TEST_DIRS:
            for pat in patterns:
                if pat.startswith("test_"):
                    candidate = os.path.join(dir_name, test_dir, f"test_{name_without_ext}{ext}")
                else:
                    candidate = os.path.join(dir_name, test_dir, f"{name_without_ext}{pat}")
                test_locations_checked.append(candidate)
                if os.path.exists(candidate):
                    test_found = True
                    break

            # Also check parent dir's test directory
            parent_dir = os.path.dirname(dir_name)
            if parent_dir:
                for pat in patterns:
                    if pat.startswith("test_"):
                        candidate = os.path.join(parent_dir, test_dir, f"test_{name_without_ext}{ext}")
                    else:
                        candidate = os.path.join(parent_dir, test_dir, f"{name_without_ext}{pat}")
                    test_locations_checked.append(candidate)
                    if os.path.exists(candidate):
                        test_found = True
                        break

            if test_found:
                break

    results.append({
        "file": fp,
        "ext": ext,
        "has_test": test_found,
        "checked": test_locations_checked[:5],
    })

# Output
missing = [r for r in results if not r["has_test"]]
if missing:
    print("MISSING_TESTS")
    for m in missing:
        print(f"FILE:{m['file']}")
        print(f"EXT:{m['ext']}")
        suggested = m['checked'][0] if m['checked'] else f"{m['file'].rsplit('.', 1)[0]}.test{m['ext']}"
        print(f"SUGGEST:{suggested}")
else:
    if results:
        print("TESTS_OK")
    else:
        print("SKIP")
PY
)

STATUS=$(echo "$RESULT" | head -1)

if [ "$STATUS" = "MISSING_TESTS" ]; then
    cat <<'HEADER'
<test-enforcement-gate>
MANDATORY TEST ENFORCEMENT — Tests MUST be created for ALL code.

CRITICAL: You modified source file(s) that have NO corresponding test files.
You MUST create tests BEFORE moving on. This is non-negotiable.

Missing tests for:
HEADER

    echo "$RESULT" | grep "^FILE:" | while read -r line; do
        FILE="${line#FILE:}"
        SUGGEST=$(echo "$RESULT" | grep -A2 "^FILE:${FILE}$" | grep "^SUGGEST:" | head -1)
        SUGGEST="${SUGGEST#SUGGEST:}"
        printf '  - Source: %s\n' "$FILE"
        printf '    Create: %s\n' "$SUGGEST"
    done

    cat <<'FOOTER'

REQUIRED TEST CATEGORIES (write ALL that apply):
1. HAPPY PATH: normal inputs produce expected outputs
2. EDGE CASES: empty inputs, nulls, undefined, zero, max values, unicode
3. ERROR HANDLING: invalid inputs throw/return proper errors
4. BOUNDARY: off-by-one, min/max limits, overflow, timeout
5. SECURITY: injection (SQL/XSS/command), auth bypass, path traversal
6. INTEGRATION: verify interaction with dependencies (mock external calls)
7. REGRESSION: if fixing a bug, test the exact scenario that caused it
8. ASYNC: race conditions, concurrent access, promise rejection
9. STATE: verify state transitions, side effects, cleanup

MINIMUM REQUIREMENTS:
- At least 5 test cases per function/method
- At least 3 edge case tests per function
- All error paths must have explicit tests
- All public API surfaces must have tests
- Mock external dependencies, test real logic

DO NOT proceed to the next task until tests are written and passing.
The boulder never stops rolling — tests are part of the work, not optional.
</test-enforcement-gate>
FOOTER

elif [ "$STATUS" = "TESTS_OK" ]; then
    cat <<'EOF'
<test-status>
Tests exist for modified files. After completing edits:
1. Run existing tests to verify no regressions
2. Add NEW test cases for new/changed behavior
3. Verify edge cases and error paths are covered
4. Run full test suite before claiming done
</test-status>
EOF
fi

exit 0
