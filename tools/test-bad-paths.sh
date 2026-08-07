#!/usr/bin/env bash
#
# test-bad-paths.sh — Test all git-fix-bad-paths tools
#
# Uses git plumbing to inject filenames with illegal characters,
# then verifies hooks and fix scripts work correctly.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIX_SCRIPT="$SCRIPT_DIR/git-fix-bad-paths.sh"
PRE_COMMIT="$SCRIPT_DIR/pre-commit-check-paths"
PRE_RECEIVE="$SCRIPT_DIR/pre-receive-check-paths"

# ── temp setup ──────────────────────────────────────────────────────────────
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR" "$_RESULT_FILE"' EXIT

echo "=== Test environment: $TMPDIR ==="
echo ""

# ── helpers ─────────────────────────────────────────────────────────────────
make_blob() { echo "$1" | git hash-object -w --stdin; }
make_tree() { printf '%b' "$1" | git mktree; }
make_commit() {
  local tree="$1" parent="${2:-}" msg="${3:-test commit}"
  if [[ -n "$parent" ]]; then
    echo "$msg" | git commit-tree "$tree" -p "$parent"
  else
    echo "$msg" | git commit-tree "$tree"
  fi
}

PASS=0; FAIL=0
_RESULT_FILE=$(mktemp)
_pass() { echo "  PASS: $1"; echo "P" >> "$_RESULT_FILE"; }
_fail() { echo "  FAIL: $1"; echo "F" >> "$_RESULT_FILE"; }
assert_eq()    { [[ "$2" == "$3" ]] && _pass "$1" || _fail "$1 (expected=$2 actual=$3)"; }
assert_contains()    { echo "$3" | grep -qF "$2" && _pass "$1" || _fail "$1 (missing: $2)"; }
assert_not_contains() { echo "$3" | grep -qF "$2" && _fail "$1 (should NOT contain: $2)" || _pass "$1"; }
assert_exit_code()   { [[ "$2" == "$3" ]] && _pass "$1 (exit=$3)" || _fail "$1 (expected exit=$2 got=$3)"; }

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Setup: Create repos with bad paths"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Create bare repo
BARE="$TMPDIR/bare.git"
git init --bare "$BARE" >/dev/null 2>&1

# Create working clone
WORK="$TMPDIR/work"
git clone "$BARE" "$WORK" >/dev/null 2>&1
cd "$WORK"
git config user.email "test@test.com"
git config user.name "Test"

# Normal initial commit
echo "initial" > README.md
git add README.md
git commit -m "initial" >/dev/null 2>&1
INITIAL_COMMIT=$(git rev-parse HEAD)
git push origin master >/dev/null 2>&1

# Disable NTFS protection so we can test with illegal paths
git config core.protectNTFS false

# Build bad-path tree using plumbing (bypasses Windows filesystem restrictions)
BAD_BLOB1=$(make_blob "content of bad?file.md")
BAD_BLOB2=$(make_blob "content of file\"quote.md")
GOOD_BLOB=$(make_blob "good content")
BAD_INNER_TREE=$(make_tree "100644 blob ${BAD_BLOB1}\tnested?file.md\n")
BAD_TREE=$(make_tree "100644 blob ${GOOD_BLOB}\tgood.md\n100644 blob ${BAD_BLOB1}\tbad?file.md\n100644 blob ${BAD_BLOB2}\tfile\"quote.md\n040000 tree ${BAD_INNER_TREE}\tdir?name\n")
BAD_COMMIT=$(make_commit "$BAD_TREE" "$INITIAL_COMMIT" "add bad paths")

# Push bad commit to bare repo (force since it diverges)
git update-ref refs/heads/master "$BAD_COMMIT"
git push origin master --force >/dev/null 2>&1

echo "Bad paths in remote:"
git ls-tree -r --name-only "$BAD_COMMIT" | grep -v "^good.md$" || true
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test A: pre-commit hook — reject mode"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"
  # Reset to initial (clean state)
  git reset --hard "$INITIAL_COMMIT" >/dev/null 2>&1

  # Install hook
  cp "$PRE_COMMIT" .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  git config hooks.badPaths.action reject
  git config hooks.badPaths.platform cross

  # Use read-tree to load bad-path tree into index
  # First make a tree that includes a bad-name file along with existing good files
  STAGE_BLOB=$(make_blob "staged bad content")
  STAGE_TREE=$(make_tree "100644 blob $(git rev-parse HEAD:README.md)\tREADME.md\n100644 blob ${STAGE_BLOB}\ttest?stage.md\n")
  git read-tree "$STAGE_TREE"

  # Verify bad name is in the index
  index_files=$(git diff --cached --name-only 2>/dev/null || git ls-files --stage | awk '{print $4}')
  echo "  Index contains: $index_files"

  # Try to commit - should be rejected
  set +e
  output=$(git commit -m "bad stage" 2>&1)
  exit_code=$?
  set -e

  assert_exit_code "commit rejected" "1" "$exit_code"
  assert_contains "reports bad filename" "test?stage.md" "$output"

  # Cleanup index
  git read-tree HEAD 2>/dev/null || true
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test B: pre-commit hook — fix mode"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"
  git reset --hard "$INITIAL_COMMIT" >/dev/null 2>&1

  # Install hook with fix mode
  cp "$PRE_COMMIT" .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  git config hooks.badPaths.action fix
  git config hooks.badPaths.platform cross

  # Use read-tree to put bad-name entry in index
  STAGE_BLOB2=$(make_blob "fix me content")
  STAGE_TREE2=$(make_tree "100644 blob $(git rev-parse HEAD:README.md)\tREADME.md\n100644 blob ${STAGE_BLOB2}\tstage?bad.md\n")
  git read-tree "$STAGE_TREE2"

  set +e
  output=$(git commit -m "fix bad paths" 2>&1)
  exit_code=$?
  set -e

  echo "  Hook output: $output"
  echo "  Exit code: $exit_code"

  # Fix mode detects and tries to fix. On Windows, index-only entries
  # (without files on disk) can't be fully renamed, but the hook should
  # at least detect the issue.
  assert_contains "fix mode detects bad paths" "illegal" "$output"
  echo "  NOTE: full fix requires file on disk (Linux/Mac scenario)"

  git read-tree HEAD 2>/dev/null || true
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test C: pre-receive hook — reject mode"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  # Install pre-receive hook on bare repo
  cp "$PRE_RECEIVE" "$BARE/hooks/pre-receive"
  chmod +x "$BARE/hooks/pre-receive"
  cd "$BARE"
  git config hooks.badPaths.action reject
  git config hooks.badPaths.platform cross

  cd "$WORK"
  git reset --hard "$INITIAL_COMMIT" >/dev/null 2>&1

  # Create a new bad-path commit
  NEW_BAD_BLOB=$(make_blob "new bad")
  NEW_BAD_TREE=$(make_tree "100644 blob ${GOOD_BLOB}\tgood.md\n100644 blob ${NEW_BAD_BLOB}\tnew?bad.md\n")
  NEW_BAD_COMMIT=$(make_commit "$NEW_BAD_TREE" "$INITIAL_COMMIT" "new bad path")
  git update-ref refs/heads/master "$NEW_BAD_COMMIT"

  set +e
  output=$(git push origin master --force 2>&1)
  exit_code=$?
  set -e

  assert_exit_code "push rejected" "1" "$exit_code"
  assert_contains "mentions illegal characters" "illegal" "$output"

  # Reset for subsequent tests
  git reset --hard "$INITIAL_COMMIT" >/dev/null 2>&1
  git push origin master --force >/dev/null 2>&1
)
# Remove hook for fix-script tests
rm -f "$BARE/hooks/pre-receive"
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test D: fix script — dry-run"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"
  git update-ref refs/heads/master "$BAD_COMMIT"
  git push origin master --force >/dev/null 2>&1

  set +e
  output=$(bash "$FIX_SCRIPT" --platform=cross origin/master 2>&1)
  exit_code=$?
  set -e

  assert_exit_code "dry-run exits 0" "0" "$exit_code"
  assert_contains "says DRY RUN" "DRY RUN" "$output"
  assert_contains "lists bad?file.md" "bad?file.md" "$output"

  # Verify remote unchanged
  remote_tree=$(git ls-tree -r --name-only origin/master)
  assert_contains "remote still has bad paths" "bad?file.md" "$remote_tree"
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test E: fix script — apply"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"

  set +e
  output=$(bash "$FIX_SCRIPT" --apply --platform=cross origin/master 2>&1)
  exit_code=$?
  set -e

  echo "  Fix output:"
  echo "$output" | sed 's/^/    /'

  assert_exit_code "apply exits 0" "0" "$exit_code"
  assert_contains "says Done" "Done" "$output"
  assert_contains "verification passed" "Verification passed" "$output"

  # Verify remote is clean
  remote_tree=$(git ls-tree -r --name-only origin/master)
  assert_not_contains "no ? in remote" "?" "$remote_tree"
  assert_not_contains "no quotes in remote" '"' "$remote_tree"
  assert_contains "has sanitized bad_file.md" "bad_file.md" "$remote_tree"
  assert_contains "still has good.md" "good.md" "$remote_tree"
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test F: nested directory fix"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"
  git fetch origin >/dev/null 2>&1
  fixed_tree=$(git ls-tree -r --name-only origin/master)
  assert_not_contains "no dir?name" "dir?name" "$fixed_tree"
  assert_contains "has dir_name" "dir_name" "$fixed_tree"
  assert_contains "nested file fixed" "nested_file.md" "$fixed_tree"
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test G: cross-platform detection"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"
  git reset --hard "$INITIAL_COMMIT" >/dev/null 2>&1

  COLON_BLOB=$(make_blob "colon content")
  COLON_TREE=$(make_tree "100644 blob ${GOOD_BLOB}\tgood.md\n100644 blob ${COLON_BLOB}\tvalid:colon.md\n")
  COLON_COMMIT=$(make_commit "$COLON_TREE" "$INITIAL_COMMIT" "colon file")
  git update-ref refs/heads/master "$COLON_COMMIT"
  git push origin master --force >/dev/null 2>&1

  # Linux: colon is legal
  set +e
  output_linux=$(bash "$FIX_SCRIPT" --platform=linux origin/master 2>&1)
  set -e
  assert_contains "linux: colon OK" "No bad paths" "$output_linux"

  # Windows: colon is illegal
  set +e
  output_win=$(bash "$FIX_SCRIPT" --platform=windows origin/master 2>&1)
  set -e
  assert_contains "windows: colon bad" "valid:colon.md" "$output_win"

  # Cross: colon is illegal
  set +e
  output_cross=$(bash "$FIX_SCRIPT" --platform=cross origin/master 2>&1)
  set -e
  assert_contains "cross: colon bad" "valid:colon.md" "$output_cross"
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test H: no issues — all clean"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
(
  cd "$WORK"
  git reset --hard "$INITIAL_COMMIT" >/dev/null 2>&1
  git push origin master --force >/dev/null 2>&1

  set +e
  output=$(bash "$FIX_SCRIPT" --platform=cross origin/master 2>&1)
  set -e

  assert_contains "says OK" "No bad paths found" "$output"
)
echo ""

# ══════════════════════════════════════════════════════════════════════════════
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
PASS=$(grep -c "^P$" "$_RESULT_FILE" 2>/dev/null || true)
FAIL=$(grep -c "^F$" "$_RESULT_FILE" 2>/dev/null || true)
: "${PASS:=0}"
: "${FAIL:=0}"
echo "RESULTS: $PASS passed, $FAIL failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [[ "$FAIL" -gt 0 ]]; then
  echo "SOME TESTS FAILED!"
  exit 1
else
  echo "ALL TESTS PASSED!"
  exit 0
fi
