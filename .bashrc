#!/usr/bin/env bash

#
# Exports
#

export CLICOLOR=1                      # Colorize the Terminal
export GREP_OPTIONS='--color=auto'     # Add color to grep
export CDPATH=.:~:~/Documents:/Volumes # cd will now look in all these directories, instead of just .
export HISTIGNORE="&:ls:l:[bf]g:exit"  # Ignore certail non-important commands in the history

#
# Shell Options
#

shopt -s cdspell # Correct minor spelling errors in cd
shopt -s dotglob # Allow files starting with dot (.) to be returned in path name expansion
shopt -s extglob # Extend pattern matching in bash to use regexp (?*+@!)

#
# Aliases
#

alias l="ls -AlF"

#
# Bash Completion
#

if [ -f /usr/local/Cellar/bash-completion/1.3/etc/bash_completion ]; then
    . /usr/local/Cellar/bash-completion/1.3/etc/bash_completion # Add bash completion (requires `brew install bash-completion`)
fi

#
# Colors
#
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
NORMAL="\[\033[0m\]"

#
# Prompt Setup
#
function parse_git_dirty() { # Mark git info with '*' if dirty
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch() { # Display git info
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " ("${ref#refs/heads/}$(parse_git_dirty)")"
}

function parse_svn_repo() { # Display svn info
  info=$(svn info 2> /dev/null) || return
  root=$(echo $info | sed -e 's/^.*Repository Root: //g' -e 's,.*/,,g' -e 's/ .*//g')
  revision=$(echo $info | sed -e 's/^.*Revision: //g' -e 's/ .*//g')
  echo " ($root:$revision)"
}

export PS1="$RED\u@\h:$GREEN\W$YELLOW\$(parse_git_branch)\$(parse_svn_repo)$NORMAL\$ " # Add the git and svn info to the prompt
