#!/usr/bin/env bash
#
# git-fix-bad-paths.sh — Fix file/directory names with platform-illegal characters
#
# Uses git plumbing to rebuild tree objects without touching the working tree.
# Supports Windows, Linux, Mac, and cross-platform (strictest) rules.
#
# Usage:
#   git-fix-bad-paths.sh [OPTIONS] [BRANCH]
#
# Options:
#   --platform=windows|linux|mac|cross   Detection rules (default: cross)
#   --apply                              Execute fix (default: dry-run)
#   --remote=REMOTE                      Remote name (default: origin)
#   -h, --help                           Show help
#
set -euo pipefail

# ── defaults ────────────────────────────────────────────────────────────────
PLATFORM="cross"
APPLY=false
REMOTE="origin"
BRANCH=""

# ── parse args ──────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform=*) PLATFORM="${1#--platform=}" ;;
    --apply)      APPLY=true ;;
    --remote=*)   REMOTE="${1#--remote=}" ;;
    -h|--help)    sed -n '2,16p' "$0"; exit 0 ;;
    -*)           echo "Unknown option: $1" >&2; exit 1 ;;
    *)            BRANCH="$1" ;;
  esac
  shift
done

# Resolve branch
if [[ -z "$BRANCH" ]]; then
  for b in main master; do
    if git rev-parse "${REMOTE}/${b}" >/dev/null 2>&1; then
      BRANCH="${REMOTE}/${b}"; break
    fi
  done
  [[ -z "$BRANCH" ]] && { echo "Cannot determine branch. Specify explicitly."; exit 1; }
fi

# ── platform rules ──────────────────────────────────────────────────────────
# Pattern-based checks (much faster than character-by-character)

# Returns the set of illegal characters as a glob pattern for [[ ... == *[pat]* ]]
_illegal_pattern() {
  case "$PLATFORM" in
    windows) echo '<>:\"/\|?*' ;;
    linux)   echo '/' ;;
    mac)     echo '/:' ;;
    cross|*) echo '<>:\"/\|?*,;=&$' ;;
  esac
}

has_bad_name() {
  local name="$1"
  # Check reserved names (Windows/cross only)
  if [[ "$PLATFORM" == "windows" || "$PLATFORM" == "cross" ]]; then
    local base="${name%%.*}"
    local upper
    upper="${base^^}"  # bash 4+ uppercase
    case "$upper" in CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9]) return 0 ;; esac
  fi
  # Check for illegal characters using pattern matching
  local pat
  pat=$(_illegal_pattern)
  # shellcheck disable=SC2254
  case "$name" in
    *[${pat}]*) return 0 ;;
  esac
  # Check for control characters (0x01-0x1F) — use tr to strip printable chars
  local stripped
  stripped=$(printf '%s' "$name" | tr -d '[:print:]')
  [[ -n "$stripped" ]] && return 0
  return 1
}

sanitize_name() {
  local name="$1"
  local result
  # Replace illegal chars with _ using sed
  case "$PLATFORM" in
    windows) result=$(printf '%s' "$name" | sed 's/[<>:"\/\\|?*]/_/g') ;;
    linux)   result=$(printf '%s' "$name" | sed 's/\//_/g') ;;
    mac)     result=$(printf '%s' "$name" | sed 's/[\/:]/_/g') ;;
    cross|*) result=$(printf '%s' "$name" | sed 's/[<>:"\/\\|?*,;=&$]/_/g') ;;
  esac
  # Replace control chars with _
  result=$(printf '%s' "$result" | tr '[:cntrl:]' '_')
  # Collapse multiple underscores
  while [[ "$result" == *__*__* ]]; do
    result="${result//__/_}"
  done
  # Trim leading/trailing _ and spaces
  result="${result#"${result%%[!_ ]*}"}"
  result="${result%"${result##*[!_ ]}"}"
  [[ -z "$result" ]] && result="unnamed_file"
  echo "$result"
}

# ── scan for bad paths ──────────────────────────────────────────────────────
echo "Fetching from $REMOTE..."
git fetch "$REMOTE" 2>/dev/null || true

echo "Scanning $BRANCH (platform: $PLATFORM)..."

# Collect renames: associative array old_full_path -> new_full_path
declare -A RENAME_MAP
# Collect per-tree renames: tree_path -> list of "old_name<TAB>new_name" lines
declare -A TREE_LEVEL_RENAMES
# Set of all tree paths that need rebuilding (including ancestors)
declare -A AFFECTED_TREES
# Set of all existing paths (for collision detection without git ls-tree)
declare -A EXISTING_PATHS

bad_count=0

# Capture tree listing to temp file (avoid running git ls-tree twice)
TREE_LIST=$(mktemp)
trap 'rm -f "$TREE_LIST"' EXIT
git ls-tree -rz "$BRANCH" > "$TREE_LIST"

# First pass: build set of all existing paths
while IFS= read -r -d '' entry; do
  fpath="${entry#*	}"
  EXISTING_PATHS["$fpath"]=1
done < "$TREE_LIST"

# Second pass: find bad paths and compute renames
# Check ALL path components (both directories and files)
while IFS= read -r -d '' entry; do
  fpath="${entry#*	}"

  # Split path into components and check each
  IFS='/' read -ra parts <<< "$fpath"
  any_bad=false
  new_parts=()
  for part in "${parts[@]}"; do
    if has_bad_name "$part"; then
      any_bad=true
      sanitized=$(sanitize_name "$part")
      # Collision avoidance for this component
      new_part="$sanitized"
      counter=2
      base_sanitized="$sanitized"
      # (simplified: just use sanitized name; full collision check below handles the full path)
      new_parts+=("$new_part")
    else
      new_parts+=("$part")
    fi
  done

  if [[ "$any_bad" == true ]]; then
    # Build new full path from sanitized components
    new_fpath=""
    for i in "${!new_parts[@]}"; do
      [[ $i -gt 0 ]] && new_fpath+="/"
      new_fpath+="${new_parts[$i]}"
    done

    # Apply any parent directory renames already recorded
    # (e.g., if dir?name was renamed to dir_name, apply that to child paths)
    for old_p in "${!RENAME_MAP[@]}"; do
      new_p="${RENAME_MAP[$old_p]}"
      if [[ "$new_fpath" == "${old_p}/"* ]]; then
        new_fpath="${new_p}/${new_fpath#${old_p}/}"
      fi
    done

    # Final collision avoidance on the full path
    final_path="$new_fpath"
    if [[ -n "${EXISTING_PATHS[$final_path]+x}" || -n "${RENAME_MAP[$final_path]+x}" ]]; then
      # Add suffix to the last component
      last="${new_parts[-1]}"
      ext="${last#*.}"
      [[ "$ext" == "$last" ]] && ext=""
      counter=2
      base_last="${new_parts[-1]}"
      while true; do
        if [[ -n "$ext" && "$ext" != "$base_last" ]]; then
          new_parts[-1]="${base_last}_${counter}.${ext}"
        else
          new_parts[-1]="${base_last}_${counter}"
        fi
        final_path=""
        for i in "${!new_parts[@]}"; do
          [[ $i -gt 0 ]] && final_path+="/"
          final_path+="${new_parts[$i]}"
        done
        # Re-apply parent dir renames
        for old_p in "${!RENAME_MAP[@]}"; do
          new_p="${RENAME_MAP[$old_p]}"
          if [[ "$final_path" == "${old_p}/"* ]]; then
            final_path="${new_p}/${final_path#${old_p}/}"
          fi
        done
        [[ -z "${EXISTING_PATHS[$final_path]+x}" && -z "${RENAME_MAP[$final_path]+x}" ]] && break
        counter=$((counter+1))
      done
    fi

    new_fpath="$final_path"

    # Record the rename
    RENAME_MAP["$fpath"]="$new_fpath"

    # Record per-tree renames for each affected directory level
    # For the leaf (file or last dir), record in its parent tree
    old_leaf="${parts[-1]}"
    new_leaf="${new_parts[-1]}"
    old_parent="${fpath%/*}"
    [[ "$old_parent" == "$fpath" ]] && old_parent=""
    tree_key="${old_parent:-.}"
    TREE_LEVEL_RENAMES["$tree_key"]+="${old_leaf}"$'\t'"${new_leaf}"$'\n'

    # If intermediate directories were renamed, record those too
    # Build the old and new intermediate paths
    old_so_far=""
    new_so_far=""
    for i in "${!parts[@]}"; do
      [[ $i -eq $((${#parts[@]}-1)) ]] && break  # skip leaf
      old_so_far="${old_so_far:+${old_so_far}/}${parts[$i]}"
      new_so_far="${new_so_far:+${new_so_far}/}${new_parts[$i]}"
      if [[ "${parts[$i]}" != "${new_parts[$i]}" ]]; then
        old_leaf_i="${parts[$i]}"
        new_leaf_i="${new_parts[$i]}"
        parent_i="${old_so_far%/*}"
        [[ "$parent_i" == "$old_so_far" ]] && parent_i=""
        tree_key_i="${parent_i:-.}"
        TREE_LEVEL_RENAMES["$tree_key_i"]+="${old_leaf_i}"$'\t'"${new_leaf_i}"$'\n'
      fi
    done

    # Mark all affected trees (use ORIGINAL paths, not renamed)
    for i in "${!parts[@]}"; do
      if [[ "${parts[$i]}" != "${new_parts[$i]}" ]]; then
        dir_path=""
        for j in $(seq 0 $((i-1))); do
          dir_path="${dir_path:+${dir_path}/}${parts[$j]}"
        done
        path_so_far="${dir_path:-.}"
        while true; do
          AFFECTED_TREES["$path_so_far"]=1
          [[ "$path_so_far" == "." || "$path_so_far" == "" ]] && break
          parent="${path_so_far%/*}"
          [[ "$parent" == "$path_so_far" ]] && { AFFECTED_TREES["."]=1; break; }
          path_so_far="$parent"
        done
      fi
    done

    echo "  BAD: $fpath -> $new_fpath"
    bad_count=$((bad_count+1))
  fi
done < "$TREE_LIST"

if [[ $bad_count -eq 0 ]]; then
  echo "OK: No bad paths found."
  exit 0
fi

echo "Found $bad_count bad path(s)."

if [[ "$APPLY" == false ]]; then
  echo "DRY RUN — no changes made. Use --apply to fix and push."
  exit 0
fi

# ── rebuild trees bottom-up ─────────────────────────────────────────────────
echo "Rebuilding tree objects..."

declare -A NEW_TREE_SHA  # old_tree_sha -> new_tree_sha

# Sort affected tree paths by depth (deepest first) for bottom-up rebuild
sorted_trees=$(for t in "${!AFFECTED_TREES[@]}"; do
  depth=$(echo "$t" | tr -cd '/' | wc -c)
  echo "$depth $t"
done | sort -rn -k1 | awk '{print $2}')

# Build a mapping from tree_path -> original tree SHA
declare -A TREE_SHA_MAP
# Get root tree SHA
TREE_SHA_MAP["."]="$(git rev-parse "${BRANCH}^{tree}")"

# Get tree SHAs for all affected subtrees using git rev-parse
for t in "${!AFFECTED_TREES[@]}"; do
  [[ "$t" == "." ]] && continue
  tree_sha=$(git rev-parse "${BRANCH}:${t}" 2>/dev/null) || continue
  TREE_SHA_MAP["$t"]="$tree_sha"
done

# Process bottom-up
while IFS= read -r tree_path; do
  [[ -z "$tree_path" ]] && continue
  orig_sha="${TREE_SHA_MAP[$tree_path]:-}"
  [[ -z "$orig_sha" ]] && continue

  changed=false
  mktree_input=""

  # Read each entry in this tree
  while IFS= read -r -d '' raw; do
    prefix="${raw%%	*}"
    name="${raw#*	}"
    mode="${prefix:0:6}"
    type="${prefix:7:4}"
    sha="${prefix:12:40}"

    child_path="${tree_path}/${name}"
    [[ "$tree_path" == "." ]] && child_path="$name"

    new_name="$name"
    new_sha="$sha"

    # Check if this entry is renamed at this level
    if [[ -n "${TREE_LEVEL_RENAMES[$tree_path]+x}" ]]; then
      while IFS=$'\t' read -r old_n new_n; do
        [[ -z "$old_n" ]] && continue
        if [[ "$old_n" == "$name" ]]; then
          new_name="$new_n"
          changed=true
          break
        fi
      done <<< "${TREE_LEVEL_RENAMES[$tree_path]}"
    fi

    # If subtree and was rebuilt, use new SHA
    if [[ "$type" == "tree" && -n "${NEW_TREE_SHA[$sha]+x}" ]]; then
      new_sha="${NEW_TREE_SHA[$sha]}"
      [[ "$new_sha" != "$sha" ]] && changed=true
    fi

    mktree_input+="$(printf '%s %s %s\t%s' "$mode" "$type" "$new_sha" "$new_name")"
    mktree_input+=$'\n'
  done < <(git ls-tree -z "$orig_sha")

  if [[ "$changed" == true ]]; then
    new_tree=$(printf '%s' "$mktree_input" | git mktree)
    NEW_TREE_SHA["$orig_sha"]="$new_tree"
    echo "  Rebuilt: $tree_path -> $new_tree"
  else
    NEW_TREE_SHA["$orig_sha"]="$orig_sha"
  fi
done <<< "$sorted_trees"

# Get the new root tree
ROOT_TREE="$(git rev-parse "${BRANCH}^{tree}")"
NEW_ROOT_TREE="${NEW_TREE_SHA[$ROOT_TREE]:-$ROOT_TREE}"

if [[ "$NEW_ROOT_TREE" == "$ROOT_TREE" ]]; then
  echo "ERROR: Tree rebuild produced no changes." >&2
  exit 1
fi

echo "New root tree: $NEW_ROOT_TREE"

# ── commit and push ─────────────────────────────────────────────────────────
OLD_COMMIT=$(git rev-parse "$BRANCH")

NEW_COMMIT=$(printf 'Fix file/directory names with platform-illegal characters (%s)\n\nRenamed %d path(s).\nAuto-generated by git-fix-bad-paths.sh\n' "$PLATFORM" "$bad_count" | \
  git commit-tree "$NEW_ROOT_TREE" -p "$OLD_COMMIT")
echo "New commit: $NEW_COMMIT"

# Verify
echo "Verifying..."
verify_bad=0
while IFS= read -r -d '' entry; do
  fpath="${entry#*	}"
  bname="${fpath##*/}"
  if has_bad_name "$bname"; then
    echo "  STILL BAD: $fpath"
    verify_bad=$((verify_bad+1))
  fi
done < <(git ls-tree -rz "$NEW_COMMIT")

if [[ $verify_bad -gt 0 ]]; then
  echo "ERROR: $verify_bad bad path(s) remain. Aborting." >&2
  exit 1
fi
echo "Verification passed."

# Update local branch and push
LOCAL_BRANCH=$(git symbolic-ref HEAD 2>/dev/null | sed 's|refs/heads/||')
REMOTE_BRANCH_NAME="${BRANCH#*/}"

if [[ -n "$LOCAL_BRANCH" ]]; then
  git update-ref "refs/heads/${LOCAL_BRANCH}" "$NEW_COMMIT"
fi

echo "Pushing to $REMOTE/$REMOTE_BRANCH_NAME..."
git push "$REMOTE" "HEAD:${REMOTE_BRANCH_NAME}"

echo "Done! Fixed $bad_count path(s) and pushed."
