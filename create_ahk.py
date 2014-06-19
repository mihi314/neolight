#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv

mappings = []

# vk: Virtual Key
# sc: Scan Code

with open("mappings.csv", encoding='utf-8', newline='') as f:
    for vk, sc, orig, new in csv.reader(f, delimiter=' ', quotechar=None):
        if sc == "sc" or not new:
            continue
        mappings.append({
            "vk": vk, 
            "sc":sc, 
            "original_key": orig, 
            "new_key": new,
            "new_ordinal": hex(ord(new))})

# creation of akh file
# sc02B: # key
template = """
Capslock & sc{sc}::
sc02B & sc{sc}::
    send {{U+{new_ordinal}}}
return"""

result = ""
for mapping in mappings:
    result += template.format(**mapping)


PLACEHOLDER = "; >>> mappings go here <<<"

with open("neolight.ahk", "w", encoding='utf-8') as f_out:
    with open("template.ahk", "r", encoding='utf-8') as f_in:
        f_out.write(f_in.read().replace(PLACEHOLDER, result))
