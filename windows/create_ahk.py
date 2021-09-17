#!/usr/bin/env python3
import csv
import sys
import os
from textwrap import dedent


def generate_send_code(new_key: str) -> str:
    # https://autohotkey.com/docs/commands/Send.htm
    if len(new_key) == 1:
        # single character
        return "{U+%s}" % hex(ord(new_key))
    else:
        # allows keys like Esc
        return "{Blind}{%s}" % new_key


def generate_ahk(esc_variant: bool) -> str:
    with open("mappings.csv", encoding="utf-8") as f:
        mappings = [row for row in csv.DictReader(f, delimiter=" ", quoting=csv.QUOTE_NONE)]

    ahk = ""

    if esc_variant:
        for mapping in mappings:
            if mapping["sc"] == "010":
                mapping["layer3"] = "Esc"

        ahk += dedent(
            """
            ; map + key to Esc
            sc01B::
                send {Esc}
            return"""
        )

    # sc02B is the scancode of the # key
    template_layer3 = dedent(
        """
        CapsLock & sc{sc}::
        sc02B & sc{sc}::
            send {send_code}
        return"""
    )

    # AppsKey is the Menu key
    # sc056 is the scancode of the < key
    template_layer4 = dedent(
        """
        AppsKey & sc{sc}::
        sc056 & sc{sc}::
            send {send_code}
        return"""
    )

    for mapping in mappings:
        if mapping["layer3"]:
            ahk += template_layer3.format(sc=mapping["sc"], send_code=generate_send_code(mapping["layer3"]))
        if mapping["layer4"]:
            ahk += template_layer4.format(sc=mapping["sc"], send_code=generate_send_code(mapping["layer4"]))

    PLACEHOLDER = "; >>> mappings go here <<<"

    with open("template.ahk", "r", encoding="utf-8") as f:
        return f.read().replace(PLACEHOLDER, ahk)


os.makedirs("build", exist_ok=True)

with open("build/neolight.ahk", "w", encoding="utf-8") as f:
    f.write(generate_ahk(esc_variant=False))

with open("build/neolight-esc.ahk", "w", encoding="utf-8") as f:
    f.write(generate_ahk(esc_variant=True))
