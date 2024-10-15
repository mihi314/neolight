#!/bin/bash
set -euo pipefail

BASEDIR=$(dirname "$0")


case "${1:-}" in
    "")
        install -m 644 "${BASEDIR}/neolight" /usr/share/X11/xkb/symbols/neolight
        install -m 644 "${BASEDIR}/neolight_types" /usr/share/X11/xkb/types/neolight
        "${BASEDIR}/register-neolight.sh"
        ;;
    --uninstall)
        rm /usr/share/X11/xkb/symbols/neolight || true
        rm /usr/share/X11/xkb/types/neolight || true
        "${BASEDIR}/register-neolight.sh" --unregister
        ;;
    -h|--help|*)
        echo "Usage: install.sh [--uninstall]"
        ;;
esac
