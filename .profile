#
# ~/.profile: Executed by the command interpreter for login shells.  This file
# is not read by bash(1) if ~/.bash_profile or ~/.bash_login exists.
#

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# ================== #
# Universal Settings #
# ================== #

umask 022
ulimit -c 0
export VISUAl="vim"
export EDITOR="vim"

# ===================== #
# Environment Detection #
# ===================== #

# Shell
if [ -n "$BASH_VERSION" ]; then
  PROFILE_SHELL=bash
elif [ -n "$ZSH_VERSION" ]; then
  PROFILE_SHELL=zsh
fi

# OS
OSNAME=${OSTYPE//[0-9.]/}

# ======== #
# Sourcing #
# ======== #

# Shell Source
if [ -f "$HOME/.${PROFILE_SHELL}rc" ]; then
  . "$HOME/.${PROFILE_SHELL}rc"
fi

#. "$HOME/.cargo/env"
