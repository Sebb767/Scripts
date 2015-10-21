# No Shebang here - should work for bash and zsh (and maybe other shells)
# This little helper script contains a lot of aliases and helpers I created with
# years of shell usage. Before using this you may want to read through the script
# and fit it to your own needs. 
# This is meant to replace the .bashrc/.zshrc except for shell-specific stuff 
# (like prompts). It's used with zsh + ohmyzsh currently, so it is guaranteed
# to work with it. It should work with bash also, however.
#
# (c) Sebastian Kaim, 2015

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
#shopt -s histappend

# increase the history size
# for the actual meaning of these values see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=75000


# extend path
PATH="$PATH:$HOME/.composer/vendor/bin"

# default bash aliases
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
# This part is for device-specific stuff
###

# you may want to outsource this
if [ -f "~/.sebrc-priv" ]; then
    . "~/.sebrc-priv"
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