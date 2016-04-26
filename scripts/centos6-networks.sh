#!/bin/sh

cat << EOF1 > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=dhcp
EOF1

/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules

rm -f /etc/sysconfig/network-scripts/ifcfg-eno*

echo "# Override /lib/udev/rules.d/75-persistent-net-generator.rules" > /etc/udev/rules.d/75-persistent-net-generator.rules

cat << EOF > /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{type}=="1", KERNEL=="eth0", NAME="eth0"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{type}=="1", KERNEL=="eth1", NAME="eth1"
EOF
