#!/usr/bin/env bash

USERNAME="fabio.ewerton"
COMMAND='show running-config hostname ; show inventory | display curly-braces | include "product-name|serial-number|system-mac-address|PSU"'

PREFIX="100.127.0."

# Nome do arquivo de saída
OUTPUT_FILE="relatorio.txt"
# Limpa o conteúdo do arquivo se ele já existir
true > "$OUTPUT_FILE"

ssh_output(){
    ssh_output="$(sshpass -f password ssh -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR \
    "$USERNAME"@"$ip_address" "$COMMAND")"

    echo -e "\n$ssh_output\n"  # Redireciona a saída para o arquivo

} 

for ip in {1..5}; do
    ip_address="${PREFIX}${ip}"

    if ping -c 3 -q -W 3 "$ip_address" > /dev/null 2>&1; then
        ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$ip_address" > /dev/null 2>&1
       
        echo -e "\n[INFO] - Obtendo informações sobre - $ip_address"
        ssh_output # faz acesso SSH e cria variáveis
      
    else
        echo -e "\n[INFO] - Desculpe, melhor sorte da próxima vez $ip_address"
    fi

    # APENAS SEPARADOR
    for _ in $(seq 15); do echo -n "##### "; done ; echo
done
