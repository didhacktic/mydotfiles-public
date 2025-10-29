#!/usr/bin/env bash

# Récupère le volume (0–150 %) et l’état muet
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo 1 || echo 0)

if [[ $muted -eq 1 ]]; then
    notify-send -h string:x-canonical-private-synchronous:volume \
        -u low -i audio-volume-muted-symbolic \
        "Volume" "<i>Muet</i>"
    exit 0
fi

# Limite le volume à 150 %
(( volume > 150 )) && volume=150

segments=20
filled=$(( volume * segments / 150 ))
marker_index=$(( segments * 100 / 150 ))  # position du repère 100 %

bar="<span font='monospace'>"

for ((i=0; i<segments; i++)); do
    if (( i == marker_index )); then
        bar+="<span color='#aaaaaa'>|</span>"
    fi

    if (( i < filled )); then
        if (( i < marker_index )); then
            bar+="<span color='#ffffff'>█</span>"  # blanc jusqu’à 100 %
        else
            bar+="<span color='#cc0000'>█</span>"  # rouge au-delà
        fi
    else
        bar+="░"
    fi
done

bar+="</span>"

# Sélection de l’icône selon le niveau (icônes système)
if (( volume == 0 )); then
    icon="audio-volume-muted-symbolic"
elif (( volume < 33 )); then
    icon="audio-volume-low-symbolic"
elif (( volume < 66 )); then
    icon="audio-volume-medium-symbolic"
else
    icon="audio-volume-high-symbolic"
fi

# Notification : icône sur la même ligne que la barre + % à la fin
notify-send -h string:x-canonical-private-synchronous:volume \
    -u low -i "$icon" \
    "Volume" "<span font='monospace'>${bar}  <b>${volume}%</b></span>"
