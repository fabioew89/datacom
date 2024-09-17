#!/usr/bin/env bash

USERNAME="fabio.ewerton"

PREFIX="172.25.8."

# Nome do arquivo de saída
OUTPUT_FILE="relatorio.txt"
# Limpa o conteúdo do arquivo se ele já existir
true > "$OUTPUT_FILE"

ssh_output(){
    ssh_output="$(sshpass -f password ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    "$USERNAME"@"$ip_address")"

    echo -e "\n$ssh_output\n"  # Redireciona a saída para o arquivo

} 

for ip in {1..254}; do
    ip_address="${PREFIX}${ip}"

    if ping -c 1 -q -W 1 "$ip_address" > /dev/null 2>&1; then
        ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$ip_address" > /dev/null 2>&1
        echo -e "$ip_address"
    fi

done
