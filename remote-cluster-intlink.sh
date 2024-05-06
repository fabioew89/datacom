#!/usr/bin/env bash

for host in {73..74}; do
    sshpass -f password ssh -o StrictHostKeyChecking=no "fabio.ewerton"@100.127.0.$host  < "config/config-dmos-cluster-intlink.md"
    echo " "
    echo "##################################################"
    echo " "
done
