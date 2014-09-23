#!/bin/bash

# This script work around the issue that cloning CentOS6 VM causes
# eth0 being renamed to eth1 after a machine reboot.

rm -f /etc/udev/rules.d/70-persistent-net.rules

shopt -s nullglob
for file in /etc/sysconfig/network-scripts/ifcfg-eth[0-9]
do
	sed -i -e '/HWADDR=/d' $file
done

echo "Done.  Now, reboot the machine."
