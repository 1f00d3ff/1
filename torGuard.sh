#!/bin/bash

LAST_UPDATE=$(stat -c %y /var/cache/apt/ | awk '{print $1}')
TODAY=$(date +"%Y-%m-%d")
if [ $LAST_UPDATE != $TODAY ]; then
	sudo apt-get update
fi

if ! dpkg -l openvpn > /dev/null; then
	sudo apt-get install openvpn
fi

cd /etc/openvpn
if [ ! $(ls /etc/openvpn/TorGuard* | wc -l) -gt 20 ]; then
	sudo wget -q https://torguard.net/downloads/openvpn.zip
	sudo unzip -jqq openvpn.zip
fi

sudo sed -i 's///g' *.ovpn
sudo sed -ir 's/auth-user-pass$/auth-user-pass auth/g' *.ovpn

sudo rename -f 's/\.ovpn/\.conf/g' *.ovpn
sudo rm -rf *.ovpnr
sudo rename -f 's/ //g' *.conf


if [ ! -L ./auth ]; then
	sudo ln -s ~/.creds/torguard ./auth
fi

if [ $(sudo find /etc/openvpn -name "auth" -user root -perm 600 | wc -l ) != "1" ]; then
	sudo chmod 600 ./auth
fi

sudo rm -rf /etc/openvpn/openvpn.zip

TG_RAND=$(ls /etc/openvpn/*.conf | shuf | head -n 1)
TG_CONN=${TG_RAND##/*/}
echo "Connecting to: $TG_CONN"

sudo openvpn --daemon --cd /etc/openvpn --config $TG_CONN
