#!/usr/bin/env bash


# Acesso via SSH
# Host: dm4610-demo.datacom.com.br
# Usuário: demo-user
# Senha: demodemo

# VARIABLES

USERNAME="demo-user"
HOSTS=(
    "dm4610-demo.datacom.com.br"
    "dm4050-demo.datacom.com.br"
)
BACKUP_FOLDER=$(date +%F-%R | sed s/:/-/g)
mkdir "$BACKUP_FOLDER"

sshpass -f password ssh -o StrictHostKeyChecking=no \
"$USERNAME"@"$HOSTS" "sh run host" | \
cut -d " " -f 2 | \

# < "config-dmos-alias.md"

/var/lib/tftpboot/V8.../

