#!/bin/bash
echo "Backup gnome-shell.css...(1/2)"
sudo cp /usr/share/gnome-shell/theme/Flat-Remix-Blue/gnome-shell.css /usr/share/gnome-shell/theme/Flat-Remix-Blue/gnome-shell.css.bak
echo "Replace gnome-shell.css...(2/2)"
sudo cp -f gnome-shell-3.38.1.css /usr/share/gnome-shell/theme/Flat-Remix-Blue/gnome-shell.css
echo "Replace finish!"