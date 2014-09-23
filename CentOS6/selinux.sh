#!/bin/bash

usage()
{
	echo "Usage: "
	echo -e "\t`basename $0` {on|off}"
}

COLOR_SUCCESS="\\033[1;32m"
COLOR_FAILURE="\\033[1;31m"
COLOR_NORMAL="\\033[0;39m"

success()
{
	echo -e "${COLOR_SUCCESS}$1${COLOR_NORMAL}"
}

failure()
{
	echo -e "${COLOR_FAILURE}$1${COLOR_NORMAL}"
}

SELINUX_CONFIG=/etc/selinux/config

enable_selinux()
{
	echo "The kernel state: `getenforce`"
	echo "The config state: `grep '^SELINUX=' $SELINUX_CONFIG`"

	grep -q '^SELINUX=disabled' $SELINUX_CONFIG
	if [ $? -ne 0 ]; then
		success "Config seems already enabled."
		exit
	fi

	if [ -e ${SELINUX_CONFIG}.org ]; then
		mv ${SELINUX_CONFIG}.org ${SELINUX_CONFIG} &&
			success "Enabled.  Please reboot" ||
			failure "Failed to enable"
		sync
	else
		failure "No backup found; Need to edit the config by hand."
	fi
}

disable_selinux()
{
	echo "The kernel state: `getenforce`"
	echo "The config state: `grep '^SELINUX=' $SELINUX_CONFIG`"

	grep -q '^SELINUX=disabled' $SELINUX_CONFIG
	if [ $? -eq 0 ]; then
		success "Config seems already disabled."
		exit
	fi

	if [ -e ${SELINUX_CONFIG}.org ]; then
		failure "Backup exists; Need to edit the config by hand."
	else
		cp -a $SELINUX_CONFIG ${SELINUX_CONFIG}.org
		if [ -e ${SELINUX_CONFIG}.org ]; then
			sed -ie '/^SELINUX=/s/=.*/=disabled/' $SELINUX_CONFIG
			grep -q '^SELINUX=disabled' $SELINUX_CONFIG &&
				success Disabled || failure "Failed to disable"
		else
			failure "Failed to backup the config; not disabled"
		fi
	fi
}

case "$1" in
	on)
		if [ $# -gt 1 ]; then
			usage
			exit 1
		fi
		enable_selinux
		;;
	off)
		if [ $# -gt 1 ]; then
			usage
			exit 1
		fi
		disable_selinux
		;;
	*)
		usage
		exit 1
		;;
esac


