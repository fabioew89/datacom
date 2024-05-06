#!/usr/bin/env bash

for host in {1..5}; do
    echo ''
    sshpass -f 'password' ssh -o StrictHostKeyChecking=no fabio.ewerton@100.127.0.$host  \
    'sh run hostname ; show interface description | include [A-Z] | exclude "CHASSIS|ID"'
    echo ''
    for i in $( seq 15 ); do
        echo -n "#####"
    done
    echo ''
    sleep 2
done


