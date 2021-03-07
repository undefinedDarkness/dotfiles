#!/bin/bash

SHUTDOWN_ICON="$HOME/.icons/la-capitaine-icon-theme/actions/22x22-dark/system-shutdown.svg"
#SHUTDOWN_ICON="system-shutdown"
REBOOT_ICON="$HOME/.icons/la-capitaine-icon-theme/actions/22x22-dark/system-reboot.svg"
#REBOOT_ICON="system-reboot"
# SUSPEND_ICON="$HOME/.icons/la-capitaine-icon-theme/actions/22x22-dark/system-suspend.svg"
LOGOUT_ICON="$HOME/.icons/la-capitaine-icon-theme/actions/22x22-dark/system-log-out.svg"
#LOGOUT_ICON="system-log-out"
# Main

# Add Suspend To Menu: Suspend\0icon\x1f$SUSPEND_ICON\n
user_input=$(echo -en "Shutdown\0icon\x1f$SHUTDOWN_ICON\nReboot\0icon\x1f$REBOOT_ICON\nLogout\0icon\x1f$LOGOUT_ICON\n" | rofi -dmenu -theme powermenu)

case $user_input in

  "Shutdown")
    systemctl poweroff
    ;;
  
  "Reboot")
    systemctl reboot
    ;;

  "Suspend")
    systemctl suspend
    ;;

  "Logout")
    xfce4-session-logout --logout
    ;;

  *)
    echo "User Quit Script"
    ;;
esac
