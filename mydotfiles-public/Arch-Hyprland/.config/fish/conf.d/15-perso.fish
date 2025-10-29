#############
# Mes alias #
#############

# --- MISE À JOUR ---
alias maj='sudo pacman -Syu --noconfirm && yay -Sua --noconfirm'				# Mise à jour complète du système (dépot + AUR)
alias upgrade='sudo pacman -Syu --noconfclirm'							# Mise à jour des paquets du dépot officiel
alias upgrade_aur='yay -Sua --noconfirm'							# Mise à jour des paquets AUR

# --- INSTALLATION / SUPPRESSION ---
alias install='yay -S --needed'									# Installer un paquet (dépot + AUR)
alias remove='yay -R'										# Désinstaller un paquet
alias remove_purge='yay -Rns'               							# Désinstaller un paquet + dépendances + configs

# --- NETTOYAGE ---
alias clean_all='yay -Scc --noconfirm && yay -Rns (yay -Qdtq) --noconfirm'			# Vider le cache et désinstaller les orphelins
alias clean='yay -Sc'										# Vider le cache des anciennes versions
alias purge='yay -Scc'										# Vider le cache de tous les paquets
alias orphans='yay -Qdt'									# Lister les paquets orphelins
alias autoremove='yay -Rns (yay -Qdtq)'								# Désinstaller les paquets orphelins

# --- INFO / RECHERCHE ---
alias search='yay -Ss'										# Rechercher un paquet (dépot + AUR)	
alias info='yay -Si'										# Infos sur un paquet meme non installé
alias info_local='yay -Qi'              							# Infos sur un paquet installé
alias dependances='pactree'									# Lister les dépendances d'un paquet
alias files='pacman -Ql'        								# lister les fichiers d’un paquet installé
alias owns='pacman -Qo'         								# identifie le paquet propriétaire d’un fichier
alias list_aur='yay -Qm'              								# Lister les paquets AUR installés
alias repo-list='yay -Qn'             								# Lister les paquets officiels

# Désactiver la suggestion de commande
set -g fish_autosuggestion_enabled 0

