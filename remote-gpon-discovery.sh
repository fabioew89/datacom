#!/usr/bin/env bash

for host in {51..54}; do
    echo ''
    sshpass -f 'password' ssh -o StrictHostKeyChecking=no fabio.ewerton@172.21.0.$host  \
    'sh run hostname ; sh int gp dis'
    echo ''
    for _ in $( seq 15 ); do
        echo -n "#####"
    done
    echo ''
done


