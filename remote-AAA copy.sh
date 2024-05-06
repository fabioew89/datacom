#!/usr/bin/env bash

USERNAME="fabio.ewerton"
COMMAND="show running-config hostname ;\
         show running-config aaa"
         
aaa_pass_admin=$(cat password | awk 'NR == 2')
aaa_pass_tacacs=$(cat password | awk 'NR == 3')

RED="\e[31;1m"
GREEN="\e[32;1m"
YELLOW="\e[33;1m"
RESET="\e[0m"

ssh_output(){
    ssh_output="$(sshpass -f password ssh -o StrictHostKeyChecking=no "$USERNAME"@"$ip_address" "$COMMAND")"
    get_device_hostname="$(echo "$ssh_output" | awk 'NR==1 { print $2 }')"
    
    get_device_aaa_pass_admin=$(echo "$ssh_output" | grep -i password | awk '{ print $2 }')
    get_device_aaa_pass_tacacs=$(echo "$ssh_output" | grep -i shared | awk '{ print $2 }')
    
    get_device_aaa_users=$(echo "$ssh_output" | grep -i aaa | awk 'NR > 1 { print $3 }')
    # get_device_aaa_user_luan=$(echo "$ssh_output" | grep -i luan | awk '{ print $3 }')
}

ssh_config(){
    sshpass -f password ssh -o StrictHostKeyChecking=no -tt \
    "$USERNAME"@"$ip_address" < "config/config-dmos-aaa.md"
}

for ip_address in 100.127.0.{1..110}; do
    if ping -c 3 -q -W 3 "$ip_address" > /dev/null 2>&1; then
       
        ssh_output

        echo -e "\n${GREEN}[INFO] - Geting information about $get_device_hostname - $ip_address${RESET}"
        
        if [ "$get_device_aaa_pass_admin" == "$aaa_pass_admin" ] && \
           [ "$get_device_aaa_pass_tacacs" == "$aaa_pass_tacacs" ]; then
            
            echo -e "\n${GREEN}$get_device_aaa_users${RESET}"
            
        else

            echo -e "\n${YELLOW}$get_device_aaa_users${RESET}"

        fi
        
    else
        echo -e "${RED}\n[INFO] - Sorry, better luck next time $ip_address${RESET}"
    fi

    # JUST SEPARATOR
    echo
    for _ in $(seq 15 ); do
        echo -n "##### "
    done
    echo
done