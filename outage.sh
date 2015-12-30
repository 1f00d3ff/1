#!/bin/bash

until ping -W1 -c1 google.com & 2>/dev/null; do sleep 5; done && push back online
