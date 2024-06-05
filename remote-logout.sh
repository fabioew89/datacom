#!/usr/bin/env bash

USERNAME="fabio.ewerton"
HOST="100.127.0.2"
SESSION="7694650"

for _ in {1..10}; do
    ping -c 3 -W 3 -q $HOST > /dev/null && \
    sshpass -f password ssh -o StrictHostKeyChecking=no \
    $USERNAME@$HOST "logout session $SESSION"

    echo "logout session executado com sucesso!!!"
    # echo ; for _ in $( seq 10 ); do echo -n "##### " ; done ; echo
done
