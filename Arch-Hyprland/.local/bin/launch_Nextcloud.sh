#!/bin/bash

TIMEOUT=120
SLEEP_INTERVAL=2
SECONDS_WAITED=0

notify-send "Hyprland" "En attente de KeePassXC..."

# Attendre que KeePassXC soit lancé
while ! pgrep -x keepassxc >/dev/null; do
    sleep $SLEEP_INTERVAL
    ((SECONDS_WAITED+=SLEEP_INTERVAL))
    if [ $SECONDS_WAITED -ge $TIMEOUT ]; then
        notify-send "Hyprland" "KeePassXC non démarré dans le délai imparti."
        exit 1
    fi
done

notify-send "Hyprland" "KeePassXC détecté — en attente du déverrouillage de la base..."

# Réinitialiser le compteur pour le déverrouillage
SECONDS_WAITED=0

# Attendre que la base soit déverrouillée (service org.freedesktop.secrets actif)
while ! busctl --user list | grep -q "org.freedesktop.secrets.*keepassxc"; do
    sleep $SLEEP_INTERVAL
    ((SECONDS_WAITED+=SLEEP_INTERVAL))
    if [ $SECONDS_WAITED -ge $TIMEOUT ]; then
        notify-send "Hyprland" "Base KeePassXC non déverrouillée dans le délai imparti."
        exit 1
    fi
done

# Lancer Nextcloud
notify-send "Hyprland" "Base KeePassXC déverrouillée — lancement de Nextcloud..."
nextcloud & disown
