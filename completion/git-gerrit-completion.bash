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
    local subcommands="init merge push changes apply reset update rebase patchset diff review submit abandon"
    local subcommand="$(__git_find_on_cmdline "$subcommands")"
    if [ -z "$subcommand" ]; then
        __gitcomp "$subcommands"
        return
    fi

    # set cur and words for compatiablilty.
    if [ -n "${words:-1}" ] ; then
            cur=${COMP_WORDS[COMP_CWORD]}
            words=("${COMP_WORDS[@]}")
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
    patchset)
        _git_diff
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

    if [[ -z "$remote" || "$remote" = "$cur_" ]] ; then
        __gitcomp "$(__git_remotes)"
        return
    fi

    if [[ "$refs" != "$cur_" ]] ; then
        COMPREPLY=()
        return
    fi

    __gitcomp "$(__git_gerrit_list_remote_refs "$remote" "$refs")"
    return
}

__git_gerrit_list_branches ()
{
    git branch  2>/dev/null | grep -v '*' | sort
}

__git_gerrit_list_remote_refs_by_is_remote ()
{
    local i is_hash=y
    for i in $(git ls-remote -h "$1" 2>/dev/null); do
        case "$is_hash,$i" in
        n,refs/heads/sandbox/*)
            is_hash=y
            echo "$i"
            ;;
        n,refs/heads/*)
            is_hash=y
            echo "$i"
            echo "${i#refs/heads/}"
            ;;
        y,*) is_hash=n ;;
        n,*^{}) is_hash=y ;;
        n,refs/tags/*) is_hash=y;;
        n,*) is_hash=y; ;;
        esac
    done
}

__git_gerrit_list_remote_refs ()
{
    local i remote="$1" cur_refs="$2" refs_heads="refs/heads/"

    for i in $(git branch -r 2>/dev/null | grep "$remote" | grep -v "\->"); do
        echo "${i/#$remote/refs/heads}"

        case "$i" in
        $remote/sandbox/*)
            ;;
        *)
            echo "${i#$remote\/}"
            ;;
        esac
    done
}

# alias __git_find_on_cmdline for backwards compatibility
if [ -z "`type -t __git_find_on_cmdline`" ]; then
    alias __git_find_on_cmdline=__git_find_subcommand
fi
