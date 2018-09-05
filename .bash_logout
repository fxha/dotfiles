# ~/.bash_logout

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# load local configuration
if [ -f ~/.bash_logout.local ]; then
    . ~/.bash_logout.local
fi
