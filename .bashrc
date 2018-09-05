# .bashrc

# load global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# load local definitions
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi

# get environment variables
if [ -f ~/.env ]; then
	. ~/.env
fi

# test for an non-interactive shell
if [[ $- != *i* ]]; then
	return
fi

# add tab completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# load user configuration
if [ -f ~/.bash_profile ]; then
	. ~/.bash_profile
fi
