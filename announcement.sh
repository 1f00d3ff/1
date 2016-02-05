#!/bin/bash

MESSAGE=$1
OUTPUT='volume:\K[0-9]{1,2}'
MUTED='muted:\K[a-z]{4,5}'

function getVolume {
  osascript -e 'get volume settings' | grep -Po "($1)" | sed -n 1p 
}

function setVolume {
  osascript -e "set volume $1"
}

if [ $(getVolume ${MUTED}) == true ]; then
  GB2M=yes
  setVolume 'output muted false'
fi

setVolume 7.5
say "$MESSAGE"

## Return mute to previous state
if [[ $GB2M == yes ]]; then
  setVolume 'output muted true'
else
  setVolume '3.0'
fi
