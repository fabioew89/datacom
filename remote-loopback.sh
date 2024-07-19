#!/usr/bin/env bash

for host in 100.127.0.{1..90}; do

    if ping -c 3 -q $host > /dev/null; then
        echo -e "\e[32m\n[INFO] - Equipamento "$host" esta pingando\n\e[0m"
        
        output=$(sshpass -f password ssh -o StrictHostKeyChecking=no 'fabio.ewerton'@$host \
        "sh run hostname ; show running-config interface loopback 0")

        output_host=$(echo "$output" | grep -i 'hostname' | cut -d ' ' -f 2)
        output_loop=$(echo "$output" | grep -i '100.127.0' | cut -d ' ' -f 4)

        echo $output_host
        echo $output_loop

    else
        echo -e "\e[31m\n[INFO] - Equipamento "$host" NÃO esta pingando\e[0m"
    fi

    echo
    for _ in $( seq 10 ); do
        echo -n "#####"
    done
    echo

done
