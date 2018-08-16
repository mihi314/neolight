#!/bin/bash

BASEDIR=$(dirname $0)
install -m 644 "$BASEDIR/neolight" /usr/share/X11/xkb/symbols/neolight
patch -r - /usr/share/X11/xkb/rules/evdev "$BASEDIR/evdev.patch"
