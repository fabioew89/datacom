show running-config hostname

config

dot1q
 vlan 94
  name DMZ-EXT
  interface twenty-five-g-ethernet-1/1/1
  interface twenty-five-g-ethernet-1/1/2
  interface twenty-five-g-ethernet-1/1/3
  interface twenty-five-g-ethernet-1/1/4
  !
 !
!

commit and-quit label dot1q comment "+ config dot1q by fabio"
!

show vlan membership 94
