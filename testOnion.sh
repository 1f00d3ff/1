#!/bin/bash

if [[ -s /etc/apt/sources.list ]]; then
	if [[ $(grep -c 'deb http://deb.torproject.org/torproject.org jessie main' /etc/apt/sources.list) != 1 ]]; then
		echo 'deb http://deb.torproject.org/torproject.org jessie main' >> /etc/apt/sources.list
	elif [[ $(grep -c 'deb-src http://deb.torproject.org/torproject.org jessie main' /etc/apt/sources.list) != 1 ]]; then
		echo 'deb-src http://deb.torproject.org/torproject.org jessie main' >> /etc/apt/sources.list
	fi
fi

if ! type -f gpg > /dev/null 2>/dev/null; then
	sudo apt-get install gnupg2

if .gnupg dir exists && .gnupg/gpg.conf exists && [[ $(gpg listdeb.torproject.org = "public key not found"
			gpg --keyserver keys.gnupg.net --recv 886DDD89
