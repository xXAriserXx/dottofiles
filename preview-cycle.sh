#!/bin/zsh -f
# Focus the next/previous Preview window on the current AeroSpace workspace.
# Usage: preview-cycle.sh next|prev   (bound to ; and j in Preview by karabiner)
# The focused window is then resized to fill the screen.
aero=/opt/homebrew/bin/aerospace
ids=($($aero list-windows --workspace focused --app-bundle-id com.apple.Preview --format '%{window-id}' | sort -n))
(( ${#ids} > 1 )) || exit 0
cur=$($aero list-windows --focused --format '%{window-id}')
i=${ids[(ie)$cur]}                       # 1-based index, > count if not found
(( i > ${#ids} )) && i=1
if [[ $1 == prev ]]; then (( i = i == 1 ? ${#ids} : i - 1 )); else (( i = i % ${#ids} + 1 )); fi
$aero focus --window-id ${ids[$i]}
${0:A:h}/aerospace-fullwidth.js Preview full   # fill the screen with the newly focused window
