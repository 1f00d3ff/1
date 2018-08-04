#!/bin/bash

./update.sh

declare -a dependencies=("apt-transport-https" "build-essential" "dnsutils" "espeak" "gnupg-agent" "gnupg2" "haveged" "htop" "imagemagick" "irssi" "jq" "knockd" "kpcli" "libccid" "libevent-dev" "libksba8" "libpth20" "libssl-dev" "nmap" "ntp" "oathtool" "opensc" "openssl" "openvpn" "paperkey" "pass" "pcscd" "pinentry-curses" "rhash" "scdaemon" "screen" "shellcheck" "transmission-cli" "tmux" "vim" "w3m" "wget" "whois" "wikipedia2text")

for i in "${dependencies[@]}"
do
  if ! dpkg -l "$i" > /dev/null; then
		sudo apt-get install "$i" -y
  fi
done


declare -a dotfiles=("bashrc"\
"curlrc"\
"inputrc"\
"tmux.conf"\
"vimrc")

if [ -d ~/0/ ]; then
  for i in "${dotfiles[@]}"; do
    if [ ! -L ~/."$i" ]; then
      echo creating "$i" symlink
      ln -s ~/0/."$i" ~/."$i"
    else
      echo ".${i} already exists"
    fi  
  done
else
  echo "missing ~/0/"
fi


if [ "$(grep -c 'source ~/.bash_git' ~/.bashrc)" == 0 ]; then
	curl -sL https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
	sed -i '1isource ~/.bash_git' ~/.bashrc
fi
