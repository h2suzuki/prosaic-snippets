#!/bin/bash

# You must set sysctl limit to allow $MAXFORK. For example,
#   sysctl -w fs.inotify.max_user_instances=3500

MAXFORK=3000
STOPFILE=./DELETE_TO_STOP

touch $STOPFILE

for ((i=0;i<$MAXFORK;i++))
do
	# inotify-tools required.
	inotifywait -e delete_self $STOPFILE >/dev/null 2>&1 </dev/null &
done

echo "inotifywait forked $i times."
echo "delete $STOPFILE to quit the forked processes"

