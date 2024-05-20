#!/usr/bin/env bash

# +-------------------------------------------------------------------------+
# |                               SCRIPT HEADER                             |
# +-------------------------------------------------------------------------+

# Author    : Fabio Ewerton
# Website   : fabio.eti.br
# Social    : @FabioEw89

# Version   : 1.0.0

# +-------------------------------------------------------------------------+
# |                               VARIABLES                                 |
# +-------------------------------------------------------------------------+

USERNAME="fabio.ewerton"
COMMAND="show running-config hostname ;\
         show firmware"

# SLEEP="sleep 2"
TRASH="/dev/null"

prefix="100.127.0." #prefixo ipv4 /24?

# +-------------------------------------------------------------------------+
# |                               FUNCTIONS                                 |
# +-------------------------------------------------------------------------+

ssh_output(){
    ssh_output="$(sshpass -f password                                               \
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile="$HOME/.ssh/known_hosts"  \
    "$USERNAME"@"$ip_address" "$COMMAND")" > "$TRASH"
    
    get_device_hostname="$(echo "$ssh_output" | grep -i hostname | cut -d ' ' -f 2)"
    # get_device_firmware="$(echo "$ssh_output" | tail -2)"
    get_device_firmware_active="$(echo "$ssh_output" | grep Active | cut -d "-" -f 1)"
}

firmware_check_version() {
    # Extrai a parte numérica da versão do firmware
    firmware_version=$(echo "$get_device_firmware_active" | awk -F. '{print $1"."$2}')

    if (( $(echo "$firmware_version < 9.4" | bc -l) )); then
        echo -e "$get_device_hostname - $ip_address\
        \nFirmware - $get_device_firmware_active\n"
    fi
}

# +-------------------------------------------------------------------------+
# |                           CALL TO ACTION                                |
# +-------------------------------------------------------------------------+

for ip in {1..254}; do
    
    ip_address="${prefix}${ip}"
    
    if ping -c 3 -q "$ip_address" > "$TRASH"; then
        ssh_output
        firmware_check_version
    fi
done

# +-------------------------------------------------------------------------+
# |                               THE END                                   |
# +-------------------------------------------------------------------------+
