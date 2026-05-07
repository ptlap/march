#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$repo_dir/quickshell/macrch"

pkill qs 2>/dev/null || true
hyprctl reload >/tmp/hypr-macrch-reload.log 2>&1 || true
qs -p "$config_dir" >/tmp/qs-macrch.log 2>&1 &
