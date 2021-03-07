#!/usr/bin/env bash

log () {
  echo -e "$1 \u001b[34m\u001b[1m::\u001b[0m $2" 
}

# THIS SCRIPT IS RUN AT STARTUP

log "INIT" "🚀 Launch Script Active - $(date)"

# Start eww
eww kill 2> /dev/null
eww daemon 2> /dev/null
log "INIT" "🔧 Started eww."

# Notification
killall -q xfce4-notifyd
killall -q tiramisu
tiramisu -j | bash "$HOME/Documents/Scripts/eww_tiramisu.sh" &
log "INIT" "🍮 Started Tiramisu"

# Kill xfce4-panel
killall -q xfce4-panel
stalonetray --slot-size 30 -i 16 -bg "#1e2132" --window-layer bottom 2> /dev/null &
eww open bar

# Open eww bar
log "INIT" "🍷 Started Stalonetray"
log "INIT" "🌠 Finished all my work!"
