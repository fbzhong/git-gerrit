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
	*)
		COMPREPLY=()
		;;
	esac
}

__git_gerrit_merge ()
{
	__gitcomp "$(__git_gerrit_list_branches)"
}

__git_gerrit_list_branches ()
{
	git branch  2>/dev/null | grep -v '*' | sort
}

# alias __git_find_on_cmdline for backwards compatibility
if [ -z "`type -t __git_find_on_cmdline`" ]; then
	alias __git_find_on_cmdline=__git_find_subcommand
fi
