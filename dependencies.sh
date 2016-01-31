#!/bin/bash

./update.sh

declare -a dependencies=("build-essential" "dnsutils" "espeak" "gnupg" "htop" "irssi" "jq" "knockd" "kpcli" "libterm-readline-gnu-perl" "ntp" "oathtool" "openssl" "openvpn" "rhash" "screen" "tesseract-ocr" "tesseract-ocr-eng" "tmux" "vim" "w3m" "wget" "whois" "wikipedia2text")

for i in "${dependencies[@]}"
do
  if ! dpkg -l $i > /dev/null; then
		sudo apt-get install $i -y
  fi
done


declare -a dotfiles=("bashrc" "curlrc" "inputrc" "tmux.conf" "vimrc")

if [ -d ~/0/ ]; then
  for i in "${dotfiles[@]}"; do
    if [ ! -L ~/.$i ]; then
      echo "creating $i symlink"
      ln -s ~/0/.$i ~/.$i
    else
      echo ".${i} already exists"
    fi  
  done
else
  echo "missing ~/0/"
fi


if [ $(grep -c 'source ~/.bash_git' ~/.bashrc) == 0 ]; then
	curl -sL https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > ~/.bash_git
	sed -i '1isource ~/.bash_git' ~/.bashrc
fi
