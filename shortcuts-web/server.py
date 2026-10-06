#!/usr/bin/env python3
"""Web page listing the aliases and functions defined in the dotfiles zshrc.

Runs in a container on the Mac mini and re-reads the mounted zshrc on every
request. The dotfiles post-commit hook (githooks/) copies zshrc there.
Password-protected (HTTP Basic, any username) via the SHORTCUTS_PASSWORD env
var; a 30-day cookie saves retyping it. Refuses to start without it.
"""
import base64, binascii, hashlib, hmac, json, os, re, shlex, sys, time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE  = os.path.dirname(os.path.abspath(__file__))
ZSHRC = os.environ.get("ZSHRC", "/data/zshrc")
HOST  = os.environ.get("SHORTCUTS_HOST", "0.0.0.0")
PORT  = int(os.environ.get("SHORTCUTS_PORT", "8092"))
PASSWORD = os.environ.get("SHORTCUTS_PASSWORD", "")
TOKEN = hashlib.sha256(("shortcuts:" + PASSWORD).encode()).hexdigest()[:32]

def load_zshrc():
    """Return (text, mtime)."""
    with open(ZSHRC, encoding="utf-8") as f:
        return f.read(), os.fstat(f.fileno()).st_mtime

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
    text, mtime = load_zshrc()
    sections = parse(text)
    count = lambda t: sum(1 for s in sections for it in s["items"] if it["type"] == t)
    return {
        "sections": sections, "aliases": count("alias"), "functions": count("function"),
        "updated": int(mtime),
    }

PAGE = open(os.path.join(HERE, "index.html"), "rb").read()

class Handler(BaseHTTPRequestHandler):
    def send(self, code, body, ctype, cookie=None):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        if cookie:
            self.send_header("Set-Cookie", cookie)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def authed(self):
        auth = self.headers.get("Authorization", "")
        if auth.startswith("Basic "):
            try:
                _, _, given = base64.b64decode(auth[6:]).decode().partition(":")
            except (binascii.Error, UnicodeDecodeError):
                given = ""
            if hmac.compare_digest(given.encode(), PASSWORD.encode()):
                return True
        for part in self.headers.get("Cookie", "").split(";"):
            name, _, value = part.strip().partition("=")
            if name == "sc" and hmac.compare_digest(value.encode(), TOKEN.encode()):
                return True
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="shortcuts"')
        self.send_header("Content-Length", "0")
        self.end_headers()
        return False

    def do_GET(self):
        if not self.authed():
            return
        path = self.path.split("?")[0]
        if path == "/":
            self.send(200, PAGE, "text/html; charset=utf-8",
                      cookie=f"sc={TOKEN}; Path=/; Max-Age=2592000; HttpOnly; SameSite=Lax")
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
    if not PASSWORD:
        sys.exit("SHORTCUTS_PASSWORD is not set — refusing to serve without a password")
    print(f"shortcuts on http://{HOST}:{PORT}", flush=True)
    ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
