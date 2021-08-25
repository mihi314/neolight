#!/bin/bash
set -euo pipefail

# Based on https://aur.archlinux.org/packages/us_da-layout/

rules=/usr/share/X11/xkb/rules
cd "$rules"


register() {
	if grep neolight evdev.xml > /dev/null; then
		echo "Neolight already found in $rules/evdev.xml"
	else
		echo "Adding neolight to $rules/evdev.xml"
		read -r -d '' layout <<-EOF || true
		<!-- BEGIN neolight -->
		    <layout>
		      <configItem>
		        <name>neolight</name>
		        <shortDescription>de</shortDescription>
		        <description>German (Neolight)</description>
		        <languageList>
		          <iso639Id>deu</iso639Id>
		        </languageList>
		      </configItem>
		      <variantList>
		        <variant>
		          <configItem>
		            <name>de_escape_keys</name>
		            <description>German (Neolight, additional escape keys)</description>
		          </configItem>
		        </variant>
		      </variantList>
		    </layout>
		<!-- END neolight -->
		EOF
		awk -v layout="$layout" '{ print } /<layoutList>/ { print layout }' evdev.xml > tmp && mv tmp evdev.xml
	fi


	if grep neolight evdev > /dev/null; then
		echo "Neolight already found in $rules/evdev"
	else
		echo "Adding neolight to $rules/evdev"
		cat <<-EOF >> evdev
		// BEGIN neolight
		! option   = symbols
		  neolight = +neolight(layers)
		  neolight:escape_keys = +neolight(layers)+neolight(escape_keys)
		  neolight:jp = +neolight(jp)
		// END neolight
		EOF
	fi
}


unregister() {
	awk 'BEGIN { f=1 } /BEGIN neolight/ { f=0 } /END neolight/ { f=1; next } f' evdev.xml > tmp && mv tmp evdev.xml
	awk 'BEGIN { f=1 } /BEGIN neolight/ { f=0 } /END neolight/ { f=1; next } f' evdev > tmp && mv tmp evdev
}


case "${1:-}" in
	"")
		register;;
	--unregister)
		unregister;;
	-h|--help|*)
		echo "Usage: register-neolight.sh [--unregister]";;
esac
