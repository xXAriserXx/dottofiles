#!/usr/bin/env python3
"""Web page listing the aliases and functions defined in the dotfiles zshrc.

Reads zshrc from a bare mirror of the dotfiles repo kept next to this script
(fetched at most once a minute). A mirror rather than ~/Documents/dottofiles
because launchd agents can't read ~/Documents (macOS privacy protection).
Python 3.9 stdlib only — runs on the Mac mini's system python.
"""
import json, os, re, shlex, subprocess, threading, time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE  = os.path.dirname(os.path.abspath(__file__))
REPO  = os.environ.get("DOTFILES_REPO", os.path.join(HERE, "dotfiles.git"))
REF   = os.environ.get("DOTFILES_REF", "main")
HOST  = os.environ.get("SHORTCUTS_HOST", "100.115.194.118")   # Tailscale only
PORT  = int(os.environ.get("SHORTCUTS_PORT", "8092"))
FETCH_EVERY = 60

_lock = threading.Lock()
_last_fetch = 0.0
_fetch_error = ""

def git(*args, timeout=10):
    r = subprocess.run(["git", "-C", REPO] + list(args), capture_output=True,
                       text=True, timeout=timeout)
    return r.returncode, r.stdout, r.stderr.strip()

def load_zshrc():
    """Return (text, source label, commit line, fetch error)."""
    global _last_fetch, _fetch_error
    with _lock:
        if time.time() - _last_fetch > FETCH_EVERY:
            _last_fetch = time.time()
            try:
                rc, _, err = git("fetch", "-q", "--prune")
                _fetch_error = "" if rc == 0 else (err or "git fetch failed")
            except subprocess.TimeoutExpired:
                _fetch_error = "git fetch timed out"
        fetch_error = _fetch_error
    rc, text, err = git("show", REF + ":zshrc")
    if rc != 0:
        raise RuntimeError("can't read zshrc from " + REPO + ": " + err)
    _, commit, _ = git("log", "-1", "--format=%h · %s · %cr", REF)
    return text, REF, commit.strip(), fetch_error

ALIAS_RE = re.compile(r"^\s*alias\s+([^=\s]+)=(.*)$")
FUNC_RE  = re.compile(r"^\s*(?:function\s+([\w-]+)\s*(?:\(\s*\))?|([\w-]+)\s*\(\s*\))\s*\{")
RULE_RE  = re.compile(r"^#\s*={5,}\s*$")
URL_RE   = re.compile(r"https?://[^\s'\"]+")

def split_alias_value(rest):
    """`'cmd' # note` -> ('cmd', 'note'), respecting shell quoting."""
    try:
        lex = shlex.shlex(rest, posix=True)
        lex.whitespace_split = True
        lex.commenters = ""
        value = lex.get_token() or ""
        trailing = lex.instream.read().strip()
    except ValueError:
        value, trailing = rest.strip(), ""
    note = trailing[1:].strip() if trailing.startswith("#") else ""
    return value, note

def kind_of(value):
    v = value.strip()
    if URL_RE.search(v) and ("open" in v.split()[:3] or v.startswith("open")):
        return "url"
    if v.startswith("cd ") or v.startswith("cd&&") or re.match(r"^\w+ && cd ", v):
        return "nav"
    if v.startswith("git ") or v.startswith("gh "):
        return "git"
    if v.startswith("open "):
        return "open"
    return "cmd"

def parse(text):
    lines = text.splitlines()
    sections, current = [], None
    pending = []          # comment lines directly above the next item
    in_func = 0           # brace depth while skipping a function body

    def section(title):
        nonlocal current
        current = {"title": title, "items": []}
        sections.append(current)

    i = 0
    while i < len(lines):
        line = lines[i]
        s = line.strip()

        if in_func:
            in_func += line.count("{") - line.count("}")
            i += 1
            continue

        if RULE_RE.match(s):
            # "# ===" / "# Title" [/ "# more"] / "# ==="
            j, title = i + 1, []
            while j < len(lines) and not RULE_RE.match(lines[j].strip()):
                title.append(lines[j].strip().lstrip("#").strip())
                j += 1
            section(re.sub(r"\s*\(.*\)$", "", title[0]) if title else "Untitled")
            pending = []
            i = j + 1
            continue

        if current is None:
            section("Top")

        if not s:
            pending = []
        elif s.startswith("#"):
            body = s.lstrip("#").strip()
            if not re.match(r"^(alias|if|fi|export)\b", body):   # skip commented-out code
                pending.append(body)
        else:
            m = ALIAS_RE.match(line)
            f = FUNC_RE.match(line)
            if m:
                if pending:
                    current["items"].append({"type": "note", "text": "\n".join(pending)})
                    pending = []
                value, note = split_alias_value(m.group(2))
                current["items"].append({
                    "type": "alias", "name": m.group(1), "value": value, "note": note,
                    "kind": kind_of(value), "urls": URL_RE.findall(value), "line": i + 1,
                })
            elif f:
                name = f.group(1) or f.group(2)
                current["items"].append({
                    "type": "function", "name": name, "note": "\n".join(pending),
                    "line": i + 1,
                })
                pending = []
                in_func = line.count("{") - line.count("}")
            else:
                pending = []
        i += 1

    out = []
    for sec in sections:
        items = sec["items"]
        # drop notes that end up with nothing after them
        items = [it for k, it in enumerate(items)
                 if it["type"] != "note" or (k + 1 < len(items) and items[k + 1]["type"] != "note")]
        if any(it["type"] != "note" for it in items):
            out.append({"title": sec["title"], "items": items})
    return out

def payload():
    text, source, commit, fetch_error = load_zshrc()
    sections = parse(text)
    count = lambda t: sum(1 for s in sections for it in s["items"] if it["type"] == t)
    return {
        "sections": sections, "aliases": count("alias"), "functions": count("function"),
        "source": source, "commit": commit, "fetch_error": fetch_error,
    }

PAGE = open(os.path.join(HERE, "index.html"), "rb").read()

class Handler(BaseHTTPRequestHandler):
    def send(self, code, body, ctype):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = self.path.split("?")[0]
        if path == "/":
            self.send(200, PAGE, "text/html; charset=utf-8")
        elif path == "/api/shortcuts":
            try:
                body = json.dumps(payload()).encode()
                self.send(200, body, "application/json")
            except Exception as e:
                self.send(500, json.dumps({"error": str(e)}).encode(), "application/json")
        else:
            self.send(404, b"not found", "text/plain")

    def log_message(self, *args):
        pass

if __name__ == "__main__":
    print(f"shortcuts on http://{HOST}:{PORT}", flush=True)
    ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
