# ============================================================
# Powerlevel10k instant prompt — must stay at the very top
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# ============================================================
# Environment
# ============================================================
export PATH="/Users/james/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export EDITOR="nvim"
export AWS_PROFILE="jp"
alias awsl="aws sso login --profile jp"   # one login covers both profiles: jp (JPDev) and blorteam (BlorTeam)
export DYLD_LIBRARY_PATH="/opt/homebrew/opt/expat/lib"
bindkey "^[[1;3D" backward-word   # Option+Left: jump one word back
bindkey "^[[1;3C" forward-word    # Option+Right: jump one word forward

HISTSIZE=1000000
SAVEHIST=1000000

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# Android SDK (brew cask android-commandlinetools) for Expo / React Native builds; puts adb on PATH
export ANDROID_HOME="/opt/homebrew/share/android-commandlinetools"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

# Prompt theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================
# Shell basics
# ============================================================
alias rzsh="source ~/.zshrc"
alias zsh='h && nvim .zshrc'   # edit this config (NB: shadows the zsh binary)
alias c='clear'
alias h='cd ~'
alias ..="cd .."
alias t='touch'
alias md='mkdir'
alias n='nvim'
alias cb='pbcopy <'            # copy file contents to clipboard: cb <file>
alias fs='du -sh'              # folder size
alias cs='du -sh *'            # size of each item inside a folder
alias time="date +'%T'"        # NB: shadows the time keyword
alias day='date "+%a %b %d"'
alias ip='curl -s ifconfig.me && echo'
alias bi="brew install"
alias sl='pmset sleepnow'
alias shine='sudo shutdown -h now'
alias mcpq='uv run --directory ~/Documents/mcp-query mcp-query ui'   # open the mcp-query web UI (http://localhost:9847)

# ============================================================
# Navigation — general folders
# ============================================================
alias de="cd ~/Desktop"
alias dc="cd ~/Documents"
alias dw="cd ~/Downloads"
alias odc="open ~/Documents"    # Finder on Documents
alias odw="open ~/Downloads"    # Finder on Downloads
alias dotto="cd ~/Documents/dottofiles"
alias wk="cd ~/Work"
alias zan="cd ~/Personal/Projects/zanoba"

# ============================================================
# Navigation — projects
# ============================================================
# Blor
alias blor="cd ~/Work/Projects/blor"
alias Blor="cd ~/Work/Projects/blor/blor-fe"
alias bblor="cd ~/Work/Projects/blor/Blorcompany.com"
alias blorev="cd ~/Work/Projects/blor/B-Revolution"
alias rel="gck staging && gmg crm-release && gps && gck crm-release"
alias bprod="cd ~/Work/Projects/blor && clear"
alias br="bprod && cd B-Revolution && clear"
alias bb="bprod && cd Blorcompany.com && clear"
alias bf="bprod && cd blor-fe && clear"
alias ship="gck main && gmg crm-release && gps && gck staging && gmg main && gps && gck crm-release"
alias shipblor="br && ship && bb && ship"
alias xray="cd ~/Work/Projects/blor/Blorcompany.com && php tools/codebase-analyzer.php && python3 tools/_build_xray.py && open tools/codebase-xray.html"

# Unidata
alias myfee="cd ~/Work/Projects/unidata/myunidata-fe"
alias mybee="cd ~/Work/Projects/unidata/myunidata-be"
alias myfe="cd ~/Work/Projects/unidata/myunidata-fe"
alias mybe="cd ~/Work/Projects/unidata/myunidata-be"
alias mpb="cd ~/Work/Projects/unidata/password-reset-be"
alias mpf="cd ~/Work/Projects/unidata/password-reset-fe"
alias hb="cd ~/Work/Projects/hostbill_new"
alias map="open ~/Work/Projects/hostbill_new/docs/hostbill-map/index.html"
alias pdf='open "$(ls -t ~/Work/Projects/hostbill_new/output/pdf/*.html | head -1)"'

# OG-QR
alias qrw="cd ~/Work/Projects/qr-code/OG-QR_Web"

# ============================================================
# Dev — run / build / install
# ============================================================
alias ike='pnpm run dev'
alias bd='pnpm build'
alias st="pnpm run start"
alias pi='pnpm i'
alias pretty="npx prettier --write ."
alias nyan="blor && ike"
alias goo="Blor && npm run start"
alias via='nohup npm run start > app.log 2>&1 & disown'   # detached npm start, logs to app.log
alias gp="dc && cd tests && node logHello.js"
alias iru='cd ~/drills/understanding && claude "drill me"'   # retrieval-practice drill
alias irw='cd ~/drills/understanding && claude "concept write-up"'   # write derived concepts into concepts.md from memory, coach grades
alias irc='cd ~/drills/understanding && claude "let'\''s think"'   # consult mode: coach carries full drill/philosophy context, discusses without drilling
alias norn='cd ~ && claude "/norn"'   # list saved pending chats

# ============================================================
# Docker
# ============================================================
alias open_docker='cd && open -a Docker Desktop'
alias dcu="docker compose up"
alias dup='open -a Docker; (while ! docker info >/dev/null 2>&1; do sleep 1; done; docker-compose up) & source ~/.zshrc'
alias doc='sigma && docker run -p 3000:3000 blor-fe'
# Blor stack via the root blor/ docker-compose.yaml. Each frontend's
# depends_on pulls the whole backend (web + mariadb + redis), so naming
# just the frontend is enough. bprod cds into blor/ where the compose lives.
# Volleyball stack (Docker Compose app + MariaDB)
# bstack shortcuts (function defined in Functions section)
alias bm="bstack remote"   # blor on the Mini (default work mode)
alias bl="bstack local"    # blor fully local (local DB, seeded from latest backup)
alias bs="bstack status"   # which mode am I in?
alias bn="bstack restart"  # restart containers on the mini
alias bx="bstack down"     # take down all containers on the mini

# ============================================================
# Git & GitHub
# ============================================================
alias gst="git status"
alias gad="git add ."
alias gcm="git commit -m "
alias gpl="git pull"
alias glg="git log"
alias gfl="git log --follow"
alias gbr="git branch"
alias gdl="git branch -d"
alias gck="git checkout"
alias gm="git checkout main"
alias gd="git checkout dev"
alias gs="git checkout staging"
alias gprod="git checkout prod"
alias gmg="git merge"
alias gcl="git clone"
alias gsh="git stash"
alias gsp="git stash pop"
alias gsoft="git reset --soft HEAD~1"
alias gmix="git reset --mixed HEAD~1"
alias ghard="git reset --hard HEAD~1"
alias grm="git remote -v"
alias gdiff="git diff --cached HEAD > diff.txt"
alias pull_branches='git remote update origin --prune'
# ============================================================
# Editors & AI tools
# ============================================================
alias cl="claude"

# ============================================================
# Open URLs & remotes
# ============================================================
alias uni='open "https://unistack-dev.unidata.it/admin/index.php?cmd=unidata"'
alias unm='open "https://unistack-dev.unidata.it/admin/index.php?cmd=unidata&view=mappings"'
alias gha="open https://github.com/ottimis/B-Revolution/actions https://github.com/ottimis/Blorcompany.com/actions https://github.com/ottimis/blor-fe/actions"
alias opm='open "http://100.115.194.118:9000/#!/3/docker/dashboard"'
alias ali="open http://100.115.194.118:8092"   # this file's aliases/functions, served from the Mini (shortcuts-web/)
alias vnc="open vnc://james@100.115.194.118"   # Screen Sharing to the Mini (Spotlight: vnc.app)
alias json="open http://100.115.194.118:8888/json-prettify"   # IT-Tools JSON viewer, served from the Mini (~/docker/it-tools)
alias anal='open "https://analytics.google.com/analytics/web/?authuser=4#/a89123432p399578620/reports/intelligenthome"'   # Blor GA4 home
alias meta='open "https://business.facebook.com/latest/business_home?business_id=877574692394692"'   # Blor Meta Business home
alias ogl="open https://ottimis-group.ticket.oglut.com/"   # Ottimis Group ticketing (oglut)
alias shp="open 'https://ottimis-my.sharepoint.com/my?id=%2Fpersonal%2Fjp_ottimis_com%2FDocuments%2Fworkspace'"   # OneDrive workspace folder (Spotlight: shp.app)
alias ber="open http://100.115.194.118:8094"   # BLOR prod errors from CloudWatch, served from the Mini (blor-errors/)
alias tb="open http://test-01.otm.ai:9000/#!/1/docker/containers"
# ============================================================
# Personal apps & misc
# ============================================================
alias navicat='~/Documents/dottofiles/navicat-premium-reset-trial/reset-trial.sh'
alias pwds="n ~/Personal/Docs/greyrat-vault/pwds"

# ============================================================
# Functions (defined after the aliases they use)
# ============================================================

# Open a file in the terminal with a viewer suited to its format.
op() {
  if (( $# == 0 )); then
    print -u2 'Usage: op <file> [file ...]'
    return 2
  fi

  local file extension
  for file in "$@"; do
    if [[ ! -f "$file" ]]; then
      print -u2 "op: file not found: $file"
      return 1
    fi

    extension="${file##*.}"
    case "${extension:l}" in
      pdf) tdf -m 1 -- "$file" || return ;;
      md) mdr "$file" || return ;;
      html|htm) open -a "Google Chrome" "$file" || return ;;
      png|svg|webp|jpg|jpeg) chafa -- "$file" || return ;;
      mp4|mkv)
        if [[ "$TERM_PROGRAM" == WezTerm || "$TERM" == xterm-kitty ]]; then
          mpv --vo=kitty --really-quiet -- "$file" || return
        else
          mpv --vo=tct --really-quiet -- "$file" || return
        fi
        ;;
      mp3|m4a) mpv --no-video -- "$file" || return ;;
      json) jless -- "$file" || return ;;
      xls|xlsx|csv) vd -- "$file" || return ;;
      numbers)
        # no vd loader: convert every table to an xlsx sheet first
        local xlsx="${TMPDIR:-/tmp}/op-${file:t:r}.xlsx"
        uvx --quiet --with numbers-parser --with openpyxl python -c '
import sys; from numbers_parser import Document; from openpyxl import Workbook
wb = Workbook(); wb.remove(wb.active)
for s in Document(sys.argv[1]).sheets:
    for t in s.tables:
        ws = wb.create_sheet((s.name if len(s.tables) == 1 else f"{s.name}-{t.name}")[:31])
        rows = t.rows(values_only=True)
        while rows and all(v is None for v in rows[-1]): rows.pop()
        for row in rows: ws.append(row)
wb.save(sys.argv[2])' "$file" "$xlsx" && vd -- "$xlsx"
        local rc=$?; rm -f "$xlsx"; (( rc == 0 )) || return $rc
        ;;
      docx)
        local md="${TMPDIR:-/tmp}/op-${file:t:r}.md"
        pandoc -f docx -t gfm --wrap=none -o "$md" -- "$file" && mdr "$md"
        local rc=$?; rm -f "$md"; (( rc == 0 )) || return $rc
        ;;
      doc) textutil -convert txt -stdout -- "$file" | less || return ;;
      *) print -u2 "op: unsupported format: $file"; return 2 ;;
    esac
  done
}


# Pre-push checklist, then git push
gps() {
    read "response1?Have you removed all the console.logs() and the var_dumps()? (y/n): "
    case $response1 in
        [Yy]*) ;;
        [Nn]*) echo "Push cancelled."; return 1 ;;
        *) echo "Invalid response. Push cancelled."; return 1 ;;
    esac

    read "response2?Are you using the right endpoint? (y/n): "
    case $response2 in
        [Yy]*) ;;
        [Nn]*) echo "Push cancelled."; return 1 ;;
        *) echo "Invalid response. Push cancelled."; return 1 ;;
    esac

    echo "✓ Checklist completed. Pushing to remote..."
    git push
}

# Blor stack switcher (docker context "mini" + Mutagen sync):
#   bm / remote  — app + DB on the Mac mini, reachable locally via SSH tunnel (:4200)
#   bl / local   — fully self-contained: local app + LOCAL mariadb, seeded from the
#                  latest ~/Work/Projects/blor/db-backups dump each run. No mini dependency.
#   bn / restart — restart the mini's containers
#   bx / down    — take the mini's containers down
#   bs / status  — tunnel state + local/mini container counts
bstack() {
  local mini="james@100.115.194.118"
  local compose=~/Work/Projects/blor/docker-compose.yaml
  local full_tunnel="ssh -f -N -L 4200:localhost:4200 -L 4001:localhost:4001 -L 3309:localhost:3309 -L 3000:localhost:3000"
  case "$1" in
    local)
      # Fully local: local app + LOCAL mariadb, no dependency on the mini.
      pkill -f "ssh -f -N -L 4200:localhost:4200" 2>/dev/null
      pkill -f "ssh -f -N -L 3309:localhost:3309" 2>/dev/null
      if ! docker --context desktop-linux info >/dev/null 2>&1; then
        echo "⏳ Starting Docker Desktop..."
        open --background -a Docker
        while ! docker --context desktop-linux info >/dev/null 2>&1; do sleep 1; done
      fi
      # local mariadb (plain compose — NOT the mini-db override)
      docker --context desktop-linux compose -f $compose up -d mariadb || return 1
      echo "⏳ Waiting for local MariaDB..."
      until docker --context desktop-linux exec blorcompanycom-mariadb-1 \
              mariadb -uroot -ppippo.123 -e 'SELECT 1' blor >/dev/null 2>&1; do sleep 1; done
      # seed with the newest local backup every run (offline; no mini needed)
      local dump=$(ls -t ~/Work/Projects/blor/db-backups/blor-*.sql.gz 2>/dev/null | head -1)
      if [[ -n "$dump" ]]; then
        echo "📦 Restoring $(basename $dump) → local DB..."
        gunzip -c "$dump" | docker --context desktop-linux exec -i blorcompanycom-mariadb-1 \
          mariadb -uroot -ppippo.123 blor && echo "✅ Local DB restored from $(basename $dump)"
      else
        echo "⚠️  No backup in ~/Work/Projects/blor/db-backups — using existing local data"
      fi
      docker --context desktop-linux compose -f $compose up -d b-revolution &&
        echo "✅ Local stack up (LOCAL DB) → localhost:4200"
      ;;
    remote)
      docker --context desktop-linux compose -f $compose down 2>/dev/null && echo "🛑 Local stack stopped"
      docker --context mini compose -f $compose up -d b-revolution blor-fe || return 1
      pkill -f "ssh -f -N -L 4200:localhost:4200" 2>/dev/null
      pkill -f "ssh -f -N -L 3309:localhost:3309" 2>/dev/null
      ${=full_tunnel} "$mini" && echo "✅ Remote Blor stack up on mini → localhost:3000, localhost:4200"
      ;;
    restart)
      docker --context mini compose -f $compose restart && echo "🔄 Mini containers restarted"
      ;;
    down)
      pkill -f "ssh -f -N -L 4200:localhost:4200" 2>/dev/null
      pkill -f "ssh -f -N -L 3309:localhost:3309" 2>/dev/null
      docker --context mini compose -f $compose down && echo "🛑 Mini containers down"
      ;;
    status)
      pgrep -f "ssh -f -N -L 4200" >/dev/null && echo "🔗 Tunnel: full (remote mode)" ||
        { pgrep -f "ssh -f -N -L 3309" >/dev/null && echo "🔗 Tunnel: DB-only (local mode)" || echo "🔗 Tunnel: down"; }
      echo "💻 Local:  $(docker --context desktop-linux ps --format '{{.Names}}' 2>/dev/null | grep -c 'blorcompanycom\|brevolution\|blor-fe' | tr -d ' ') containers"
      echo "🖥️  Mini:   $(docker --context mini ps --format '{{.Names}}' 2>/dev/null | grep -c 'blorcompanycom\|brevolution\|blor-fe' | tr -d ' ') containers"
      ;;
    *)
      echo "usage: bstack local|remote|restart|down|status" ;;
  esac
}

# New drill concept scaffold: next ## number + date tag before the spine section — conc [title]
conc() {
  local f="$HOME/drills/understanding/concepts.md"
  local n=$(( $(grep -E '^## [0-9]+' "$f" | sed 's/^## \([0-9]*\).*/\1/' | sort -n | tail -1) + 1 ))
  local spine=$(grep -n '^## The spine' "$f" | head -1 | cut -d: -f1)
  [ -z "$spine" ] && { echo "spine section not found in $f"; return 1; }
  local tmp=$(mktemp)
  {
    head -n $((spine - 1)) "$f"
    printf '## %s. %s\n*(written by me from memory, %s)*\n\n\n\n' "$n" "${1:-Title}" "$(date +%Y-%m-%d)"
    tail -n +"$spine" "$f"
  } > "$tmp" && mv "$tmp" "$f"
  ${EDITOR:-nvim} +$((spine + 2)) "$f"
}

# OpenCode with the OpenRouter key from the Keychain (item "openrouter-api-key"),
# passed only to opencode itself, not exported to every shell.
opencode() {
  OPENROUTER_API_KEY=$(security find-generic-password -s openrouter-api-key -w) command opencode "$@"
}

# Rotate the OpenRouter key in the Keychain (prompts for the new key, nothing in history)
alias orkey='security add-generic-password -U -a "$USER" -s openrouter-api-key -w'

