#!/bin/bash
set -u

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

log() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S %z')" "$*"
}

if pgrep -x 'Navicat Premium' >/dev/null; then
    log 'Skipped: Navicat Premium is open.'
    exit 0
fi

script="$HOME/Documents/dottofiles/navicat-premium-reset-trial/reset-trial.sh"
if [ ! -f "$script" ]; then
    log "Failed: script missing at $script"
    exit 1
fi

log 'Starting scheduled Navicat script.'
# EOF also prevents the original script from closing Navicat if it opens
# between the process check above and the original script's own check.
/bin/bash "$script" </dev/null
status=$?
log "Script finished with exit status $status."
exit "$status"
