#!/bin/bash

PUSHOVER_USER=$(awk '{print $1}' ~/.pushoverCreds)
PUSHOVER_TOKEN=$(awk '{print $2}' ~/.pushoverCreds)

curl -s \
  -F "token=$PUSHOVER_TOKEN" \
  -F "user=$PUSHOVER_USER" \
  -F title=bread \
  -F message=toast \
  https://api.pushover.net/1/messages.json; echo ''
