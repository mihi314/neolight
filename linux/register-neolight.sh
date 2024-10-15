#!/bin/bash
set -euo pipefail

# Based on https://aur.archlinux.org/packages/us_da-layout/

evdev_rules=/usr/share/X11/xkb/rules
evdev_xml=$evdev_rules/evdev.xml
evdev=$evdev_rules/evdev
types_file=/usr/share/X11/xkb/types/complete
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
	register_types
	register_ibus
}

unregister() {
	unregister_evdev
	unregister_types
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
		        <countryList>
		          <iso3166Id>DE</iso3166Id>
		        </countryList>
		        <languageList>
		          <iso639Id>deu</iso639Id>
		        </languageList>
		      </configItem>
		      <variantList>
		        <variant>
		          <configItem>
		            <name>de_escape_keys</name>
		            <description>German (Neolight + escape keys)</description>
		          </configItem>
		        </variant>
		      </variantList>
		    </layout>
		<!-- END neolight -->
		EOF

		read -r -d '' options <<-EOF || true
		<!-- BEGIN neolight -->
		    <group allowMultipleSelection="false">
		      <configItem>
		        <name>neolight</name>
		        <description>Neolight</description>
		      </configItem>
		      <option>
		        <configItem>
		          <name>neolight</name>
		          <description>Add the neolight layers to the first layout</description>
		        </configItem>
		      </option>
		      <option>
		        <configItem>
		          <name>neolight:escape_keys</name>
		          <description>Add the neolight layers and additional escape keys to the first layout</description>
		        </configItem>
		      </option>
		    </group>
		<!-- END neolight -->
		EOF

		evdev_xml_tmp="$(mktemp)"
		awk -v layout="$layout" -v options="$options" \
			'{ print }
			/<layoutList>/ { print layout }
			/<optionList>/ { print options }' \
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
		'BEGIN { printing=1 }
		/BEGIN neolight/ { printing=0 }
		/END neolight/ { printing=1; next }
		printing' \
		"$evdev_xml" > "$evdev_xml_tmp" \
	&& set_permissions_and_move "$evdev_xml_tmp" "$evdev_xml"

	evdev_tmp="$(mktemp)"
	awk \
		'BEGIN { printing=1 }
		/BEGIN neolight/ { printing=0 }
		/END neolight/ { printing=1; next }
		printing' \
		"$evdev" > "$evdev_tmp" \
	&& set_permissions_and_move "$evdev_tmp" "$evdev"
}

register_types() {
	if grep -q neolight "$types_file"; then
		echo "Neolight already found in $types_file"
	else
		echo "Adding neolight to $types_file"
		value='    include "neolight"'

		types_file_tmp="$(mktemp)"
		awk -v value="$value" \
			'/};/ { print value }
			{ print }' \
			"$types_file" > "$types_file_tmp" \
		&& set_permissions_and_move "$types_file_tmp" "$types_file"
	fi
}

unregister_types() {
	types_file_tmp="$(mktemp)"
	awk '!/neolight/' \
		"$types_file" > "$types_file_tmp" \
	&& set_permissions_and_move "$types_file_tmp" "$types_file"
}

register_ibus() {
	if [[ ! -f "$ibus_file" ]]; then
		echo "No ibus file found. Skipping."
		return
	elif grep -q neolight "$ibus_file"; then
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
	[[ ! -f "$ibus_file" ]] \
		&& return

	ibus_tmp="$(mktemp)"
	awk \
		'BEGIN { printing=1 }
		/BEGIN neolight/ { printing=0 }
		/END neolight/ { printing=1; next }
		printing' \
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
