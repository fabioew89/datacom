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
#
# Este script efetua a configuração padrão de 'alias' nos equipamentos DMOS \
# na rede que estão com a loopback 100.127.0.0/24

# +-------------------------------------------------------------------------+
# |                               VARIABLES                                 |
# +-------------------------------------------------------------------------+

USERNAME="fabio.ewerton"
COMMAND="show running-config hostname"

# SLEEP="sleep 2"
TRASH="/dev/null"

prefix="100.127.0." #prefixo ipv4 /24?

# +-------------------------------------------------------------------------+
# |                               FUNCTIONS                                 |
# +-------------------------------------------------------------------------+

ssh_output(){
    ssh_output="$(sshpass -f password                                               \
    ssh -o StrictHostKeyChecking=no \
    "$USERNAME"@"$ip_address" "$COMMAND")" > "$TRASH"
    
    get_device_hostname="$(echo "$ssh_output" | grep -i hostname | cut -d ' ' -f 2)"

    echo -e "$get_device_hostname - $ip_address"
}

config-alias() {
    ssh_output="$(sshpass -f password \
    ssh -o StrictHostKeyChecking=no \
    "$USERNAME"@"$ip_address" < "config/config-dmos-alias.conf")"
}

# +-------------------------------------------------------------------------+
# |                           CALL TO ACTION                                |
# +-------------------------------------------------------------------------+

for ip in {1..254}; do
    
    ip_address="${prefix}${ip}"
    
    if ping -c 3 -q "$ip_address" > "$TRASH"; then
        ssh_output
        config-alias
    fi

    # JUST SEPARATOR
    echo ; for _ in $(seq 15); do echo -n "##### " ; done ; echo    
done

# +-------------------------------------------------------------------------+
# |                                 END                                     |
# +-------------------------------------------------------------------------+


# #!/usr/bin/env bash

# USERNAME="fabio.ewerton"

# for host in {1..254}; do
#     sshpass -f password ssh -o StrictHostKeyChecking=no \
#     "$USERNAME"@172.25.8."$host"  < "config/config-dmos-alias.md"


# done
