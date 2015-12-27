#!/bin/bash

for each in `echo $1`
do
  echo "$each" | sha256sum | xxd -r -p | base64 -w 0 | cut -c 1-8 | sed -r 's/\+/\$/g' | sed -r 's/\//\#/g'
done;
