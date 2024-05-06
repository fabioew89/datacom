#!/usr/bin/env bash

username=fabio.ewerton

# CORES
# RED="\e[31m"
# GREE="\e[32m"
# RESET="\e[0"

for host in 172.25.4.{24..27}; do

    if ping -c 3 -q $host > /dev/null; then
        echo -e "\e[32m\n[INFO] - Equipamento "$host" esta pingando\n\e[0m"
        sshpass -f password ssh -o StrictHostKeyChecking=no \
        $username@$host "config ; sh hostname ; do show ip interface brief | include global"
    else
        echo -e "\e[31m\n[INFO] - Equipamento "$host" NÃO esta pingando\e[0m"
    fi

    echo
    for i in $( seq 15 ); do
        echo -n "DATACOM"
    done
    echo
done