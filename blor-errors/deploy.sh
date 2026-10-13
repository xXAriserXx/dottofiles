#!/bin/sh
# Copy blor-errors to the Mac mini (~/blor-errors) and rebuild the container,
# keeping the env vars set in Portainer (password, optional AWS key).
set -e
cd "$(dirname "$0")"
ssh minish 'mkdir -p blor-errors/data && chmod 700 blor-errors/data'
scp -q server.py index.html login.html Dockerfile docker-compose.yml minish:blor-errors/
ssh minish 'export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH; cd ~/blor-errors
  if docker inspect blor-errors >/dev/null 2>&1; then
    docker inspect -f "{{range .Config.Env}}{{println .}}{{end}}" blor-errors > .env.keep
    while IFS= read -r line; do
      case "$line" in BLOR_ERRORS_PASSWORD=*|AWS_ACCESS_KEY_ID=*|AWS_SECRET_ACCESS_KEY=*) export "$line";; esac
    done < .env.keep
    rm -f .env.keep
  fi
  docker compose up -d --build'
