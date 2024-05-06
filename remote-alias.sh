#!/usr/bin/env bash

USERNAME="fabio.ewerton"

for host in {1..254}; do
    sshpass -f password ssh -o StrictHostKeyChecking=no \
    "$USERNAME"@172.25.8."$host"  < "config/config-dmos-alias.md"

    # JUST SEPARATOR
    echo
    for _ in $(seq 15); do
      echo -n "##### "
    done
    echo
done
