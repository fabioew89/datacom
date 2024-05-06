#!/usr/bin/env bash

USERNAME="fabio.ewerton"
COMMAND="show running-config hostname ;\
         show firmware"

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
RESET="\e[0m"

ssh_output(){
    ssh_output="$(sshpass -f password ssh -o StrictHostKeyChecking=no "$USERNAME"@"$ip_host" "$COMMAND")"
    get_device_hostname="$(echo "$ssh_output" | grep -i hostname | cut -d ' ' -f 2)"
    get_device_firmware="$(echo "$ssh_output" | tail -2)"
    get_device_firmware_version="$(echo "$ssh_output" | grep Active | cut -d "." -f 1)"
}

firmware_check_version(){
    [ $get_device_firmware_version -ge 8 ] && \
    echo -e "${GREEN}\nUp to date! 😁${RESET}" || \
    echo -e "${YELLOW}\nNeeds updating! 😭${RESET}"
}


for ip_host in 100.127.0.{1..100}; do
    if ping -c 3 -q -W 3 "$ip_host" > /dev/null; then
        ssh_output
        
        echo -e "${GREEN}\n[INFO] - Geting information about "$get_device_hostname" - "$ip_host"${RESET}\n\
        \n$get_device_hostname\n$get_device_firmware"
        
        firmware_check_version

    else
        echo -e "${RED}\n[INFO] - Sorry, better luck next time "$ip_host"${RESET}"
    fi

    # JUST SEPARATOR
    echo
    for i in $( seq 15 ); do echo -n "##### " done
    echo   
done
