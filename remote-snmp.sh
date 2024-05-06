#!/usr/bin/env bash

username=fabio.ewerton

for host in 100.127.0.{1..90}; do

    if ping -c 3 -q $host > /dev/null; then
        echo -e "\e[32m\n[INFO] - Equipamento "$host" esta pingando\n\e[0m"
        sshpass -f password ssh -o StrictHostKeyChecking=no \
        $username@$host "sh run hostname ; show running-config snmp | include community"
    else
        echo -e "\e[31m\n[INFO] - Equipamento "$host" NÃO esta pingando\e[0m"
    fi

    echo
    for i in $( seq 15 ); do
        echo -n "#####"
    done
    echo
done