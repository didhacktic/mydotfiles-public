#!/bin/sh

if [ "$DESKTOP_SESSION" = "ubuntu" ]; then 
   sleep 20s
   killall conky
   cd "$HOME/.conky/InfoPanel"
   conky -c "$HOME/.conky/InfoPanel/infopanelrcV" &
   exit 0
fi
