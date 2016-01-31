#!/bin/bash

CODENAME=$(lsb_release -a 2>/dev/null | grep Codename | awk '{print $2}')
gnupg_link=$(curl "http://packages.ubuntu.com/$CODENAME/amd64/gnupg/download" 2>&1 | grep -ioE '(http://mirrors.kernel.org/ubuntu/pool/main/g/gnupg/gnupg[a-zA-Z0-9./_-]+*.deb)')
apt_link=$(curl "http://packages.ubuntu.com/$CODENAME/amd64/apt/download" 2>&1 | grep -ioE '(http://mirrors.kernel.org/ubuntu/pool/main/a/apt/[a-zA-Z0-9._/-]+*amd64.deb)')

function checkAndInstall {
if [[ ! -s /tmp/${1}.deb ]]; then
  wget -O /tmp/${1}.deb "$2" 
  sudo dpkg --install /tmp/${1}.deb
	rm -v /tmp/${1}.deb
fi
}

checkAndInstall gnupg $gnupg_link

checkAndInstall apt $apt_link
