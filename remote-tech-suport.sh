#!/usr/bin/env bash

USERNAME="fabio.ewerton"
DATE="$(date +%F | sed s/-//g)"
COMMAND="show running-config"

for host in 100.127.0.{11..13}; do

    output_hostname="$( sshpass -f password ssh -o StrictHostKeyChecking=no $USERNAME@$host \
            "sh run hostname" | grep -i 'hostname' | cut -d ' ' -f 2)"
    
    output_hostname_file=$DATE-$output_hostname

    if ping -c 3 -q $host > /dev/null; then

        echo -e "\e[32m\n[INFO] - Extraindo informações do host "$host" - "$output_hostname"\e[0m\n"

        output=$(sshpass -f password ssh -o StrictHostKeyChecking=no $USERNAME@$host \
            "$COMMAND | nomore | save "$output_hostname_file" ; 
            copy file "$output_hostname_file" tftp://143.137.92.139/V8C4rxp9cM-incoming/tech-support/ ;
            file delete "$output_hostname_file"")

        echo  "$output_hostname"
        echo  "$output"

    else
        echo -e "\e[31m\n[INFO] - Equipamento "$host" - "$output_hostname" NÃO esta pingando\e[0m"
    fi

    echo
    for _ in $( seq 15 ); do
        echo -n "##### "
    done
    echo

done
