#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="$REPO_ROOT/tools/install-skills.sh"
SKILL_ID="summary-to-obsidian"
SKILL_SOURCE="$REPO_ROOT/skills/$SKILL_ID"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_symlink_to() {
  local path="$1"
  local expected_target="$2"
  local actual_target=""

  [[ -L "$path" ]] || fail "Expected symlink: $path"
  actual_target="$(readlink "$path")"
  [[ "$actual_target" == "$expected_target" ]] || fail "Expected $path -> $expected_target, got $actual_target"
}

assert_directory_copy() {
  local path="$1"

  [[ -d "$path" ]] || fail "Expected directory: $path"
  [[ ! -L "$path" ]] || fail "Expected regular directory, got symlink: $path"
  [[ -f "$path/SKILL.md" ]] || fail "Expected copied SKILL.md in: $path"
}

run_installer() {
  local home_dir="$1"
  shift

  HOME="$home_dir" bash "$INSTALLER" "$@"
}

test_default_mode_installs_symlink() {
  local tmp_dir home_dir skill_dest

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  home_dir="$tmp_dir/home"
  skill_dest="$home_dir/.codex/skills/$SKILL_ID"

  run_installer "$home_dir" --target codex

  assert_symlink_to "$skill_dest" "$SKILL_SOURCE"
}

test_copy_mode_keeps_copy_install_available() {
  local tmp_dir home_dir skill_dest

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  home_dir="$tmp_dir/home"
  skill_dest="$home_dir/.codex/skills/$SKILL_ID"

  run_installer "$home_dir" --target codex --mode copy

  assert_directory_copy "$skill_dest"
}

test_force_replaces_existing_copy_with_symlink() {
  local tmp_dir home_dir skill_dest

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' RETURN
  home_dir="$tmp_dir/home"
  skill_dest="$home_dir/.codex/skills/$SKILL_ID"

  mkdir -p "$skill_dest"
  cp "$SKILL_SOURCE/SKILL.md" "$skill_dest/SKILL.md"

  run_installer "$home_dir" --target codex --force

  assert_symlink_to "$skill_dest" "$SKILL_SOURCE"
}

test_default_mode_installs_symlink
test_copy_mode_keeps_copy_install_available
test_force_replaces_existing_copy_with_symlink

echo "PASS: install-skills"
