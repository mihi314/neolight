#!/bin/bash
set -euo pipefail

script_dir=$(dirname "$0")
source "$script_dir/find-xkeyboard-config-dir.sh"

case "${1:-}" in
    "")
        install -m 644 "$script_dir/neolight_symbols" "$xkeyboard_config_dir/symbols/neolight"
        install -m 644 "$script_dir/neolight_types" "$xkeyboard_config_dir/types/neolight"
        "${script_dir}/register-neolight.sh"
        ;;
    --uninstall)
        rm "$xkeyboard_config_dir/symbols/neolight" || true
        rm "$xkeyboard_config_dir/types/neolight" || true
        "$script_dir/register-neolight.sh" --unregister
        ;;
    -h|--help|*)
        echo "Usage: install.sh [--uninstall]"
        ;;
esac
