#!/usr/bin/env bash

# I mis-spell too often
not_player="No players found"

get_id () {
  uuidgen
}

get () {
  playerctl metadata "$1" 2>&1
}

get_art () {
  local playerctl_out
  playerctl_out=$(get mpris:artUrl)
  
  if [ "$playerctl_out" == "$not_player" ]
  then
    # Nothing Playing
    echo "$HOME/Documents/Scripts/Resources/icons8-music-record-100.png"
  elif [[ "$playerctl_out" =~ http|https ]]
  then
    # Spotify / Web Based Image
    local image_file
    image_file="/tmp/$(get_id).jpg"
    
    curl "${playerctl_out/open.spotify.com/i.scdn.co}" --output "$image_file" --silent
    echo "$image_file"
  else
    # Local File
    echo "${playerctl_out/file:\/\//}"
  fi
}

case "$1" in
  # Title
  "title")
    x=$(get xesam:title)
    if [ "$x" == "$not_player" ]
    then
      echo "Nothing Playing."
    else
      echo "$x"
    fi
  ;;

  # Song Status Icon
  "status-icon")
    x=$(playerctl status 2>&1)
    case "$x" in
      "Playing" | "$not_player")
        echo ""
        ;;
      "Paused")
        echo " "
        ;;
    esac
  ;;

  # Music Art
  "art")
    get_art
  ;;

  # Get any generic property
  *)
    get "$1" || echo -e "\u001b[31m\u001b[1mERROR:\u001b[0m Nothing found" 
  ;;
esac

