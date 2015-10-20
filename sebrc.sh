# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
#shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=75000


# extend path
PATH="$PATH:$HOME/.composer/vendor/bin"

# aliases
alias ls='ls --color=auto -h '
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CFha'
alias ..='cd ..'
alias cd.='cd .'
alias cd..='cd ..'
alias c.='cd .'

alias hg='history|grep -i' # history grep

function backup
{
  if [ -z $1 ]; then
    echo "Usage: $0 file"
    return 1
  fi

  dir="/var/file-backups/$(id -un)/$1/$(date +%c)"
  mkdir -p "$dir"
  cp "$1" "$1~"
  cp "$1" "$dir/$1" 
}

###
#
# local part
#
# This part is for pc-specific stuff
###

# you may want to outsource this
if [ -f ~/.sebrc-priv ]
    . ~/.sebrc-priv
fi

function proj
{
#  if [ -z $1 ]; then
#    echo "Usage: $0 file"
#    return 1
#  fi
  
  cd "${sd-/media/removable/UNTITLED}/Projekte/$@"
}


mr='/media/removable'
sd="$mr/UNTITLED"

alias sd='cd "$sd"'


# java home (for PHPStorm etc)
JAVA_HOME="$HOME/.jre"