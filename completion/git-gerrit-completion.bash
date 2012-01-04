#!bash
#
# git-gerrit-completion
# ===================
#
# Bash completion support for [git-gerrit](https://github.com/fbzhong/git-gerrit)
#
#
# Installation
# ------------
#
# To achieve git-gerrit completion nirvana:
#
#  0. Install git-completion.
#
#  1. Install this file. Either:
#
#     a. Place it in a `bash-completion.d` folder:
#
#        * /etc/bash-completion.d
#        * /usr/local/etc/bash-completion.d
#        * ~/bash-completion.d
#
#     b. Or, copy it somewhere (e.g. ~/.git-gerrit-completion.bash) and put the following line in
#        your .bashrc:
#
#            source ~/.git-gerrit-completion.bash
#
#  2. If you are using Git < 1.7.1: Edit git-completion.sh and add the following line to the giant
#     $command case in _git:
#
#         gerrit)        _git_gerrit ;;
#
#
# The Fine Print
# --------------
#
# Copyright (c) 2012 [Fubai Zhong](https://github.com/fbzhong)
#
# Distributed under the [MIT License](http://creativecommons.org/licenses/MIT/)
#
# Credit
# --------------
#
# Thank [Justin Hileman](http://justinhileman.com) for https://github.com/bobthecow/git-flow-completion/
#

_git_gerrit ()
{
	local subcommands="init merge push changes apply reset update rebase diff review submit abandon"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi

	case "$subcommand" in
	merge)
		__git_gerrit_merge
		return
		;;
    push)
        __git_gerrit_push
        return
        ;;
	*)
		COMPREPLY=()
		;;
	esac
}

__git_gerrit_merge ()
{
	__gitcomp "$(__git_gerrit_list_branches)"
}

__git_gerrit_push ()
{
	local cur_="$cur" remote="${words[3]}" refs="${words[4]}"

    if [ -z "$remote" ] ; then
        __gitcomp "$(__git_remotes)"
        return
    fi

    __gitcomp "$(__git_gerrit_list_remote_refs "$remote" "$refs")"
    return
}

__git_gerrit_list_branches ()
{
	git branch  2>/dev/null | grep -v '*' | sort
}

__git_gerrit_list_remote_refs ()
{
	local cmd i is_hash=y refs_heads="refs/heads/"
    if [ "$2" = "$refs_heads" ] ; then
        local is_heads=y
    fi
	for i in $(git ls-remote -h "$1" 2>/dev/null); do
		case "$is_hash,$i" in
        n,refs/heads/sandbox/*)
            is_hash=y
            echo "$i"
            ;;
		n,refs/heads/*)
			is_hash=y
            if [ "$is_heads" = "y" ] ; then
                echo "$i"
            else
                echo "refs/for/${i#refs/heads/}"
            fi
			;;
		y,*) is_hash=n ;;
		n,*^{}) is_hash=y ;;
		n,refs/tags/*) is_hash=y;;
		n,*) is_hash=y; ;;
		esac
	done

    if [ "$is_heads" != "y" ] ; then
        echo "$refs_heads"
    fi
}

# alias __git_find_on_cmdline for backwards compatibility
if [ -z "`type -t __git_find_on_cmdline`" ]; then
	alias __git_find_on_cmdline=__git_find_subcommand
fi
