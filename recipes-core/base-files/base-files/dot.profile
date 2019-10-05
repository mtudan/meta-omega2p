# Enable systemd colors
export SYSTEMD_PAGER=''

# General Aliases
alias ls="ls --color"
alias ll="ls -l"
alias la="ls -la"
alias lt="ls -lt"
alias lh="ls -lh"
alias l1="ls -1"

alias hosts="cat /etc/hosts"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias untar="tar xzvkf"
alias ip4="ip -4 addr"
alias ip6="ip -6 addr"
alias fd="find . -type d -name"
alias ff="find . -type f -name"

COL_YEL="\[\e[1;33m\]"
COL_GRA="\[\e[0;37m\]"
COL_WHI="\[\e[1;37m\]"
COL_GRE="\[\e[1;32m\]"
COL_RED="\[\e[1;31m\]"
COL_BLU="\[\e[1;34m\]"

# Bash Prompt
if test "$USER" == "root"; then
  _COL_USER=$COL_RED
  _p=" #"
else
  _COL_USER=$COL_GRE
  _p=" $"
fi

COLORIZED_PROMPT="${_COL_USER}\u${COL_WHI}@${COL_GRA}\h${COL_WHI}:\w${_p} \[\e[m\]"

case $TERM in
  linux | *term* | rxvt | screen )
    PS1="${COLORIZED_PROMPT}" ;;
  * ) 
    PS1="\u@\h:\w${_p} " ;;
esac
