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
export PATH="/Users/james/.antigravity/antigravity/bin:$PATH"   # Antigravity
export EDITOR="nvim"
export AWS_PROFILE="jp"
alias awslogin="aws sso login --profile jp"
export DYLD_LIBRARY_PATH="/opt/homebrew/opt/expat/lib"

HISTSIZE=1000000
SAVEHIST=1000000

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

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
alias e='cd'
alias ..="cd .."
alias t='touch'
alias md='mkdir'
alias rd='rmdir'
alias n='nvim'
alias nv='code -n'             # new VS Code window
alias cb='pbcopy <'            # copy file contents to clipboard: cb <file>
alias fs='du -sh'              # folder size
alias cs='du -sh *'            # size of each item inside a folder
alias time="date +'%T'"        # NB: shadows the time keyword
alias day='date "+%a %b %d"'
alias ip='curl -s ifconfig.me && echo'
alias bi="brew install"
alias sl='pmset sleepnow'
alias shine='sudo shutdown -h now'

# ============================================================
# Navigation — general folders
# ============================================================
alias de="cd ~/Desktop"
alias dc="cd ~/Documents"
alias dw="cd ~/Downloads"
alias dotto="cd ~/Documents/dottofiles"
alias wk="cd ~/Documents/work"
alias pj="wk && cd projects"
alias jt="cd ~/Desktop/just-try"
alias tl="dc && cd .traveler_logs"
alias play="dc && cd work/playground"
alias fuse='dc && cd useful'
alias fvim='fuse && cd vim'
alias fmov="dc && cd movies"
alias fmus="dc && cd music"
alias media="dc && cd media"
alias video="media && cd video"
alias audio="media && cd audio"
alias image="media && cd image"
alias testing="de && cd test"
alias next="cd ~/nextcloud-files/admin/files"
alias kaizen='cd "$HOME/Library/CloudStorage/GoogleDrive-jrjrjrpr365@gmail.com/My Drive/DriveSyncFiles/kaizen"'
alias greyrat="cd /Users/james/Documents/greyrat-vault"

# ============================================================
# Navigation — projects
# ============================================================
# Blor
alias blor="cd ~/Documents/blor"
alias Blor="pj && cd old-blor && cd blor-fe"
alias bblor="pj && cd Blor/Blorcompany.com"
alias blorev="pj && cd Blor/B-Revolution"
alias blorapp="pj && cd blor_app && cd BlorApp"
alias bdev="cd ~/Documents/blor/dev"
alias bprod="cd ~/Documents/blor/prod && clear"
alias br="bprod && cd B-Revolution && clear"
alias bb="bprod && cd Blorcompany.com && clear"
alias bf="bprod && cd blor-fe && clear"
alias bexp="cd ~/Documents/blor/experimental"
alias xray="cd ~/Documents/blor/prod/Blorcompany.com && php tools/codebase-analyzer.php && python3 tools/_build_xray.py && open tools/codebase-xray.html"
alias oxray="open ~/Documents/blor/prod/Blorcompany.com/tools/codebase-xray.html"

# Unidata
alias myfee="pj && cd my-unidata-2"
alias mybee="pj && cd myunidata-be"
alias myfe="pj && cd unidata/test/myunidata-fe"
alias mybe="pj && cd unidata/myunidata-be"
alias mpb="pj && cd unidata/my-uni-pass/myuni-pass-be"
alias mpf="pj && cd unidata/my-uni-pass/myuni-pass-fe"
alias hb="dc && cd hostbill_new"

# Other projects
alias lea="cd ~/projects/leamor"
alias vl="cd ~/projects/Volleyball"
alias rp="cd ~/Documents/reseller-portal"
alias rpa="cd ~/Documents/reseller-portal/backend"
alias rpf="cd ~/Documents/reseller-portal/frontend"
alias zeus_be='cd /Users/dumitruzanogea/Documents/Progetti/New-Zeus/zeus-be'
alias zeus_fe='cd /Users/dumitruzanogea/Documents/Progetti/New-Zeus/zeus-fe'
alias adb_dir='root && cd Library/Android/sdk/platform-tools'

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
alias p="gop && node script.js"
alias gop="cd && cd Documents/work/pwd"
alias gp="dc && cd tests && node logHello.js"
alias iru='cd ~/drills/understanding && claude "drill me"'   # retrieval-practice drill
alias irw='cd ~/drills/understanding && claude "concept write-up"'   # write derived concepts into concepts.md from memory, coach grades
alias norn='cd ~ && claude "/norn"'   # list saved pending chats

# ============================================================
# Docker
# ============================================================
alias open_docker='cd && open -a Docker Desktop'
alias dcu="docker compose up"
alias dup='open -a Docker; (while ! docker info >/dev/null 2>&1; do sleep 1; done; docker-compose up) & source ~/.zshrc'
alias doc='sigma && docker run -p 3000:3000 blor-fe'
# Blor stack via the root prod/ docker-compose.yaml. Each frontend's
# depends_on pulls the whole backend (web + mariadb + redis), so naming
# just the frontend is enough. bprod cds into prod/ where the compose lives.
alias d="bprod && docker compose up"                     # everything
alias dfe="bprod && docker compose up blor-fe"           # storefront + backend
alias drev="bprod && docker compose up b-revolution"     # admin + backend
alias ddown="bprod && docker compose down"               # stop ALL (whatever was started)
# Zeus
alias start_zeus_old='root && docker start zeus20-php-web-1'
alias start_zeus_all='root && docker start zeus-be-web-1 && zeus_fe && ns'
alias launch_ng="root && open -a 'Firefox Developer Edition' 'www.localhost:4200'"
alias launch_ionic="root && open -a 'Firefox Developer Edition' 'www.localhost:8100'"

# ============================================================
# Kubernetes
# ============================================================
alias kbgn="kubectl get namespaces"
alias kbgp="kubectl get pods"
alias kbblor="kubectl get pods -n blor"
alias kbbfe="kubectl exec -it blor-fe-5d58567b46-knbrr -n blor -- /bin/bash"
alias temporary="kubectl cp /Users/james/Documents/blor/prod/Blorcompany.com/src/app/vendor/ottimis/phplibs/src/dataBase.php blor/blor-be-6fcd79c89c-xvrrp:/var/www/html/app/vendor/ottimis/phplibs/src/dataBase.php"

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
alias ghls="gh repo list"
alias cloneblor='cd ~/Documents && if [ ! -d blor ]; then mkdir -p blor/dev blor/prod && for dir in blor/dev blor/prod; do cd ~/Documents/$dir && git clone git@github.com:ottimis/blor-fe.git && git clone git@github.com:ottimis/Blorcompany.com.git && git clone git@github.com:ottimis/B-Revolution.git; done && echo "Successfully cloned all repositories."; else echo "Folder blor already exists. Stopping."; fi'

# ============================================================
# tmux
# ============================================================
alias tms="tmux new-session -s"
alias tuni="tmux attach -t my-uni"
alias ttl="tmux attach -t logs"
alias tbl="tmux attach -t blor"

# ============================================================
# Editors & AI tools
# ============================================================
alias cnvim="h && nvim .config/nvim/init.lua"
alias ncom="nvim /Users/james/Documents/dottofiles/nvim/KEYMAPS.md"
alias aeroConf="nvim ~/Documents/dottofiles/aerospace.toml"
alias op1='code -n /Users/jamesjames/Documents/work/projects/blor-fe'
alias op2='code -n /Users/jamesjames/Documents/work/projects/old-blor/blor-fe'
alias op='op1 && op2'
alias cl="claude"
alias cx="codex"
alias ima="/Users/jrprecilla/Documents/work/projects/control/ima"
# Gemini CLI: Daily Note
alias dn='/Users/james/Library/CloudStorage/GoogleDrive-jrjrjrpr365@gmail.com/My\ Drive/DriveSyncFiles/kaizen/Config/dn.sh'

# ============================================================
# Media & downloads
# ============================================================
alias yt='yt-dlp'
alias ytm='yt-dlp -x'
alias ytmm='yt-dlp -f "bestaudio"'
alias mu="mpv --no-video"
alias vi="mpv --loop --fs"     # NB: shadows vi the editor
alias vlc='open -a VLC'
alias makete="audio && mu 'funk universo x ragna crimson (makete kate) [M2VSd6gEO54].m4a'"
alias stark="video && mpv --fullscreen stark.mp4"

# ============================================================
# Audio & bluetooth
# ============================================================
alias blip="blueutil --paired"
alias blco="blueutil --connect"
alias switch="SwitchAudioSource -t output -s"
alias switchMic="SwitchAudioSource -t input -s"
alias ausource="SwitchAudioSource -a"
alias alexa="blco 08-12-a5-91-ef-cd && switch 'Echo Dot-43W'"
alias aumac="switch 'MacBook Air Speakers'"
alias hyper="switch 'HyperX QuadCast S'"
alias micmac="switch 'MacBook Air Microphone'"

# ============================================================
# Open URLs & remotes
# ============================================================
alias ohost="open https://unistack-dev.unidata.it"
alias ohostad="open https://unistack-dev.unidata.it/admin/"
alias edit='open "https://unistack-dev.unidata.it/admin/?cmd=theme_config&action=config&id=1"'
alias omyfe="open https://git.uniot.eu/ottimis/myunidata-fe"
alias omybe="open https://git.uniot.eu/ottimis/myunidata-be"
alias obblor="open https://github.com/ottimis/Blorcompany.com"
alias oblor="open https://github.com/ottimis/blor-fe"
alias orev="open https://github.com/ottimis/B-Revolution"
alias oportb="open https://docker.blorcompany.com/#!/2/docker/containers"
alias oportu="open https://portainer.unidata.it/#!/home"
alias oporto="open http://test-01.otm.ai:9000/#!/1/docker/containers"
alias oclick="open https://app.clickup.com/2462893/time"
alias odeep="open https://chat.deepseek.com/"
alias nb='open -a "Firefox Developer Edition" "https://new.blorcompany.com?token=pippo"'
alias hostbillconnect="ssh hostbill@83.217.190.28"

# ============================================================
# Personal apps & misc
# ============================================================
alias navicat='~/Documents/dottofiles/navicat-premium-reset-trial/reset-trial.sh'
alias fool='cd && cd Desktop/fool/native/ && .build/release/FoolApp'
alias key="cd ~/Documents/withoutMouse && .build/release/WhiteWindow"
alias ww='/Users/james/Documents/withoutMouse/.build/release/WhiteWindow & disown'
alias killww='pkill WhiteWindow'
alias rblor="wk && cd reminders && cat blor.txt"
alias pass='dc && cd work && n pwd.json'
alias pwds="n /Users/james/Documents/greyrat-vault/pwds"
alias secret='say nandodemo'

# ============================================================
# Functions (defined after the aliases they use)
# ============================================================

# Android: connect adb over wifi — connect_android <port>
connect_android() {
  adb_dir && adb connect 192.168.0.50:${1}
}

# Start Docker daemon if needed, then the Zeus stack
function start_zeus() {
  if ! docker info > /dev/null 2>&1; then
    echo "🚀 Avvio del Docker daemon..."
    open --background -a Docker # per macOS
  fi

  echo "⏳ Attendo che Docker sia pronto..."
  while ! docker info > /dev/null 2>&1; do
    sleep 1
  done
  echo "✅ Docker è pronto!"

  echo "📦 Avvio container Docker..."
  docker start zeus-be-web-1

  echo "🌐 Avvio frontend Angular..."
  zeus_fe && ns
}

# Download a song into ~/songs — dwm <url>
function dwm () {
	cd;
	cd songs;
	ytmm "$1"
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


# ============================================================
# Boomi API daily quiz gate (first interactive terminal of the day)
# — keep last so it runs after everything is set up
# ============================================================
alias boomi-quiz="python3 /Users/james/.boomi-quiz/app/boomi_quiz.py"
if [[ -o interactive ]] && [ -t 0 ]; then
  python3 /Users/james/.boomi-quiz/app/boomi_quiz.py --gate
fi
