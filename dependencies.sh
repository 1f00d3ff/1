#!/bin/bash

declare -a dependencies=("dnsutils" "gnupg" "htop" "irssi" "jq" "oathtool" "openssl" "screen" "tesseract-ocr" "tesseract-ocr-eng" "tmux" "vim" "w3m" "wget" "whois" "wikipedia2text")

for i in "${dependencies[@]}"
do
  if ! dpkg -l $i > /dev/null
  then
  sudo apt-get install $i -y
  fi
done;
