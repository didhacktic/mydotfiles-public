#!/bin/bash
# move_active_to_next_workspace.sh

current_ws=$(hyprctl activeworkspace -j | jq '.id')
next_ws=$((current_ws + 1))

hyprctl dispatch movetoworkspace "$next_ws"
