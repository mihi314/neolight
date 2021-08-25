#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")


case "${1:-}" in
    "")
        install -m 644 "${BASEDIR}/neolight" /usr/share/X11/xkb/symbols/neolight
        "${BASEDIR}/register-neolight.sh"
        ;;
    --uninstall)
        rm /usr/share/X11/xkb/symbols/neolight || true
        "${BASEDIR}/register-neolight.sh" --unregister
        ;;
    -h|--help|*)
        echo "Usage: install.sh [--uninstall]"
        ;;
esac
