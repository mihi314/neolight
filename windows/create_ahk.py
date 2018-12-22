# coding: utf-8
#!/usr/bin/env python3
import csv


mappings = []

# vk: Virtual Key
# sc: Scan Code
with open("../mappings.csv", encoding='utf-8', newline='') as f:
    for vk, sc, orig, new in csv.reader(f, delimiter=' ', quotechar=None):
        if not new:
            continue

        # https://autohotkey.com/docs/commands/Send.htm
        if len(new) == 1:
            # single character
            send_code = "{U+%s}" % hex(ord(new))
        else:
            # allows keys like Esc
            send_code = "{%s}" % new

        mappings.append({
            "vk": vk,
            "sc": sc,
            "original_key": orig,
            "new_key": new,
            "send_code": send_code
        })

# creation of the ahk file
# sc02B is the scancode of the # key
template = """
Capslock & sc{sc}::
sc02B & sc{sc}::
    send {send_code}
return"""

result = ""
for mapping in mappings:
    result += template.format(**mapping)


PLACEHOLDER = "; >>> mappings go here <<<"

with open("../build/neolight.ahk", "w", encoding='utf-8') as f_out:
    with open("template.ahk", "r", encoding='utf-8') as f_in:
        f_out.write(f_in.read().replace(PLACEHOLDER, result))
