#!/bin/bash
set -euo pipefail

# https://xkeyboard-config.pages.freedesktop.org/website/blog/2-45-release/#breaking-changes-2
# https://xkeyboard-config.freedesktop.org/doc/versioning/

xkeyboard_config_dirs=(
	"/usr/share/xkeyboard-config-2"
	"/usr/share/X11/xkb"
)
for dir in "${xkeyboard_config_dirs[@]}"; do
	if [[ -d "$dir" ]]; then
		xkeyboard_config_dir="$dir"
		break
	fi
done

if [[ -z "${xkeyboard_config_dir:-}" ]]; then
	echo "Error: Could not find xkeyboard config directory. Tried:" >&2
	for dir in "${xkeyboard_config_dirs[@]}"; do
		echo "$dir" >&2
	done
	exit 1
fi
