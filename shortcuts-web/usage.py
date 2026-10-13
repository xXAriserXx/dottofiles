#!/usr/bin/env python3
"""Count how often each alias/function in the zshrc appears in the shell history.

Runs on the laptop (the history lives here, the page runs on the Mac mini) and
prints JSON: {"counts": {name: n}, "commands": total, "generated": epoch}.
Only names and counts leave the machine, never the commands themselves.
Pushed to the Mini's data/usage.json by push-usage.sh / the post-commit hook.
"""
import json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ZSHRC = os.environ.get("ZSHRC", os.path.join(HERE, "..", "zshrc"))
HISTORY = os.environ.get("HISTFILE", os.path.expanduser("~/.zsh_history"))

ALIAS_RE = re.compile(r"^\s*alias\s+([^=\s]+)=(.*)$")
FUNC_RE  = re.compile(r"^\s*(?:function\s+([\w-]+)|([\w-]+)\s*\(\s*\))\s*(?:\(\s*\))?\s*\{")
EXT_RE   = re.compile(r"^: \d+:\d+;")                   # EXTENDED_HISTORY prefix
SPLIT_RE = re.compile(r"&&|\|\||[;|\n]")                # first word of every pipeline segment
PREFIXES = {"sudo", "time", "command", "builtin", "noglob", "nocorrect", "env"}

def defined_names(text):
    names, pairs = set(), []
    for line in text.splitlines():
        m = ALIAS_RE.match(line)
        if m:
            names.add(m.group(1))
            value = m.group(2).split("#")[0].strip().strip("'\"")
            if re.fullmatch(r"[\w.-]+", value):          # `alias old=new` style rename
                pairs.append((m.group(1), value))
            continue
        f = FUNC_RE.match(line)
        if f:
            names.add(f.group(1) or f.group(2))
    return names, pairs

def first_words(history_text):
    n = 0
    for entry in re.sub(r"\\\n", " ", history_text).split("\n"):
        entry = EXT_RE.sub("", entry).strip()
        if not entry:
            continue
        n += 1
        for seg in SPLIT_RE.split(entry):
            words = seg.split()
            while words and (words[0] in PREFIXES or re.fullmatch(r"\w+=\S*", words[0])):
                words.pop(0)                            # `sudo x`, `FOO=1 x`
            if words:
                yield words[0]
    yield None, n

def main():
    with open(ZSHRC, encoding="utf-8") as f:
        names, pairs = defined_names(f.read())
    with open(HISTORY, encoding="utf-8", errors="replace") as f:
        raw = f.read()

    counts = dict.fromkeys(names, 0)
    commands = 0
    for w in first_words(raw):
        if isinstance(w, tuple):
            commands = w[1]
        elif w in counts:
            counts[w] += 1

    # an alias and its renamed twin count as one: usage of either clears both
    for old, new in pairs:
        if old in counts and new in counts:
            total = counts[old] + counts[new]
            counts[old] = counts[new] = total

    json.dump({"counts": counts, "commands": commands, "generated": int(time.time())},
              sys.stdout, separators=(",", ":"))

if __name__ == "__main__":
    main()
