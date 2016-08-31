#!/bin/bash

declare -a dependencies=("awesome" "xclip" "parcellite" "rxvt-unicode-256color")

for i in "${dependencies[@]}"
do
  if ! type -p "$i" > /dev/null
  then
  sudo apt-get install "$i" -y
  fi
done;

if [ ! -L /usr/share/awesome/themes/default/theme.lua ]; then
  echo '/usr/share/awesome/themes/default/theme.lua is not a symlink. creating theme.lua symlink'
  sudo mv /usr/share/awesome/themes/default/theme.{lua,old}
  sudo ln -s ~/0/theme.lua /usr/share/awesome/themes/default/theme.lua
else
  echo 'theme.lua - check'
fi

if [ ! -d ~/.config/awesome/ ]; then
  echo 'creating ~/.config/awesome directory'
  mkdir -p ~/.config/awesome
else
  echo 'awesome dir - check'
fi

XDG_RC_LUA=$(sha256sum /etc/xdg/awesome/rc.lua | awk '{print $1}')
GIT_RC_LUA=$(sha256sum ~/0/rc.orig | awk '{print $1}')

if [[ ${XDG_RC_LUA} == ${GIT_RC_LUA} ]]; then
  if [ ! -L ~/.config/awesome/rc.lua ]; then
    echo 'creating rc.lua symlink'
    #sudo ln -s ~/0/rc.lua ~/.config/awesome/rc.lua
  else
    echo 'rc.lua symlink already exists'
  fi  
else
  echo 'rc.lua has been updated; copying /etc/xdg/awesome/rc.lua to ~/0/rc.new'
  sudo cp /etc/xdg/awesome/rc.lua ~/0/rc.new
  BLANKLINE=$(grep -En '(^$)' /etc/xdg/awesome/rc.lua | head -n 1 | sed 's/://')
  echo "injecting parcellite into rc.lua at line $BLANKLINE"
  sudo cp /etc/xdg/awesome/rc.lua ~/.config/awesome/rc.lua
  sed -i "${BLANKLINE}iawful.util.spawn_with_shell(parcellite &)" ~/.config/awesome/rc.lua
	sed -i "${BLANKLINE}iawful.util.spawn_with_shell(syndaemon -i 0.250 -K -R &)" ~/.config/awesome/rc.lua
  sed -i 's/parcellite &/"parcellite &"/g' ~/.config/awesome/rc.lua
  sed -i 's/syndaemon -i 0.250 -K -R &/"syndaemon -i 0.250 -K -R &"/g' ~/.config/awesome/rc.lua
fi

sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt

if [ ! -L ~/.Xresources ]; then
	echo 'creating ~/.Xresources symlink and xrdb merging'
	sudo ln -s ~/0/.Xresources ~/.Xresources
	xrdb -merge ~/.Xresources
fi
