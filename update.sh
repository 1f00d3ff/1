#!/bin/bash


LAST_UPDATE=$(stat -c %y /var/cache/apt/ | awk '{print $1}')
TODAY=$(date +"%Y-%m-%d")
if [ $LAST_UPDATE != $TODAY ]; then
  sudo apt-get update
fi
