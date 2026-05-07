#!/usr/bin/env bash
set -euo pipefail

pkill qs 2>/dev/null || true
qs -c ii >/tmp/qs-end4-restore.log 2>&1 &
