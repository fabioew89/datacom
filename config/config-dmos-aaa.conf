config
!
aaa authentication-order [ local tacacs ]
!
aaa user admin
password $1$Pi9kh92A$eiEHc/gCDDiOxLwMDJVjJ0
group admin
!
aaa server tacacs SERVER-TACACS
host 143.137.92.114
authentication
authorization
accounting
shared-secret $7$kAPMAXqGDgvx0t27r6JLplKkSoMD/Kvx
!
top
!
commit and-quit label aaa comment "config server tacacs by fabio via shell script"
!
