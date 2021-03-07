#!/bin/bash

# Get Timestamp.
timestamp=$(date +%s)

# Check
if [ "$1" == "fullscreen" ] 
then
  maim "$HOME/Pictures/Screenshots/$timestamp.png" -q
else
  maim --select "$HOME/Pictures/Screenshots/$timestamp.png" -q
fi
notify-send "Screenshot Taken" "Screenshot saved to ~/Pictures/Screenshots/$timestamp.png" --icon=accessories-camera 
