#
# ~/.bashrc
#

#{{{ git prompt from  http://www.jonmaddox.com/2008/03/13/show-your-git-branch-name-in-your-prompt/
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="[\u@\h:\w \[\e[1;33m\]\$(parse_git_branch)\[\e[m\]]\$ "
#}}}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias myg++="g++ -Wall -O2 -g -static"

export PATH=$PATH:~/.cabal/bin
export EDITOR=/usr/bin/vim
export TERM=xterm-256color
