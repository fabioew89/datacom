#!/usr/bin/env bash

# +-------------------------------------------------------------------------+
# |                               SCRIPT HEADER                             |
# +-------------------------------------------------------------------------+

# Author    : Fabio Ewerton
# Website   : fabio.eti.br
# Social    : @FabioEw89

# Version   : 2.0.0

# +-------------------------------------------------------------------------+
# |                               DESCRIPTION                               |
# +-------------------------------------------------------------------------+

# Este script faz o levantamento de todos os equipamentos da antiga gerencia \
# l2, no caso a rede que já não é para ficar online, 172.25.8.x/24

# +-------------------------------------------------------------------------+
# |                               VARIABLES                                 |
# +-------------------------------------------------------------------------+

USERNAME="fabio.ewerton"
COMMAND="show running-config | include hostname"
TRASH="/dev/null"
SLEEP="sleep 2"

prefix="172.25.8." #prefixo ipv4 /24?

# +-------------------------------------------------------------------------+
# |                               FUNCTIONS                                 |
# +-------------------------------------------------------------------------+

ssh_output(){
    ssh_output="$(sshpass -f password ssh \
    -o StrictHostKeyChecking=no \
    -o KexAlgorithms=+diffie-hellman-group1-sha1 \
    -o HostKeyAlgorithms=+ssh-dss \
    "$USERNAME"@"$ip_address" "$COMMAND")" # > "$TRASH"
    
    # get_device_hostname="$(echo "$ssh_output")"
    # echo -e "$get_device_hostname - $ip_address" # hostname?
    echo -e "$ssh_output"

}

# +-------------------------------------------------------------------------+
# |                           CALL TO ACTION                                |
# +-------------------------------------------------------------------------+

for ip in {1..254}; do
    
    ip_address="${prefix}${ip}"
    
    if ping -c 1 -q "$ip_address" > "$TRASH"; then
        echo -e "$ip_address" >> gerencia_l2.txt
    fi

    # JUST SEPARATOR
    # echo ; for _ in $(seq 15); do echo -n "##### " ; done ; echo    
done

# +-------------------------------------------------------------------------+
# |                                 END                                     |
# +-------------------------------------------------------------------------+