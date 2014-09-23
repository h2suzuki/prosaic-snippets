# Bash prompt customization

_print_exit_code()
{
	_NEWEXIT=$?
	[ $_NEWEXIT -eq ${_OLDEXIT:-0} ] && return
	[ $_NEWEXIT -ne 0 ] && echo "Exit Code: $_NEWEXIT"
	_OLDEXIT=$_NEWEXIT
}

if [ "$PS1" ]; then
	PROMPT_COMMAND=_print_exit_code
        # PS1="[\u@\h \W][$SHLVL]\\$ "
fi
