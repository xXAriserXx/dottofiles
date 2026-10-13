#!/usr/bin/env python3
"""Web page listing the BLOR production errors stored in AWS CloudWatch.

Runs in a container on the Mac mini. Shows only Logger->error() entries
(`level = "error"`) from the log group LOG_GROUP, via a Logs Insights query.

Login: password-only form (login.html), password from the BLOR_ERRORS_PASSWORD
env var (set it in Portainer); 30-day cookie. Without it the page only says
the password is missing.

AWS access, first match wins:
  1. normal AWS credentials (AWS_ACCESS_KEY_ID/AWS_SECRET_ACCESS_KEY env, or a
     profile) — e.g. a read-only key the admin creates;
  2. otherwise an IAM Identity Center (SSO) login started from the page: it
     shows a code, you approve it in the browser, and the token (with its
     refresh token) is kept in DATA_DIR/sso.json for the role SSO_ROLE_NAME.
"""
import hashlib, hmac, json, os, re, secrets, sys, threading, time
from datetime import datetime, timezone
from urllib.parse import parse_qs, urlparse
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import boto3, botocore
from botocore.config import Config

HERE      = os.path.dirname(os.path.abspath(__file__))
HOST      = os.environ.get("BLOR_ERRORS_HOST", "0.0.0.0")
PORT      = int(os.environ.get("BLOR_ERRORS_PORT", "8094"))
PASSWORD  = os.environ.get("BLOR_ERRORS_PASSWORD", "")
DATA_DIR  = os.environ.get("DATA_DIR", "/data")
LOG_GROUP = os.environ.get("LOG_GROUP", "blor-website-log-group")
REGION    = os.environ.get("AWS_REGION", "eu-central-1")
SSO_START = os.environ.get("SSO_START_URL", "https://ottimis.awsapps.com/start")
SSO_ACCT  = os.environ.get("SSO_ACCOUNT_ID", "348705108113")
SSO_ROLE  = os.environ.get("SSO_ROLE_NAME", "BlorTeam")
LIMIT     = 1000
RANGES    = {"1h": 1, "24h": 24, "7d": 168, "30d": 720, "90d": 2160}   # retention is 90 days
QUERY     = ('fields @timestamp, @message | filter level = "error" '
             f'| sort @timestamp desc | limit {LIMIT}')
APP_ROOT  = "/var/www/html/app/"
UNSIGNED  = Config(signature_version=botocore.UNSIGNED, region_name=REGION)

class NeedLogin(Exception):
    pass

def read_json(name, default):
    try:
        with open(os.path.join(DATA_DIR, name), encoding="utf-8") as f:
            return json.load(f)
    except (OSError, ValueError):
        return default

def write_json(name, data):
    path = os.path.join(DATA_DIR, name)
    tmp = path + ".tmp"
    with open(os.open(tmp, os.O_WRONLY | os.O_CREAT | os.O_TRUNC, 0o600), "w") as f:
        json.dump(data, f)
    os.replace(tmp, path)

def cookie_secret():
    s = read_json("secret.json", {}).get("secret")
    if not s:
        s = secrets.token_hex(32)
        write_json("secret.json", {"secret": s})
    return s

# ---------------------------------------------------------------- AWS access

class Aws:
    def __init__(self):
        self.lock = threading.Lock()
        self.sso = read_json("sso.json", {})
        self.role = None          # cached role credentials
        self.pending = None       # device login in progress
        self.static = boto3.Session(region_name=REGION).get_credentials() is not None

    def mode(self):
        return "credentials" if self.static else "sso"

    def save(self):
        write_json("sso.json", self.sso)

    def access_token(self):
        now = time.time()
        if self.sso.get("accessToken") and self.sso.get("accessExpires", 0) > now + 60:
            return self.sso["accessToken"]
        if self.sso.get("refreshToken"):
            oidc = boto3.client("sso-oidc", config=UNSIGNED)
            try:
                r = oidc.create_token(clientId=self.sso["clientId"], clientSecret=self.sso["clientSecret"],
                                      grantType="refresh_token", refreshToken=self.sso["refreshToken"])
            except botocore.exceptions.ClientError:
                self.logout()
                raise NeedLogin()
            self.store_token(r)
            return self.sso["accessToken"]
        raise NeedLogin()

    def store_token(self, r):
        self.sso["accessToken"] = r["accessToken"]
        self.sso["accessExpires"] = time.time() + r.get("expiresIn", 3600)
        if r.get("refreshToken"):
            self.sso["refreshToken"] = r["refreshToken"]
        self.sso["loggedInAt"] = self.sso.get("loggedInAt") or int(time.time())
        self.save()

    def logout(self):
        self.sso = {k: v for k, v in self.sso.items() if k in ("clientId", "clientSecret", "clientExpires")}
        self.role = None
        self.save()

    def role_credentials(self):
        if self.role and self.role["expiration"] / 1000 > time.time() + 120:
            return self.role
        sso = boto3.client("sso", config=UNSIGNED)
        try:
            r = sso.get_role_credentials(roleName=SSO_ROLE, accountId=SSO_ACCT,
                                         accessToken=self.access_token())
        except botocore.exceptions.ClientError as e:
            if e.response["Error"]["Code"] in ("UnauthorizedException", "ForbiddenException"):
                self.sso.pop("accessToken", None)
                self.save()
                raise NeedLogin()
            raise
        self.role = r["roleCredentials"]
        return self.role

    def logs(self):
        with self.lock:
            if self.static:
                return boto3.client("logs", region_name=REGION)
            c = self.role_credentials()
            return boto3.client("logs", region_name=REGION, aws_access_key_id=c["accessKeyId"],
                                aws_secret_access_key=c["secretAccessKey"], aws_session_token=c["sessionToken"])

    # --- device login (the same flow as `aws sso login --use-device-code`)

    def start_login(self):
        with self.lock:
            oidc = boto3.client("sso-oidc", config=UNSIGNED)
            if not self.sso.get("clientId") or self.sso.get("clientExpires", 0) < time.time() + 86400:
                r = oidc.register_client(clientName="blor-errors", clientType="public",
                                         scopes=["sso:account:access"])
                self.sso.update(clientId=r["clientId"], clientSecret=r["clientSecret"],
                                clientExpires=r["clientSecretExpiresAt"])
                self.save()
            d = oidc.start_device_authorization(clientId=self.sso["clientId"],
                                                clientSecret=self.sso["clientSecret"], startUrl=SSO_START)
            self.pending = {"deviceCode": d["deviceCode"], "expires": time.time() + d["expiresIn"]}
            return {"code": d["userCode"], "url": d["verificationUriComplete"], "expiresIn": d["expiresIn"]}

    def poll_login(self):
        with self.lock:
            if not self.pending:
                return "none"
            if time.time() > self.pending["expires"]:
                self.pending = None
                return "expired"
            oidc = boto3.client("sso-oidc", config=UNSIGNED)
            try:
                r = oidc.create_token(clientId=self.sso["clientId"], clientSecret=self.sso["clientSecret"],
                                      grantType="urn:ietf:params:oauth:grant-type:device_code",
                                      deviceCode=self.pending["deviceCode"])
            except botocore.exceptions.ClientError as e:
                code = e.response["Error"]["Code"]
                if code in ("AuthorizationPendingException", "SlowDownException"):
                    return "pending"
                self.pending = None
                return "expired" if code == "ExpiredTokenException" else "denied"
            self.pending = None
            self.sso.pop("loggedInAt", None)
            self.store_token(r)
            self.role = None
            return "ok"

    def status(self):
        s = {"mode": self.mode(), "role": SSO_ROLE, "account": SSO_ACCT, "logGroup": LOG_GROUP}
        if not self.static:
            s["connected"] = bool(self.sso.get("refreshToken") or self.sso.get("accessToken"))
            s["since"] = self.sso.get("loggedInAt")
        return s

AWS = Aws()

# ---------------------------------------------------------------- errors

CACHE, CACHE_TTL = {}, 60

def parse_frames(raw):
    try:
        frames = json.loads(raw) if isinstance(raw, str) else (raw or [])
    except ValueError:
        return []
    out = []
    for f in frames if isinstance(frames, list) else []:
        file = (f.get("file") or "").replace(APP_ROOT, "")
        fn = (f.get("class", "") + f.get("type", "") + f.get("function", ""))
        out.append({"file": file, "line": f.get("line"), "fn": fn, "vendor": file.startswith("vendor/")})
    return out

def parse_event(ts, message):
    try:
        m = json.loads(message)
    except ValueError:
        m = {"note": message}
    if not isinstance(m, dict):
        m = {"note": str(m)}
    when = datetime.strptime(ts, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=timezone.utc)
    extra = {k: v for k, v in m.items() if k not in ("level", "code", "note", "stacktrace")}
    return {"ts": int(when.timestamp() * 1000), "note": str(m.get("note") or ""), "code": m.get("code"),
            "frames": parse_frames(m.get("stacktrace")), "extra": extra}

def fetch(range_key, force=False):
    hours = RANGES.get(range_key, 168)
    hit = CACHE.get(range_key)
    if hit and not force and time.time() - hit["fetched"] < CACHE_TTL:
        return hit
    logs = AWS.logs()
    end = int(time.time())
    qid = logs.start_query(logGroupName=LOG_GROUP, startTime=end - hours * 3600, endTime=end,
                           queryString=QUERY, limit=LIMIT)["queryId"]
    deadline = time.time() + 90
    while True:
        r = logs.get_query_results(queryId=qid)
        if r["status"] not in ("Scheduled", "Running"):
            break
        if time.time() > deadline:
            logs.stop_query(queryId=qid)
            raise RuntimeError("CloudWatch query took too long")
        time.sleep(1)
    if r["status"] != "Complete":
        raise RuntimeError(f"CloudWatch query {r['status'].lower()}")
    items = []
    for row in r["results"]:
        f = {c["field"]: c.get("value", "") for c in row}
        if "@timestamp" in f:
            items.append(parse_event(f["@timestamp"], f.get("@message", "")))
    data = {"items": items, "range": range_key, "fetched": time.time(),
            "matched": int(r.get("statistics", {}).get("recordsMatched", len(items))), "limit": LIMIT}
    CACHE[range_key] = data
    return data

# ---------------------------------------------------------------- web

os.makedirs(DATA_DIR, exist_ok=True)
PAGE  = open(os.path.join(HERE, "index.html"), "rb").read()
LOGIN = open(os.path.join(HERE, "login.html"), encoding="utf-8").read()
COOKIE_AGE = 30 * 24 * 3600
TOKEN = hmac.new(cookie_secret().encode(), ("blor-errors:" + PASSWORD).encode(), hashlib.sha256).hexdigest()

class Handler(BaseHTTPRequestHandler):
    def send(self, code, body, ctype, headers=()):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        for k, v in headers:
            self.send_header(k, v)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def json(self, data, code=200):
        self.send(code, json.dumps(data).encode(), "application/json")

    def redirect(self, to, cookie=None):
        headers = [("Location", to)] + ([("Set-Cookie", cookie)] if cookie else [])
        self.send(303, b"", "text/plain", headers)

    def login_page(self, error=False):
        if not PASSWORD:
            msg = ('<p class="err">No password set yet. Add <code>BLOR_ERRORS_PASSWORD</code> '
                   'to this container\'s env in Portainer, then reload.</p>')
        else:
            msg = '<p class="err">Wrong password</p>' if error else ""
        self.send(200, LOGIN.replace("<!--ERROR-->", msg).encode(), "text/html; charset=utf-8")

    def authed(self):
        if not PASSWORD:
            return False
        for part in self.headers.get("Cookie", "").split(";"):
            name, _, value = part.strip().partition("=")
            if name == "be" and hmac.compare_digest(value.encode(), TOKEN.encode()):
                return True
        return False

    def do_GET(self):
        url = urlparse(self.path)
        path, qs = url.path, parse_qs(url.query)
        if path == "/logout":
            return self.redirect("/", "be=; Path=/; Max-Age=0; HttpOnly; SameSite=Lax")
        if path == "/healthz":
            return self.send(200, b"ok", "text/plain")
        if not self.authed():
            if path.startswith("/api/"):
                return self.json({"error": "login required"}, 401)
            return self.login_page(error="e" in qs)
        if path == "/":
            return self.send(200, PAGE, "text/html; charset=utf-8")
        if path == "/api/status":
            return self.json(AWS.status())
        if path == "/api/errors":
            try:
                return self.json(fetch(qs.get("range", ["7d"])[0], force="refresh" in qs))
            except NeedLogin:
                return self.json({"error": "aws login required", "needLogin": True}, 409)
            except Exception as e:
                return self.json({"error": str(e)}, 502)
        if path == "/api/aws/poll":
            return self.json({"state": AWS.poll_login()})
        self.send(404, b"not found", "text/plain")

    def do_POST(self):
        path = urlparse(self.path).path
        if path == "/login":
            length = min(int(self.headers.get("Content-Length") or 0), 4096)
            form = parse_qs(self.rfile.read(length).decode("utf-8", "replace"))
            given = form.get("password", [""])[0]
            if PASSWORD and hmac.compare_digest(given.encode(), PASSWORD.encode()):
                return self.redirect("/", f"be={TOKEN}; Path=/; Max-Age={COOKIE_AGE}; HttpOnly; SameSite=Lax")
            time.sleep(1)   # slow down guessing
            return self.redirect("/?e=1")
        if not self.authed():
            return self.json({"error": "login required"}, 401)
        if path == "/api/aws/login":
            try:
                return self.json(AWS.start_login())
            except Exception as e:
                return self.json({"error": str(e)}, 502)
        if path == "/api/aws/logout":
            with AWS.lock:
                AWS.logout()
            CACHE.clear()
            return self.json({"ok": True})
        self.send(404, b"not found", "text/plain")

    def log_message(self, *args):
        pass

if __name__ == "__main__":
    if not PASSWORD:
        print("BLOR_ERRORS_PASSWORD is not set — the page only shows a 'set the password' notice", flush=True)
    print(f"blor-errors on http://{HOST}:{PORT} (aws: {AWS.mode()})", flush=True)
    ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()
