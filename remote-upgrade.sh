#!/usr/bin/env bash

USERNAME="fabio.ewerton"
COMMAND="show running-config hostname ;\
         show firmware"

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
RESET="\e[0m"

ssh_output(){
    ssh_output="$(sshpass -f password ssh -o StrictHostKeyChecking=no \
    "$USERNAME"@"$ip_host" "$COMMAND")" > /dev/null 2>&1
    get_device_hostname="$(echo "$ssh_output" | grep -i hostname | cut -d ' ' -f 2)"
    get_device_firmware="$(echo "$ssh_output" | tail -2)"
    get_device_firmware_version="$(echo "$ssh_output" | grep Active | cut -d "-" -f 1)"
}

firmware_check_version_check() {
    # Extrai a parte numérica da versão do firmware
    firmware_version=$(echo "$get_device_firmware_version" | awk -F. '{print $1"."$2}')

    if (( $(echo "$firmware_version >= 9.4" | bc -l) )); then
        echo -e "${GREEN}Up to date! 😁${RESET}"
    elif (( $(echo "$firmware_version < 9.4" | bc -l) )); then
        echo -e "${YELLOW}Needs updating! 😭${RESET}"
    else
        echo 'versão do firmware desconhecida'
    fi
}


for ip_host in 100.127.0.{1..100}; do
    if ping -c 3 -q -W 3 "$ip_host" > /dev/null 2>&1; then
        echo -e "${GREEN}\n[INFO] - Geting information about $get_device_hostname - $ip_host${RESET}\n\
        \n$get_device_hostname\n$get_device_firmware\n"        
        
        ssh_output
        
        firmware_check_version_check

    else
        echo -e "${RED}\n[INFO] - Sorry, better luck next time $ip_host${RESET}"
    fi

    # JUST SEPARATOR
    echo ; for _ in $( seq 15 ); do echo -n "##### "; done ; echo
done
