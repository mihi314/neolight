#!/usr/bin/env python3
import csv
import pandas as pd


mappings = pd.read_csv("mappings.csv", sep=" ", quoting=csv.QUOTE_NONE, encoding="utf-8")
# exclude the ones that are empty
mappings = mappings.loc[mappings.new.notna()]

def generate_send_code(new):
    # https://autohotkey.com/docs/commands/Send.htm
    if len(new) == 1:
        # single character
        return "{U+%s}" % hex(ord(new))
    else:
        # allows keys like Esc
        return "{%s}" % new
mappings["send_code"] = mappings.new.apply(generate_send_code)

# creation of the ahk file
# sc02B is the scancode of the # key
template = """
Capslock & sc{sc}::
sc02B & sc{sc}::
    send {send_code}
return"""

result = ""
for _, mapping in mappings.iterrows():
    result += template.format(**mapping)


PLACEHOLDER = "; >>> mappings go here <<<"

with open("build/neolight.ahk", "w", encoding='utf-8') as f_out:
    with open("windows/template.ahk", "r", encoding='utf-8') as f_in:
        f_out.write(f_in.read().replace(PLACEHOLDER, result))
