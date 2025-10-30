#!/usr/bin/env bash
# Script d’installation automatisée Ubuntu — PPA + dépôts externes + paquets
# Auteur : didhacktic
# Usage : sudo bash install-packages-ubuntu.sh

set -e  # Stoppe le script en cas d’erreur
set -o pipefail

echo "=== 🔧 Mise à jour de la liste des paquets ==="
sudo apt update -y

echo "=== ➕ Ajout des PPAs ==="
PPAS=(
  "ppa:deluge-team/stable"
  "ppa:nextcloud-devs/client"
  "ppa:pbek/qownnotes"
  "ppa:vincent-vandevyvre/vvv"
  "ppa:phoerious/keepassxc"
  "ppa:mozillateam/ppa"
  "ppa:solaar-unifying/stable"
)

for ppa in "${PPAS[@]}"; do
  echo "Ajout du dépôt : $ppa"
  sudo add-apt-repository -y "$ppa"
done

echo "=== 🔄 Mise à jour après ajout des dépôts ==="
sudo apt update -y

echo "=== 🦊 Configuration : désactivation du Firefox Snap ==="
sudo tee /etc/apt/preferences.d/firefox-no-snap >/dev/null <<'EOF'
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1

Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 200
EOF

echo "=== 🌐 Ajout des dépôts externes ==="

# --- Google Chrome ---
echo "[Chrome] Ajout du dépôt..."
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-linux-signing-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-signing-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# --- Teamviewer ---
echo "[Teamviewer] Ajout du dépôt..."
curl -fsSL https://linux.teamviewer.com/pubkey/currentkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/teamviewer-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/teamviewer-keyring.gpg] https://linux.teamviewer.com/deb stable main" | sudo tee /etc/apt/sources.list.d/teamviewer.list

# --- Darktable ---
echo "[Darktable] Ajout du dépôt..."
curl -fsSL https://download.opensuse.org/repositories/graphics:darktable/xUbuntu_24.04/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/graphics_darktable.gpg
echo 'deb http://download.opensuse.org/repositories/graphics:/darktable/xUbuntu_24.04/ /' | sudo tee /etc/apt/sources.list.d/graphics:darktable.list

# --- Signal ---
echo "[Signal] Ajout du dépôt..."
curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list

# --- Steam ---
echo "[Steam] Ajout du dépôt..."
curl -fsSL https://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo gpg --dearmor -o /usr/share/keyrings/steam.gpg
echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/steam.gpg] https://repo.steampowered.com/steam/ stable steam" | sudo tee /etc/apt/sources.list.d/steam-stable.list

echo "=== 🔄 Mise à jour finale des dépôts ==="
sudo apt update -y

echo "=== 📦 Installation des paquets ==="
PACKAGES=(
  tilda synaptic gdebi vim ubuntu-restricted-extras dconf-editor undistract-me conky-all lm-sensors imagemagick gpicview vlc deluge audacity
  tuxguitar tuxguitar-jsa fluid-soundfont-gm tuxguitar-fluidsynth easytag filezilla xcfa liba52-0.7.4-dev faac cd-discid mp3check cdparanoia
  cuetools ppa-purge gparted musescore3 xbindkeys xautomation liferea autofs nfs-kernel-server samba cifs-utils solaar hwinfo libdvd-pkg
  darktable nextcloud-desktop nextcloud-desktop-cmd nautilus-nextcloud asunder inkscape qownnotes numlockx shutter icedax chrome-gnome-shell
  gnome-shell-extension-prefs gnome-tweaks gnome-shell-extension-manager net-tools bookletimposer pdfarranger keepassxc signal-desktop
  teamviewer steam-launcher input-remapper neofetch
)

sudo apt install -y "${PACKAGES[@]}" || true

echo "=== 🔍 Vérification des paquets installés ==="
NOT_FOUND=()
for pkg in "${PACKAGES[@]}"; do
  dpkg -s "$pkg" &>/dev/null || NOT_FOUND+=("$pkg")
done

if [ ${#NOT_FOUND[@]} -eq 0 ]; then
  echo "✅ Tous les paquets ont été installés avec succès !"
else
  echo "⚠️ Les paquets suivants n'ont pas pu être installés ou sont introuvables :"
  printf ' - %s\n' "${NOT_FOUND[@]}"
fi

echo "=== 🚀 Script terminé ==="


