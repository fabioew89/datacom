#!/usr/bin/env bash

username='fabio.ewerton'
password_default='$1$Pi9kh92A$eiEHc/gCDDiOxLwMDJVjJ0'

for host in 100.127.0.{15..20}; do

    if ping -c 3 -q $host > /dev/null; then
        echo -e "\e[32m\n[INFO] - Equipamento "$host" esta pingando\n\e[0m"
        
        output=$(sshpass -f password ssh -o StrictHostKeyChecking=no "$username"@"$host" \
        "sh run hostname ; show running-config aaa user admin | select password")

        # output_pass=$(echo "$output" | grep -i "$password_default" | cut -d ' ' -f 3)
        # output_host=$(echo "$output" | grep -i 'hostname' | cut -d ' ' -f 2)
          
        # if echo "$output_host" && echo "$output_pass"; then
        
        if echo "$output" | grep -i "$password_default" | cut -d ' ' -f 3 && \
           echo "$output" | grep -i 'hostname' | cut -d ' ' -f 2; then
            echo "Senha do Admin esta correta!"
        else
            echo "Senha do Admin NÃO esta correta!"
        fi

    else
        echo -e "\e[31m\n[INFO] - Equipamento "$host" NÃO esta pingando\e[0m"
    fi

    echo
    for i in $( seq 15 ); do
        echo -n "#####"
    done
    echo
done
