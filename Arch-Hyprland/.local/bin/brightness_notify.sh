#!/usr/bin/env bash

# Récupère la luminosité actuelle en %
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$(( 100 * brightness / max_brightness ))

# Barre de progression HTML (20 segments)
filled=$(( percent / 5 ))
bar="<span font='monospace'>"
for ((i=0; i<20; i++)); do
    if (( i < filled )); then
        bar+="█"
    else
        bar+="░"
    fi
done
bar+="</span>"

# Notification
notify-send -h string:x-canonical-private-synchronous:brightness \
    -u low -i display-brightness-symbolic \
    "Luminosité" "<span font='monospace'>${bar}  <b>${percent}%</b></span>"
