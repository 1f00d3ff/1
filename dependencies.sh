#!/bin/bash

declare -a dependencies=("build-essential" "dnsutils" "espeak" "gnupg" "htop" "irssi" "jq" "knockd" "kpcli" "libterm-readline-gnu-perl" "ntp" "oathtool" "openssl" "openvpn" "rhash" "screen" "tesseract-ocr" "tesseract-ocr-eng" "tmux" "vim" "w3m" "wget" "whois" "wikipedia2text")

sudo apt-get update

for i in "${dependencies[@]}"
do
  if ! dpkg -l $i > /dev/null
  then
  sudo apt-get install $i -y
  fi
done;
