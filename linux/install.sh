#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")


case "${1:-}" in
    "")
        install -m 644 "${BASEDIR}/neolight_symbols" /usr/share/xkeyboard-config-2/symbols/neolight
        install -m 644 "${BASEDIR}/neolight_types" /usr/share/xkeyboard-config-2/types/neolight
        "${BASEDIR}/register-neolight.sh"
        ;;
    --uninstall)
        rm /usr/share/xkeyboard-config-2/symbols/neolight || true
        rm /usr/share/xkeyboard-config-2/types/neolight || true
        "${BASEDIR}/register-neolight.sh" --unregister
        ;;
    -h|--help|*)
        echo "Usage: install.sh [--uninstall]"
        ;;
esac
