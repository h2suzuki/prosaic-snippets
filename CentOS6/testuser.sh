#!/bin/bash

usage()
{
	echo "Usage: "
	echo -e "\t`basename $0` add    [user_name]"
	echo -e "\t`basename $0` delete [user_name]"
	echo -e "\t`basename $0` list"
}

COLOR_SUCCESS="\\033[1;32m"
COLOR_FAILURE="\\033[1;31m"
COLOR_NORMAL="\\033[0;39m"

success()
{
	echo -e "${COLOR_SUCCESS}OK${COLOR_NORMAL}"
}

failure()
{
	echo -e "${COLOR_FAILURE}FAILED${COLOR_NORMAL}"
}

add_user()
{
	USERNAME=${1:-testuser}
	SUDOERS=/etc/sudoers.d/$USERNAME

	echo -n "Adding $USERNAME...  "
	useradd $USERNAME >/dev/null 2>&1
	grep '^'"$USERNAME": /etc/passwd >/dev/null
	[ $? -eq 0 ] && success || failure

	echo -n "Setting passwd for $USERNAME...  "
	echo -n "$USERNAME" | passwd --stdin $USERNAME >/dev/null 2>&1
	[ $? -eq 0 ] && success || failure

	echo -n "Adding $SUDOERS...  "
	echo "$USERNAME  ALL=(ALL)  NOPASSWD:ALL" > $SUDOERS
	chmod 0400 $SUDOERS
	[ -r $SUDOERS ] && success || failure
}

delete_user()
{
	USERNAME=${1:-testuser}
	SUDOERS=/etc/sudoers.d/$USERNAME

	echo -n "Removnig $USERNAME...  "
	userdel -r "$USERNAME" >/dev/null 2>&1
	grep '^'"$USERNAME": /etc/passwd >/dev/null
	[ $? -ne 0 ] && success || failure

	echo -n "Removing $SUDOERS...  "
	rm -f $SUDOERS
	[ -e $SUDOERS ] && failure || success
}

list_user()
{
	awk -F: '$3<500      {next}
		 $1~/nobody/ {next}
		             {print $1,"uid:"$3,"gid:"$4,$6}
	' /etc/passwd |
	while read name uid gid home
	do
		[ -e "$home" ] && annote="" || annote=" (deleted)"
		printf "%-16s %s  %s\n" "$name" "$uid $gid" "${home}${annote}"
	done
}

case "$1" in
	add)
		if [ $# -gt 2 ]; then
			usage
			exit 1
		fi
		add_user "$2"
		;;
	delete)
		if [ $# -gt 2 ]; then
			usage
			exit 1
		fi
		delete_user "$2"
		;;
	list)
		if [ $# -ne 1 ]; then
			usage
			exit 1
		fi
		list_user
		;;
	*)
		usage
		exit 1
		;;
esac


