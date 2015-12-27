#!/bin/bash

declare -a dependencies=("awesome" "xclip" "parcellite" "rxvt-unicode-256color")

for i in "${dependencies[@]}"
do
  if ! dpkg -l $i > /dev/null
  then
  sudo apt-get install $i -y
  fi
done;

rm -f /usr/share/awesome/themes/default/theme.lua
sudo ln -s ~/0/theme.lua /usr/share/awesome/themes/default/theme.lua

mkdir -p ~/.config/awesome
sudo ln -s ~/0/rc.lua ~/.config/awesome/rc.lua
