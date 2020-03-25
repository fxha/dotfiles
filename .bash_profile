# .bash_profile

# Load aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Load prompt
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# Get environment variables
if [ -f ~/.env ]; then
    . ~/.env
fi

# Get functions
if [ -f ~/.functions ]; then
    . ~/.functions
fi

# Get secrets
if [ -f ~/.secrets ]; then
    . ~/.secrets
fi

# Get SSH aliases and startup script
if [ -f ~/.ssh_utils ]; then
    . ~/.ssh_utils
fi

# Load local user configuration
if [ -f ~/.bash_profile.local ]; then
    . ~/.bash_profile.local
fi

# cd into ConEmu's working directory on Windows
if [[ "$(uname)" == "CYGWIN"* &&
    -n "$ConEmuWorkDir" && -d "$ConEmuWorkDir" ]]; then
   cd "$ConEmuWorkDir"
fi

# Alias completion
# if [ -f ~/.bash_completion_helper.sh ]; then
#     . ~/.bash_completion_helper.sh
#
#     # complete -F _complete_alias g
# fi

# Always start tmux
# if [ -z "$TMUX" ]; then
#    tmux attach -t default || tmux new -s default
# fi
