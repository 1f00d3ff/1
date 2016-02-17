#!/bin/bash

CPUS=$(($(grep -c processor /proc/cpuinfo)+1))

sudo apt-get install irssi-dev
sudo apt-get install libloudmouth1-dev 
cd ~ && wget -O - "https://github.com/cdidier/irssi-xmpp/archive/v0.52.tar.gz" | tar zxf -
cd ~/irssi-xmpp-0.52

export IRSSI_INCLUDE=/usr/include/irssi/

make -j $CPUS

sudo make PREFIX=/usr install

mkdir -p ~/.irssi/scripts/autorun/

wget -O - "https://scripts.irssi.org/scripts/nickcolor.pl" > ~/.irssi/scripts/nickcolor.pl
ln -s ~/.irssi/scripts/nickcolor.pl ~/.irssi/scripts/autorun/nickcolor.pl

wget -O - "https://scripts.irssi.org/scripts/trackbar22.pl" > ~/.irssi/scripts/trackbar22.pl
ln -s ~/.irssi/scripts/trackbar22.pl ~/.irssi/scripts/autorun/trackbar22.pl

echo 'LOAD xmpp' >> ~/.irssi/startup
