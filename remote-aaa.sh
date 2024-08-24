#!/usr/bin/env bash

USERNAME="fabio.ewerton"
COMMAND="show running-config hostname ; show running-config aaa"

PREFIX="100.127.0."         

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
RESET="\e[0m"

ssh_output(){
    ssh_output="$(sshpass -f password ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    "$USERNAME"@"$ip_address" "$COMMAND")"

    get_device_hostname="$(echo "$ssh_output" | awk 'NR==1 { print $2 }')"
    
    get_device_aaa_users_local=$(echo "$ssh_output" | grep -i user | awk '{ print $3 }')
    get_device_aaa_users_remote=$(echo "$ssh_output" | grep -i server | awk '{ print $4 }')

    get_device_aaa_pass_local=$(echo "$ssh_output" | grep -i password | awk '{ print $2 }')
    get_device_aaa_pass_remote=$(echo "$ssh_output" | grep -i shared-secret | awk '{ print $2 }')

    local_passwords=$(awk 'NR > 1' password)

    TEMP_FILE=$(mktemp)
    echo "$get_device_aaa_pass_local" > "$TEMP_FILE"
    echo "$get_device_aaa_pass_remote" >> "$TEMP_FILE"
    local_passwords_temp=$(cat "$TEMP_FILE")
    rm -f "$TEMP_FILE"

}

ssh_config(){
    sshpass -f password ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    "$USERNAME"@"$ip_address" < "config/dmos-aaa-user-noc.conf"
}

for ip in {1..10}; do

    ip_address="${PREFIX}${ip}"

    if ping -c 3 -q -W 3 "$ip_address" > /dev/null 2>&1; then
        ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$ip_address" > /dev/null 2>&1
       
        ssh_output # make ssh access and create variables

        if [ "$local_passwords" != "$local_passwords_temp" ]; then
            
            echo -e "\n${GREEN}[INFO] - Geting information about $get_device_hostname - $ip_address${RESET}"
            echo -e "\n${YELLOW}The passwords AAA are different to $ip_address${RESET}\n"
            echo -e "${YELLOW}$get_device_aaa_users_local${RESET}"
            echo -e "${YELLOW}$get_device_aaa_users_remote${RESET}\n"
            
            ssh_config # config tacacs?
        else
            echo -e "\n${GREEN}[INFO] - Geting information about $get_device_hostname - $ip_address${RESET}\n"
            echo -e "\n${GREEN}The passwords AAA are ecqual to $ip_address${RESET}\n"            
            echo -e "${GREEN}$get_device_aaa_users_local${RESET}"
            echo -e "${GREEN}$get_device_aaa_users_remote${RESET}"
        fi
        
    else
        echo -e "${RED}\n[INFO] - Sorry, better luck next time $ip_address${RESET}"
    fi

    # JUST SEPARATOR
    echo; for _ in $(seq 15); do echo -n "##### "; done ; echo
done