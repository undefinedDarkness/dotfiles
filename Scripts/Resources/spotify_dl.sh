#!/usr/bin/env bash

video_file_format="$HOME/Videos/%(title)s.%(uploader)s.%(ext)s"
video_format="bestvideo[height<=720]+bestaudio/best[height<=720]"

audio_file_format="$HOME/Music/%(title)s.%(ext)s"

spotify_title=$(playerctl -p spotify metadata xesam:title 2> /dev/null)

# Check for empty.
if [ "$spotify_title" = "" ]
then
  ff_title=$(playerctl -p firefox metadata xesam:title 2> /dev/null)
  if [ "$ff_title" = "" ]
  then
    echo "$(tput setaf 1)Nothing to download."
    exit 0
  else
    ff_icon=$(playerctl -p firefox metadata mpris:artUrl)
    echo "$(tput setaf 4)Downloading Youtube Video: $(tput setaf 2)\"$ff_title\""
    #echo "youtube-dl \"ytsearch:$ff_title\" --output=\"$video_format\" --quiet"
    
    youtube-dl -f "$video_format" "ytsearch:$ff_title" --output "$video_file_format" --quiet
    
    notify-send "Finished downloading." "$ff_title" --icon="$ff_icon"
  fi
else
  echo "$(tput setaf 4)Downloading Spotify Song From Youtube $(tput setaf 2)\"$spotify_title\""
  youtube-dl "ytsearch:$spotify_title" --output "$audio_file_format" --extract-audio --audio-format mp3
  notify-send "Finished downloading." "$spotify_title" --icon="$(../target/release/settings_menu --get-song-image)"
fi
