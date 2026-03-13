HISTSIZE=100000
SAVEHIST=100000


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export NVM_DIR="$HOME/.nvm"
export AWS_PROFILE="jp"
export EDITOR="nvim"


# nvm is loaded below on line 231-232
# source $(brew --prefix nvm)/nvm.sh

#zsh
alias rzsh="source ~/.zshrc"

#tmux
alias tms="tmux new-session -s"
alias tuni="tmux attach -t my-uni"
alias ttl="tmux attach -t logs"
alias tbl="tmux attach -t blor"

alias ..="cd .."
alias navicat='cd ~/Downloads && ./nc-reset.sh'
alias h='cd ~' #goes to the root folder
alias aeroConf= "h && cd .. && nvim .aerospace.toml"
alias c='clear' #clears the terminal
alias e='cd'
alias nv='code -n' #creates a new coding window
alias md='mkdir' #makes a folder or directory
alias rd='rmdir' #removes folder/directory
alias sl='pmset sleepnow' #sets the mac to sleep
alias fs='du -sh' #shows the folder size
alias cs='du -sh*' #shows the size of each file inside a folder
alias e='cd' #goes back to the previous folder/directory you were in
alias t='touch'
alias shine='sudo shutdown -h now'
alias secret='say nandodemo'
alias hello='say -v Kyoko "何度でも何度でも叫ぶこの暗い夜の怪獣になってもここに残しておきたいんだよこの秘密をだんだん食べる赤と青の星々未来から過去順々に食べる何十回も噛み潰し溶けたなら飲もう淡々と知る知ればまた溢れ落ちる昨日までの本当順々と知る何十螺旋の知恵の輪解けるまで行こう丘の上で星を見ると感じるこの寂しさも朝焼けで手が染まる頃にはもう忘れてるんだこの世界は好都合に未完成だから知りたいんだでも怪獣みたいに遠く遠く叫んでもまた消えてしまうんだだからきっと何度でも見るこの暗い夜の空を何千回も君に話しておきたいんだよこの知識を淡々と散る散ればまた次の実花びらは過去単純に生きる懐柔された土と木ひそひそと咲こう点と線の延長線上を辿るこの淋しさも暗がりで目が慣れる頃にはもう忘れてるんだこの世界は好都合に未完成僕は知りたいんだだから怪獣みたいに遠くへ遠くへ叫んでただ消えていくんだでもこの未来は好都合に光ってるだから進むんだ今何光年も遠く 遠く 遠く叫んでまた怪獣になるんだ"'
alias de="cd ~/Documents/desktop"
alias dc="cd ~/Documents"
alias dw="cd ~/Downloads"
alias jt="cd ~/Desktop/just-try"
alias wk="cd ~/Documents/work"
alias tl="dc && cd .traveler_logs"
alias pj="wk && cd projects"

alias gop="cd && cd Documents/work/pwd"
alias p="gop && node script.js"
alias pwds="gop && n login-data.json"

alias play="dc && cd work/playground"

alias hostbill="wk && cd hostbill"
alias ohost="open https://unistack-dev.unidata.it";
alias ohostad="open https://unistack-dev.unidata.it/admin/";


alias cnvim="h && nvim .config/nvim/init.lua"
alias n='nvim'
alias zsh='h && nvim .zshrc'

alias gp="dc && cd tests && node logHello.js"
alias time="date +'%T'"
alias day='date "+%a %b %d"'


alias op1='code -n /Users/jamesjames/Documents/work/projects/blor-fe' 
alias op2='code -n /Users/jamesjames/Documents/work/projects/old-blor/blor-fe' 

alias ike='pnpm run dev'
alias bd='pnpm build'
alias ikoze='pnpm start'

alias blorapp="pj && cd blor_app && cd BlorApp"
alias bblor="pj && cd Blor/Blorcompany.com"
alias blor="pj && cd Blor/blor-fe"
alias Blor="pj && cd old-blor && cd blor-fe"
alias blorev="pj && cd Blor/B-Revolution"


alias myfee="pj && cd my-unidata-2"
alias mybee="pj && cd myunidata-be"
alias myfe="pj && cd unidata/test/myunidata-fe"
alias mybe="pj && cd unidata/myunidata-be"

alias mpb="pj && cd unidata/my-uni-pass/myuni-pass-be"
alias mpf="pj && cd unidata/my-uni-pass/myuni-pass-fe"

alias nyan="blor && ike"
alias goo="Blor && npm run start"
#alias go="npm run start"

alias doc='sigma && docker run -p 3000:3000 blor-fe'
alias dcu="docker compose up"
alias dcublor="docker compose up blor-fe mysql backend redis"
alias dcublorev="docker compose up b-revolution mysql backend redis"

alias testing="de && cd test"

alias pretty="npx prettier --write ."

alias op='op1 && op2'
alias vlc='op -a VLC'
alias yt='yt-dlp'
alias ytm='yt-dlp -x'
alias ytmm='yt-dlp -f "bestaudio"'
alias pi='pnpm i'
alias fuse='dc && cd useful'
alias fvim='fuse && cd vim'
alias fmov="dc && cd movies"
alias fmus="dc && cd music"
alias mu="mpv --no-video"
alias vi="mpv --loop --fs"
alias bi="brew install"
alias nb='open -a "Firefox Developer Edition" "https://new.blorcompany.com?token=pippo"'


alias blip="blueutil --paired"
alias blco="blueutil --connect"
alias switch="SwitchAudioSource -t output -s"
alias switchMic="SwitchAudioSource -t input -s"
alias alexa="blco 08-12-a5-91-ef-cd && switch 'Echo Dot-43W'"
alias aumac="switch 'MacBook Air Speakers'"
alias hyper="switch 'HyperX QuadCast S'"
alias micmac="switch 'MacBook Air Microphone'"
alias ausource="SwitchAudioSource -a"

alias gfl="git log --follow"
alias gdl="git branch -d"
alias gad="git add ."
alias gcm="git commit -m "

alias gdiff="git diff --cached HEAD > diff.txt"

alias ghls="gh repo list"

alias gpl="git pull"
alias glg="git log"
alias gbr="git branch"
alias gsoft="git reset --soft HEAD~1"
alias ghard="git reset --hard HEAD~1"
alias gsoft="git reset --soft HEAD~1"
alias gmix="git reset --mixed HEAD~1"
alias gck="git checkout"
alias gmg="git merge"
alias gcl="git clone"
alias gst="git status"
alias grm="git remote -v"
alias gsh="git stash"
alias gsp="git stash pop"

alias pass='dc && cd work && n pwd.json'



# alias zeus_fe='cd /Users/dumitruzanogea/Documents/Progetti/Zeus/zeus2.0'
alias zeus_be='cd /Users/dumitruzanogea/Documents/Progetti/New-Zeus/zeus-be'
alias zeus_fe='cd /Users/dumitruzanogea/Documents/Progetti/New-Zeus/zeus-fe'
alias adb_dir='root && cd Library/Android/sdk/platform-tools'

alias start_zeus_old='root && docker start zeus20-php-web-1'
alias start_zeus_all='root && docker start zeus-be-web-1 && zeus_fe && ns'
alias open_docker='cd && open -a Docker Desktop'


alias launch_ng="root && open -a 'Firefox Developer Edition' 'www.localhost:4200'"
alias launch_ionic="root && open -a 'Firefox Developer Edition' 'www.localhost:8100'"

alias pull_branches='git remote update origin --prune'


alias media="dc && cd media"
alias video="media && cd video"
alias audio="media && cd audio"
alias image="media && cd image"
alias makete="audio && mu 'funk universo x ragna crimson (makete kate) [M2VSd6gEO54].m4a'"
alias stark="video && mpv --fullscreen stark.mp4"


alias omyfe="open https://git.uniot.eu/ottimis/myunidata-fe"
alias omybe="open https://git.uniot.eu/ottimis/myunidata-be"
alias obblor="open https://github.com/ottimis/Blorcompany.com"
alias oblor="open https://github.com/ottimis/blor-fe"
alias oblorb="open https://github.com/ottimis/Blorcompany.com"
alias orev="open https://github.com/ottimis/B-Revolution"
alias oportb="open https://docker.blorcompany.com/#!/2/docker/containers"
alias oportu="open https://portainer.unidata.it/#!/home"
alias oporto="open http://test-01.otm.ai:9000/#!/1/docker/containers"
alias oclick="open https://app.clickup.com/2462893/v/l/7-2462893-1"

alias odeep="open https://chat.deepseek.com/"
# Android
connect_android() {
  adb_dir && adb connect 192.168.0.50:${1} 
  }

# alias android_log_version='echo $(grep versionCode build.gradle) && echo $(grep versionName build.gradle)'
  # android_set_version(){
  #   android_log_version && sed -i '' "s/versionName \"[0-9]*.[0-9]*.[0-9]*\"/versionName \"$2\"/" build.gradle && android_log_version
  # }

  function start_zeus() {
  # 1. Start Docker daemon se non è attivo (solo su sistemi dove ha senso, come macOS o WSL)
  if ! docker info > /dev/null 2>&1; then
    echo "🚀 Avvio del Docker daemon..."
    open --background -a Docker # per macOS
  fi

  # 2. Aspetta che Docker sia pronto
  echo "⏳ Attendo che Docker sia pronto..."
  while ! docker info > /dev/null 2>&1; do
    sleep 1
  done
  echo "✅ Docker è pronto!"

  # 3. Avvia i container
  echo "📦 Avvio container Docker..."
  docker start zeus-be-web-1

  # 4. Avvia frontend Angular
  echo "🌐 Avvio frontend Angular..."
  zeus_fe && ns
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function dwm () {
	cd;
	cd songs;
	ytmm "$1"	
}

gps() {
    # First checklist item
    read "response1?Have you removed all the console.logs() and the var_dumps()? (y/n): "
    case $response1 in
        [Yy]*) ;;
        [Nn]*) echo "Push cancelled."; return 1 ;;
        *) echo "Invalid response. Push cancelled."; return 1 ;;
    esac

    # Second checklist item
    read "response2?Are you using the right endpoint? (y/n): "
    case $response2 in
        [Yy]*) ;;
        [Nn]*) echo "Push cancelled."; return 1 ;;
        *) echo "Invalid response. Push cancelled."; return 1 ;;
    esac

    # If both answers are yes, proceed with git push
    echo "✓ Checklist completed. Pushing to remote..."
    git push
}

alias hostbillconnect="ssh hostbill@83.217.190.28"
alias edit='open "https://unistack-dev.unidata.it/admin/?cmd=theme_config&action=config&id=1"'


# Added by Antigravity
export PATH="/Users/jrprecilla/.antigravity/antigravity/bin:$PATH"

alias rblor="wk && cd reminders && cat blor.txt"
alias fool='cd && cd Desktop/fool/native/ && .build/release/FoolApp'
alias key="cd && cd Desktop/withoutMouse &&  .build/release/WhiteWindow"


export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/jrprecilla/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Alias for ima tool
alias ima="/Users/jrprecilla/Documents/work/projects/control/ima"
HISTSIZE=1000000
SAVEHIST=1000000

# DeepSeek auth for gcom()
export DEEPSEEK_API_KEY='sk-bee16364619241abba98e0e8d8fe01f0'
# export DEEPSEEK_MODEL='deepseek-chat'

gcom() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "gcom: not inside a Git repository."
    return 1
  fi

  if git diff --cached --quiet; then
    echo "gcom: no staged changes. Stage files first with git add."
    return 1
  fi

  local ai_backend
  if [[ -n "$DEEPSEEK_API_KEY" ]]; then
    if ! command -v curl >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
      echo "gcom: curl and jq are required for DeepSeek mode."
      return 1
    fi
    ai_backend="deepseek"
  elif command -v codex >/dev/null 2>&1; then
    ai_backend="codex"
  else
    echo "gcom: no AI backend found. Set DEEPSEEK_API_KEY or install codex CLI."
    return 1
  fi

  local git_status diff diff_limit diff_excerpt prompt
  git_status="$(git status --short)"
  diff="$(git diff --cached --no-color)"
  diff_limit="${GCOM_DIFF_LIMIT:-14000}"
  diff_excerpt="$diff"
  if (( ${#diff_excerpt} > diff_limit )); then
    diff_excerpt="${diff_excerpt[1,diff_limit]}"
    diff_excerpt+=$'\n\n[Diff truncated due to size.]'
  fi

  prompt=$'You are a Git assistant. Generate exactly one shell command.\n'
  prompt+=$'Task: create a commit command for the currently staged changes.\n'
  prompt+=$'Constraints:\n'
  prompt+=$'- Output one line only.\n'
  prompt+=$'- Start exactly with: git commit\n'
  prompt+=$'- Include -m with a concise commit message (max 72 chars).\n'
  prompt+=$'- Use conventional commit style (feat, fix, chore, refactor, docs, test).\n'
  prompt+=$'- No markdown, no backticks, no explanation.\n\n'
  prompt+=$'Git status --short:\n'
  prompt+="$git_status"$'\n\n'
  prompt+=$'Staged diff:\n'
  prompt+="$diff_excerpt"$'\n'

  local response_file error_file raw_response suggestion
  response_file="$(mktemp /tmp/gcom-response.XXXXXX)"
  error_file="$(mktemp /tmp/gcom-error.XXXXXX)"

  if [[ "$ai_backend" == "deepseek" ]]; then
    local deepseek_model request_json api_response api_error
    deepseek_model="${GCOM_MODEL:-${DEEPSEEK_MODEL:-deepseek-chat}}"
    request_json="$(
      jq -n \
        --arg model "$deepseek_model" \
        --arg prompt "$prompt" \
        '{model: $model, messages: [{role: "user", content: $prompt}], stream: false}'
    )"
    if ! api_response="$(
      curl -sS --fail-with-body https://api.deepseek.com/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${DEEPSEEK_API_KEY}" \
        -d "$request_json" 2>"$error_file"
    )"; then
      echo "gcom: failed to get an AI suggestion from DeepSeek."
      sed -n '1,3p' "$error_file" | sed 's/^/gcom: /'
      rm -f "$response_file" "$error_file"
      return 1
    fi
    raw_response="$(print -r -- "$api_response" | jq -r '.choices[0].message.content // empty' 2>/dev/null)"
    if [[ -z "$raw_response" ]]; then
      api_error="$(print -r -- "$api_response" | jq -r '.error.message // empty' 2>/dev/null)"
      echo "gcom: DeepSeek returned an unexpected response."
      if [[ -n "$api_error" ]]; then
        echo "gcom: $api_error"
      fi
      rm -f "$response_file" "$error_file"
      return 1
    fi
  else
    local -a codex_cmd
    codex_cmd=(codex exec --sandbox read-only --skip-git-repo-check --output-last-message "$response_file")
    if [[ -n "$GCOM_MODEL" ]]; then
      codex_cmd+=(-m "$GCOM_MODEL")
    fi

    if ! print -r -- "$prompt" | "${codex_cmd[@]}" - >/dev/null 2>"$error_file"; then
      echo "gcom: failed to get an AI suggestion."
      if grep -qi "login" "$error_file"; then
        echo "gcom: run 'codex login' and try again."
      fi
      sed -n '1,3p' "$error_file" | sed 's/^/gcom: /'
      rm -f "$response_file" "$error_file"
      return 1
    fi
    raw_response="$(cat "$response_file")"
  fi
  suggestion="$(
    print -r -- "$raw_response" \
      | tr -d '\r' \
      | sed 's/^```[[:alnum:]_-]*$//; s/^```$//' \
      | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
      | awk '/^git commit([[:space:]]|$)/ { print; exit }'
  )"

  if [[ -z "$suggestion" ]]; then
    suggestion="$(
      print -r -- "$raw_response" \
        | tr -d '\r' \
        | sed -n 's/.*\(git commit[^`]*\).*/\1/p' \
        | sed -n '1p' \
        | sed 's/[[:space:]]*$//'
    )"
  fi

  rm -f "$response_file" "$error_file"

  if [[ -z "$suggestion" ]]; then
    echo "gcom: AI response did not include a valid git commit command."
    print -r -- "$raw_response" | sed -n '1,6p'
    return 1
  fi

  local action final_cmd revision_request revision_prompt
  while true; do
    echo "Proposed command:"
    echo "  $suggestion"
    read "action?Apply this command? [Y/e/n]: "
    case "${action:l}" in
      ""|y|yes)
        final_cmd="$suggestion"
        break
        ;;
      e|edit)
        read "revision_request?What should change in this commit command?: "
        if [[ -z "$revision_request" ]]; then
          echo "gcom: empty revision request. keeping current suggestion."
          continue
        fi

        revision_prompt="$prompt"$'\n'
        revision_prompt+=$'\nPrevious proposed command:\n'
        revision_prompt+="$suggestion"$'\n'
        revision_prompt+=$'\nUser revision request:\n'
        revision_prompt+="$revision_request"$'\n'
        revision_prompt+=$'\nReturn exactly one revised git commit command and nothing else.\n'

        local revision_response_file revision_error_file
        revision_response_file="$(mktemp /tmp/gcom-response.XXXXXX)"
        revision_error_file="$(mktemp /tmp/gcom-error.XXXXXX)"

        if [[ "$ai_backend" == "deepseek" ]]; then
          local deepseek_model request_json api_response api_error
          deepseek_model="${GCOM_MODEL:-${DEEPSEEK_MODEL:-deepseek-chat}}"
          request_json="$(
            jq -n \
              --arg model "$deepseek_model" \
              --arg prompt "$revision_prompt" \
              '{model: $model, messages: [{role: "user", content: $prompt}], stream: false}'
          )"
          if ! api_response="$(
            curl -sS --fail-with-body https://api.deepseek.com/chat/completions \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer ${DEEPSEEK_API_KEY}" \
              -d "$request_json" 2>"$revision_error_file"
          )"; then
            echo "gcom: failed to get a revised suggestion from DeepSeek."
            sed -n '1,3p' "$revision_error_file" | sed 's/^/gcom: /'
            rm -f "$revision_response_file" "$revision_error_file"
            return 1
          fi
          raw_response="$(print -r -- "$api_response" | jq -r '.choices[0].message.content // empty' 2>/dev/null)"
          if [[ -z "$raw_response" ]]; then
            api_error="$(print -r -- "$api_response" | jq -r '.error.message // empty' 2>/dev/null)"
            echo "gcom: DeepSeek returned an unexpected revision response."
            if [[ -n "$api_error" ]]; then
              echo "gcom: $api_error"
            fi
            rm -f "$revision_response_file" "$revision_error_file"
            return 1
          fi
        else
          local -a revision_codex_cmd
          revision_codex_cmd=(codex exec --sandbox read-only --skip-git-repo-check --output-last-message "$revision_response_file")
          if [[ -n "$GCOM_MODEL" ]]; then
            revision_codex_cmd+=(-m "$GCOM_MODEL")
          fi
          if ! print -r -- "$revision_prompt" | "${revision_codex_cmd[@]}" - >/dev/null 2>"$revision_error_file"; then
            echo "gcom: failed to get a revised AI suggestion."
            if grep -qi "login" "$revision_error_file"; then
              echo "gcom: run 'codex login' and try again."
            fi
            sed -n '1,3p' "$revision_error_file" | sed 's/^/gcom: /'
            rm -f "$revision_response_file" "$revision_error_file"
            return 1
          fi
          raw_response="$(cat "$revision_response_file")"
        fi

        suggestion="$(
          print -r -- "$raw_response" \
            | tr -d '\r' \
            | sed 's/^```[[:alnum:]_-]*$//; s/^```$//' \
            | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' \
            | awk '/^git commit([[:space:]]|$)/ { print; exit }'
        )"

        if [[ -z "$suggestion" ]]; then
          suggestion="$(
            print -r -- "$raw_response" \
              | tr -d '\r' \
              | sed -n 's/.*\(git commit[^`]*\).*/\1/p' \
              | sed -n '1p' \
              | sed 's/[[:space:]]*$//'
          )"
        fi

        rm -f "$revision_response_file" "$revision_error_file"

        if [[ -z "$suggestion" ]]; then
          echo "gcom: AI revision did not include a valid git commit command."
          print -r -- "$raw_response" | sed -n '1,6p'
          return 1
        fi
        ;;
      n|no)
        echo "gcom: cancelled."
        return 0
        ;;
      *)
        echo "gcom: invalid choice. use Y, e, or n."
        ;;
    esac
  done

  local -a cmd_parts
  cmd_parts=("${(z)final_cmd}")
  if (( ${#cmd_parts} < 2 )) || [[ "${cmd_parts[1]}" != "git" ]] || [[ "${cmd_parts[2]}" != "commit" ]]; then
    echo "gcom: only git commit commands are allowed."
    return 1
  fi

  echo "Running: $final_cmd"
  "${cmd_parts[@]}"
}


alias kaizen='cd "/Users/jrprecilla/Library/CloudStorage/GoogleDrive-jrjrjrpr365@gmail.com/My Drive/DriveSyncFiles/kaizen"'

alias bdev="pj && cd Blor/dev"
alias bprod="pj && cd Blor/prod"
alias bexp="pj && cd Blor/experimental"

# Added by Antigravity
export PATH="/Users/jrprecilla/.antigravity/antigravity/bin:$PATH"
