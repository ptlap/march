#!/usr/bin/env bash

pkill qs 2>/dev/null
hyprctl reload
qs -c macrch >/tmp/qs-macrch.log 2>&1 &
