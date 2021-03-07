#!/usr/bin/env bash

time_to_wait=5

cleanup () {
  sleep $time_to_wait
  eww close notification &> /dev/null
}

while read -r line
do
  title=$(echo "$line" | jq -r ".summary")
  body=$(echo "$line" | jq -r ".body")
  icon=$(echo "$line" | jq -r ".app_icon")
  
  # Fallback Icon
  if [[ -z "$icon" ]]
  then
    icon="$HOME/Documents/Scripts/Resources/notification.svg"
  else
    icon=$("$HOME/Documents/Scripts/Resources/lookup-icon-gtk" "$icon")
  fi

  # Log
  echo -e "\u001b[34m\u001b[1m[NOTIFICATION]\u001b[0m $icon::$title - $body"
  
  # UPDATE EWW VARS:
  eww update notification-icon="$icon" notification-title="$title" notification-body="$body" &> /dev/null

  # OPEN EWW WINDOW
  eww open notification &> /dev/null

  # Cleanup
  cleanup &
done < "/dev/stdin"
