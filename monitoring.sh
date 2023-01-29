#!/bin/bash
os=$(. /etc/os-release; echo "$NAME")
ker=$(uname -r)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free --mega | awk '$1 == "Mem.:" {print $2}')
uram=$(free --mega | awk '$1 == "Mem.:" {print $3}')
pram=$(free --mega | awk '$1 == "Mem.:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lrb=$(who -b | awk '$1 == "arranque" {print $4 " " $5}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(netstat -t | grep 'tcp' | wc -l)
cudp=$(netstat -n --udp | grep 'udp' | wc -l)
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
cmds=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)
wall "	#Operating System: $os 
	#Kernel: $ker
	#CPU physical: $pcpu
	#CPU virtual: $vcpu
	#Memory Usage: ${uram}MB/${fram}MB ($pram%)
	#Disk Usage: ${udisk}Gb/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul
	#Last reboot: $lrb
	#LVM use: $lvmu
	#Connexions TCP: $ctcp ESTABLISHED, UDP: $cudp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd"
