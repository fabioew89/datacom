#!/usr/bin/env bash

USERNAME='demo-user'
COMMAND="show running-config hostname ; \
         show firmware ; \
         show ip int brief ; \
         sh run int l3"

RED="\e[31;1m"
# GREEN="\e[32;1m"
YELLOW="\e[33;1m"
RESET="\e[0m"

list_demo_device=(
  'dm4170-demo.datacom.com.br'
  'dm4370-demo.datacom.com.br'
  'dm4050-demo.datacom.com.br'
  'dm4610-demo.datacom.com.br'
  'dm4610-demo-2.datacom.com.br'
  'dm4610-demo-3.datacom.com.br'
)

ssh_output_device(){
  ssh_output_device="$(sshpass -f password ssh -o StrictHostKeyChecking=no \
  $USERNAME@"$device_ip" "$COMMAND")"

  # VARIABLE
  get_device_hostname="$(echo "$ssh_output_device" | awk 'NR==1 { print $2 }')"
  get_device_ip_int_brief="$(echo "$ssh_output_device" | awk '/Type Codes/,0')"
  # get_info_device="$(echo "$ssh_output_device")"


}

for device_ip in "${list_demo_device[@]}"; do
  if ping -c 3 -q -W 3 "$device_ip" > /dev/null 2>&1; then 

    ssh_output_device

    echo -e "\n${GREEN}${get_device_hostname}\n${get_device_ip_int_brief}${RESET}"
    echo -e "${RED}$get_device_hostname\n${YELLOW}$ssh_output_device${RESET}"

  else
    echo -e "\n${RED}Equipamento offline${RESET}"

  fi

  echo
  # shellcheck disable=SC2034
  for i in $(seq 5); do
    echo -n '##### '
  done
  echo  

  break
done
