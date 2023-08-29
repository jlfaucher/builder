
#echo "Running .bashrc (SHLVL=$SHLVL)"

# Under Ubuntu 20, this file is not executed when not interactive:
# They return immediatly.

export PS1='\w\$ '

test -r ~/.bash_env && . ~/.bash_env
#. "$HOME/.cargo/env"
