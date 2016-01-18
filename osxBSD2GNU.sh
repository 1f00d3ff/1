#!/bin/bash

## Define dependencies
declare -a gnuDependencies=("bash" "binutils" "coreutils" "gnu-sed --with-default-names" "grep --with-default-names")

## Detect OS
unameout=$(uname)                                           
if [[ "$unameout" == 'Darwin' ]]; then
  type -p brew 1>/dev/null
  if [[ $? != 0 ]]; then
    echo ''
    echo -e "Homebrew is not installed. Install it? (y/n) \c"
    read RESPONSE
    if [[ "$RESPONSE" == y ]]; then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      echo 'Exiting'
      exit 126
    fi
  else
    echo -n '√'
  fi
  ### bashrc or bash_profile check for coreutils path prefix
  if [[ $(grep -c 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"' ~/.bashrc) == 0 ]]; then
      if [[ $(grep -c 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"' ~/.bash_profile) == 0 ]]; then
        echo ''
        echo 'Path for brew coreutils prefix missing from ~/.bashrc or ~/.bash_profile'
        exit 126
      fi  
  else
    echo -n '√'
  fi
  ## brew tap validation
  tapped=$(brew tap | grep -c 'homebrew/dupes')
  if [[ $tapped = 0 ]]; then
    echo ''
    echo 'tapping homebrew/dupes'
    brew tap homebrew/dupes
  else
    echo -n '√' 
  fi
  ## GNU dependency checks
  for i in "${gnuDependencies[@]}"
  do
    if ! brew list $i 2>/dev/null > /dev/null; then
      echo ''
      echo -e "$i is not installed. Install it? (y/n) \c"
      read RESPONSE
      if [[ "$RESPONSE" == y ]]
      then
        brew install $i
      elif [[ "$RESPONSE" == n ]]
      then
        echo 'exiting script'
        exit 126      
      fi
    else
      echo -n '√'
    fi
  done
else
  echo 'not OSX'
  exit 126
fi
