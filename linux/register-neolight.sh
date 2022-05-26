#!/bin/bash
set -euo pipefail

# Based on https://aur.archlinux.org/packages/us_da-layout/

evdev_rules=/usr/share/X11/xkb/rules
evdev_xml=$evdev_rules/evdev.xml
evdev=$evdev_rules/evdev
ibus_file=/usr/share/ibus/component/simple.xml

set_permissions_and_move() {
	tmp_file="$1"
	dest_file="$2"
	chown --reference="$dest_file" "$tmp_file"
	chmod --reference="$dest_file" "$tmp_file"
	mv "$tmp_file" "$dest_file"
}

register() {
	register_evdev
	register_ibus
}

unregister() {
	unregister_evdev
	unregister_ibus
}

register_evdev() {
	if grep -q neolight "$evdev_xml"; then
		echo "Neolight already found in $evdev_xml"
	else
		echo "Adding neolight to $evdev_xml"
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

		evdev_xml_tmp="$(mktemp)"
		awk -v layout="$layout" \
			'{ print }
			/<layoutList>/ { print layout }' \
			"$evdev_xml" > "$evdev_xml_tmp" \
		&& set_permissions_and_move "$evdev_xml_tmp" "$evdev_xml"
	fi


	if grep -q neolight "$evdev"; then
		echo "Neolight already found in $evdev"
	else
		echo "Adding neolight to $evdev"
		evdev_tmp="$(mktemp)"
                cat "$evdev" > "$evdev_tmp" || true
                cat <<-EOF >> "$evdev_tmp"
		// BEGIN neolight
		! option   = symbols
		  neolight = +neolight(layers)
		  neolight:escape_keys = +neolight(layers)+neolight(escape_keys)
		  neolight:jp = +neolight(jp)
		// END neolight
		EOF

		set_permissions_and_move "$evdev_tmp" "$evdev"
	fi
}

unregister_evdev() {
	evdev_xml_tmp="$(mktemp)"
	awk \
		'BEGIN { f=1 }
		/BEGIN neolight/ { f=0 }
		/END neolight/ { f=1; next }
		f' \
		"$evdev_xml" > "$evdev_xml_tmp" \
	&& set_permissions_and_move "$evdev_xml_tmp" "$evdev_xml"

	evdev_tmp="$(mktemp)"
	awk \
		'BEGIN { f=1 }
		/BEGIN neolight/ { f=0 }
		/END neolight/ { f=1; next }
		f' \
		"$evdev" > "$evdev_tmp" \
	&& set_permissions_and_move "$evdev_tmp" "$evdev"
}

register_ibus() {
	if grep -q neolight "$ibus_file"; then
		echo "Neolight already found in $ibus_file"
	else
		echo "Adding neolight to $ibus_file"
		read -r -d '' engines <<-EOF || true
		<!-- BEGIN neolight -->
		        <engine>
		            <name>xkb:de:neolight:deu</name>
		            <language>de</language>
		            <license></license>
		            <author></author>
		            <layout>neolight</layout>
		            <longname>German (Neolight)</longname>
		            <description>German (Neolight)</description>
		            <icon>ibus-keyboard</icon>
		            <rank>1</rank>
		        </engine>
		        <engine>
		            <name>xkb:de:neolight_escape_keys:deu</name>
		            <language>de</language>
		            <license></license>
		            <author></author>
		            <layout>neolight</layout>
		            <layout_variant>de_escape_keys</layout_variant>
		            <longname>German (Neolight, additional escape keys)</longname>
		            <description>German (Neolight, additional escape keys)</description>
		            <icon>ibus-keyboard</icon>
		            <rank>1</rank>
		        </engine>
		<!-- END neolight -->
		EOF

		ibus_tmp="$(mktemp)"
		awk -v engines="$engines" \
			'{ print }
			/<engines>/ { print engines }' \
			"$ibus_file" > "$ibus_tmp" \
		&& set_permissions_and_move "$ibus_tmp" "$ibus_file"
	fi
}

unregister_ibus() {
	ibus_tmp="$(mktemp)"
	awk \
		'BEGIN { f=1 }
		/BEGIN neolight/ { f=0 }
		/END neolight/ { f=1; next }
		f' \
		"$ibus_file" > "$ibus_tmp" \
	&& set_permissions_and_move "$ibus_tmp" "$ibus_file"
}


case "${1:-}" in
	"")
		register;;
	--unregister)
		unregister;;
	-h|--help|*)
		echo "Usage: register-neolight.sh [--unregister]";;
esac
