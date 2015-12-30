#!/bin/bash

until ping -W1 -c1 google.com; do sleep 5; done && push back online
