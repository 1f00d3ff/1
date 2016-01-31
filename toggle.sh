#!/bin/bash

MSTATE=$(synclient | grep Touchpad | awk '{print $3}')

function toggle {
	synclient TouchpadOff\=${1}
}

if [[ $MSTATE == 0 ]]; then
	toggle 1
else
	toggle 0
fi
