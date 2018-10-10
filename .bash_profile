# .bash_profile

# get aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# prompt
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# get environment variables
if [ -f ~/.env ]; then
    . ~/.env
fi

# get functions
if [ -f ~/.functions ]; then
    . ~/.functions
fi

# get secrets
if [ -f ~/.secrets ]; then
    . ~/.secrets
fi

# get ssh aliases and startup script
if [ -f ~/.ssh_utils ]; then
    . ~/.ssh_utils
fi

# load local user configuration
if [ -f ~/.bash_profile.local ]; then
    . ~/.bash_profile.local
fi

# cd into ConEmu's working directory on Windows
if [[ "$(uname)" == "CYGWIN"* &&
    -n "$ConEmuWorkDir" && -d "$ConEmuWorkDir" ]]; then
   cd "$ConEmuWorkDir"
fi

# always start tmux
#if [ -z "$TMUX" ]; then
#    tmux attach -t default || tmux new -s default
#fi
