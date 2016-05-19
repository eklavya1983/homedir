#!/bin/sh

# Setter/getter for fabhosts
# no args: gets host
# with args: sets the host
function fabhosts()
{
    [[ $# -eq 0 ]] && [[ ! -e ~/.fabhosts ]] && { echo "~/.fabhosts file doesn't exist"; return 1; }
    [[ $# -eq 0 ]] && [[ -e ~/.fabhosts ]] && { cat ~/.fabhosts; return 0; }

    echo "$@" | tr " " , > ~/.fabhosts
}

function fabuser()
{
    echo "root"
}

function fabpasswd()
{
    echo "passwd"
}

# Convenience wrapper around fab tool to invoke functions defined in ~/bin/fabfile.py
function fabrun()
{
    echo "fabhost: $(fabhosts)"
    fab -f ~/bin/fabfile.py -H $(fabhosts) -u $(fabuser) -p $(fabpasswd) $@
}

function fr()
{
    fabrun -- $@
}
