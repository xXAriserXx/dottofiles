# blor-errors

Password-protected web page listing the BLOR **production errors** stored in AWS CloudWatch. Opened from the laptop with the `ber` alias (`zshrc`). Runs as a Docker container on the Mac mini at http://100.115.194.118:8094 (Tailscale only), deployed in `~/blor-errors` there. This folder is the source of truth; edit here, never on the Mini.

## Files

- `server.py` — the whole backend: stdlib `http.server` + `boto3`, no framework. Auth, AWS access, CloudWatch query, JSON API, serving the pages.
- `index.html` — the errors page (single file, inline JS/CSS). Calls the `/api/*` endpoints below.
- `login.html` — password form; `<!--ERROR-->` is replaced server-side with the error / "no password set" message.
- `Dockerfile` — `python:3.12-alpine` + `boto3`, healthcheck on `/healthz`.
- `docker-compose.yml` — container config, port bound to the Tailscale IP only, `./data` mounted at `/data`.
- `deploy.sh` — copies the files to the Mini and rebuilds the container.

## What it shows

A CloudWatch Logs Insights query on log group `blor-website-log-group` (eu-central-1):

```
fields @timestamp, @message | filter level = "error" | sort @timestamp desc | limit 1000
```

So only entries logged with `Logger->error()` (`level = "error"`). Time ranges: 1h, 24h, 7d (default), 30d, 90d (log retention is 90 days). Max 1000 rows per query; the response carries `matched` so the page can say when results were cut off. Each `@message` is JSON: `note`, `code`, `stacktrace` (JSON frames, paths stripped of `/var/www/html/app/`, `vendor/` frames flagged) and any other keys go to `extra`. Results are cached 60 s per range (`?refresh=1` bypasses it). The page groups errors by message.

## Auth

- Page login: password-only form, password from the `BLOR_ERRORS_PASSWORD` env var. Cookie `be` (HMAC of the password, key in `data/secret.json`), 30 days. Wrong password sleeps 1 s. With no password set, the page only says it is missing.
- The password lives on the container in **Portainer** (Duplicate/Edit → Env), never in the repo.

## AWS access (first match wins)

1. Normal AWS credentials in the container env (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`), e.g. a read-only key from the admin. Set in Portainer.
2. Otherwise an IAM Identity Center (SSO) device login started from the page's "Connect AWS" button: it shows a code, you approve it in the browser, and the token with its refresh token is kept in `data/sso.json` (account `348705108113`, role `BlorTeam`, start URL `https://ottimis.awsapps.com/start`). The refresh token renews the session; if refresh fails the page asks to log in again.

Defaults for the SSO values are in `server.py`; every setting can be overridden by env var (`LOG_GROUP`, `AWS_REGION`, `SSO_START_URL`, `SSO_ACCOUNT_ID`, `SSO_ROLE_NAME`, `DATA_DIR`, `BLOR_ERRORS_PORT`).

## API (all need the cookie except `/healthz`)

- `GET /api/errors?range=7d[&refresh=1]` — the errors; `409 {needLogin}` if AWS login is needed, `502` on CloudWatch errors.
- `GET /api/status` — AWS mode (`credentials` / `sso`), connected state, role, log group.
- `POST /api/aws/login` — start the SSO device login (returns code + URL).
- `GET /api/aws/poll` — poll the device login: `pending` / `ok` / `expired` / `denied`.
- `POST /api/aws/logout` — drop the SSO token and clear the cache.
- `GET /healthz` — no auth, used by the Docker healthcheck.

## Deploy

`./deploy.sh` (from this folder): `scp`s `server.py index.html login.html Dockerfile docker-compose.yml` to `minish:blor-errors/`, then reads the password / AWS key from the running container's env and runs `docker compose up -d --build`, so values set in Portainer survive a redeploy. Don't put them in `docker-compose.yml` or `.env`.

## Runtime state (on the Mini only, not in git)

`~/blor-errors/data/` (mode 700, git-ignored): `secret.json` (cookie signing key), `sso.json` (SSO client + tokens, mode 600). Deleting `secret.json` logs everyone out; deleting `sso.json` forces a new "Connect AWS".

## Gotchas

- Reachable only over Tailscale; the port is bound to `100.115.194.118`, not `0.0.0.0` on the host.
- Port 8094. Siblings on the Mini: `shortcuts-web` 8092, `keyboard-web` 8093.
- No tests; check a change by deploying and opening `ber`. Python logs go to `docker logs blor-errors` (request logging is disabled).
