# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Show current Git branch on bash prompt
source /etc/bash_completion.d/git
PS1="[\[\033[32m\]\w]\[\033[0m\]\$(__git_ps1)\n\[\033[1;36m\]\u\[\033[32m\]$ \[\033[0m\]"

export PATH=$PATH:/home/nbayyana/bin

# my aliases
alias synctime='sudo ntpdate -s time.nist.gov'
alias ta='tmux attach -t'
alias fn='find -name'
alias pactor='cd ~/playground/cpp/test_fbthrift/src'
alias fastb='make fastb=1 threads=5 CCACHE=1 DONT_UPDATE_BUILD=1 skip-devsetup=true'
alias fastbr='make BUILD=release fastb=1 threads=5 CCACHE=1 DONT_UPDATE_BUILD=1 skip-devsetup=true'
alias diskusage="du -h . | grep '[0-9\.]\+G'"
alias lognormal="egrep '\[error|\[warning|\[normal'"
alias logwarn="egrep '\[error|\[warning'"
alias logerr="egrep '\[error'"
alias logmigration="egrep '\[migrate|DmMigrationSrc|DmMigrationDst'"
alias logsrcmigration="egrep 'DmMigrationSrc'"
alias logdstmigration="egrep 'DmMigrationDst'"
alias logcrash="egrep -A5 'print_stacktrace'"
alias logvg="egrep 'VolumeGroupHandle'"
alias psdm="ps -ef | grep 'DataMgr'"
alias filtertrace="egrep -v '\[trace\]'"
alias maker="make BUILD=release"

ulimit -c unlimited

#so as not to be disturbed by Ctrl-S ctrl-Q in terminals:
stty -ixon

function tailwarn()
{
	tail -f $@ | egrep '\[warning|\[error'
}

function makepkg()
{
    if [[ "$1" == "release" ]]; then
        echo "Packaging release build"
        sudo make package fds-platform BUILD_TYPE=release
    else
        echo "Packaging debug build"
        sudo make package fds-platform BUILD_TYPE=debug
    fi 
}

function deploy()
{
	sudo scripts/deploy_fds.sh $1 local
}

function vglog()
{
    local usage="$FUNCNAME vgid file"
    [[ $# -ne 2 ]] && { echo "$usage"; return 1; }
    local id=$1
    shift
    egrep "VolumeGroupHandle: $id" $@
}

function coroner()
{
    local usage="$FUNCNAME untar <coroner>"
    case "$1" in
        untar)
            cd ~/bin
            fab -H fre-dump -u share -p share untarcoroner:$2
            cd -
            ;;
        *)
            echo "${usage}"
            return 1
            ;;
    esac
}

function refactorcc()
{
    local pattern
    local replacement
    local applyAll
    local usage="$FUNCNAME [-a] findpattern replacepattern"

    case $# in
        2)
            pattern=$1
            replacement=$2
            ;;
        3)
            [[ $1 = "-a" ]] && { echo "apply all set"; applyAll="true"; } || { echo "${usage}"; return 1; }
            pattern=$2
            replacement=$3
            ;;
        *)
            echo "${usage}"
            return 1
            ;;
    esac

	local files=$(ag -l ${pattern} | egrep '*\.c|*\.h|*\.tcc')
    local options=("apply" "skip" "edit" "quit")

	for f in ${files}
	do
        echo -e "${COL_GREEN}${f}:${COL_RESET}"

        [[ ! -z ${applyAll} ]] && { sed -i s/"${pattern}"/"${replacement}"/g "${f}"; continue; }

        ag ${pattern} ${f}
        
        select opt in "${options[@]}"
        do
            case $opt in
                "apply")
                    sed -i s/"${pattern}"/"${replacement}"/g "${f}"
                    break
                    ;;
                "skip")
                    break
                    ;;
                "edit")
                    vi ${f}
                    break
                    ;;
                "quit")
                    return
                    ;;
            esac
        done

        echo ""
	done
}

source ~/bin/scsi.sh
source ~/bin/fab.sh
