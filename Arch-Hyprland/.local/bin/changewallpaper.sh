#!/usr/bin/env bash

DIR="$HOME/Images/wallpapers"

# Lire les chemins complets des fichiers dans le tableau (sûr pour les espaces)
mapfile -d '' -t PICS < <(find "$DIR" -maxdepth 1 -type f -print0)

# Vérifier qu'on a au moins un fichier
if (( ${#PICS[@]} == 0 )); then
  echo "Aucun fichier trouvé dans '$DIR'." >&2
  exit 1
fi

# Choisir un index aléatoire proprement
idx=$(( RANDOM % ${#PICS[@]} ))
RANDOMPICS="${PICS[$idx]}"

# Si swaybg tourne, le tuer
if pidof swaybg >/dev/null; then
  pkill swaybg
fi

# Démarrer/assurer swww-daemon
swww query || swww-daemon

# change-wallpaper using swww — RANDOMPICS est déjà le chemin complet
swww img "$RANDOMPICS" --transition-fps 30 --transition-type any --transition-duration 3
