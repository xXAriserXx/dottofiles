#!/bin/sh
# Rebuild the keyboard page from the dotfiles and push it to the Mac mini container.
set -e
cd "$(dirname "$0")"
python3 build.py
ssh minish 'mkdir -p ~/keyboard-web/site'
scp docker-compose.yml minish:keyboard-web/
scp site/index.html minish:keyboard-web/site/
ssh minish 'export PATH=/usr/local/bin:$PATH; cd ~/keyboard-web && docker compose up -d'
echo "http://100.115.194.118:8093"
