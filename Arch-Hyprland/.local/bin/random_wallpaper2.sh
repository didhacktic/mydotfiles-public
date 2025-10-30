#!/usr/bin/env bash
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval, with a random transition each time.

DEFAULT_INTERVAL=300 # seconds

if [ $# -lt 1 ] || [ ! -d "$1" ]; then
  printf "Usage:\n\t\e[1m%s\e[0m \e[4mDIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$0"
  printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified).\n" "$DEFAULT_INTERVAL"
  exit 1
fi

DIR="$1"
INTERVAL="${2:-$DEFAULT_INTERVAL}"

# Mode d'affichage : crop = plein écran sans déformation
RESIZE_TYPE="crop"
export SWWW_TRANSITION_FPS="${SWWW_TRANSITION_FPS:-60}"
export SWWW_TRANSITION_STEP="${SWWW_TRANSITION_STEP:-2}"

# Liste de transitions disponibles
TRANSITIONS=(
  "left"
  "right"
  "top"
  "bottom"  
  "wipe"
  "grow"
  "outer"
  "center"
  "simple"
  "fade"
  "wave"
)

# Assure que swww-daemon tourne
swww query >/dev/null 2>&1 || swww-daemon

while true; do
  # Crée une liste pseudo-aléatoire des images (comme ton script d'origine)
  find "$DIR" -type f | while read -r img; do
    echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
  done \
  | sort -n | cut -d':' -f2- \
  | while read -r img; do
      # Transition aléatoire à chaque image
      trans="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"

      echo "→ $(basename "$img") | transition: $trans"

      swww img --resize="$RESIZE_TYPE" "$img" \
        --transition-type "$trans" \
        --transition-fps "$SWWW_TRANSITION_FPS" \
        --transition-duration 3

      sleep "$INTERVAL"
    done
done

