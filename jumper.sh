#!/bin/bash

if [ $(pgrep openvpn) ]; then
	OVPN_PROC=$(pgrep openvpn)
	sudo kill -9 $OVPN_PROC
fi

TG_RAND=$(ls /etc/openvpn/*.conf | shuf | head -n 1)
TG_CONN=${TG_RAND##/*/}
echo "Connecting to: $TG_CONN"

sudo openvpn --daemon --cd /etc/openvpn --config $TG_CONN
