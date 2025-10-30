#!/bin/bash
# ~/.config/hypr/scripts/move_all_to_next_workspace.sh
# Déplace toutes les fenêtres du workspace actif vers le suivant.

# Récupère l'ID du workspace actif
current_ws=$(hyprctl activeworkspace -j | jq '.id')
next_ws=$((current_ws - 1))

# Liste les fenêtres du workspace courant
windows=$(hyprctl clients -j | jq --argjson ws "$current_ws" '.[] | select(.workspace.id == $ws) | .address' | tr -d '"')

# Boucle sur chaque fenêtre et la déplace
for win in $windows; do
  hyprctl dispatch movetoworkspacesilent "$next_ws,address:$win"
done

# Optionnel : déplacer aussi ton focus sur le nouveau workspace
# (retire cette ligne si tu veux rester sur le workspace actuel)
hyprctl dispatch workspace "$next_ws"
