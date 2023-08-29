
#echo "Running .profile (SHLVL=$SHLVL)"

# Under Ubuntu 20, they read ~/.bashrc only when running bash
test -r ~/.bashrc && . ~/.bashrc    # calls ~/.bash_env

#export BASH_ENV=~/.bash_env         # used when bash is started non-interactively
export ENV=~/.bash_env              # used when sh is started interactively (yes! the opposite)

export LC_ALL=en_US.UTF-8

# jlf 21/08/2021
# No longer use brew to install cmake
# Now downloading directly from https://cmake.org/download/
export PATH="/Applications/CMake.app/Contents/bin:$PATH"

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# JLF: keep it LAST! okay ?
export PATH=~/bin:$PATH

# STOP! DON'T PUT SOMETHING AFTER THIS LINE! OKAY ?
