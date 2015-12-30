#!/bin/bash -e

curl -s -u "$TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN" -d "From=$TWILIO_CALLER_ID" -d "To=$1" -d "Body=$2" "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/SMS/Messages" 2>&1 | grep -Eo '(<To>[0-9+]{12}|<From>[0-9+]{12}|<Body>[a-zA-Z ]{1,160})' | sed 's/<//g' | sed 's/>/: /g'
