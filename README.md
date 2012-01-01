# Git-Gerrit

A few scripts to make code review via [Gerrit Code Review](http://gerrit.googlecode.com) easier for developers.
They are improved and maintained to fit the needs of the [TYPO3](http://typo3.org) review workflow.

This project is forked from my [gerrit-tools](https://github.com/fbzhong/gerrit-tools) repo, which was originally developed by [André Arko](https://github.com/indirect/gerrit-tools), modified by [Steffen Gebert](https://github.com/StephenKing/gerrit-tools) and [Philipp Gampe](https://github.com/pgampe/gerrit-tools).

## gerrit-cherry-pick

This is a script that allows you to cherry-pick a particular patch from Gerrit, so that it can be reviewed easily. It comes from Gerrit 2.2.1.

## gerrit

Gerrit is a warpper script to execute gerrit commands via ssh.

## git-gerrit

Git-gerrit is a wrapper script to make creating, reviewing, and approving Gerrit changes very simple. In the simplest case, you can have an entire Git workflow that looks like this for people creating a new changeset:

    git gerrit push

And looks like this for people reviewing someone else's changeset:

    // show changes
    git gerrit changes

    // show change detail
    git gerrit changes 123

    // apply change for review
    git gerrit apply 123

    // verify...
    rake

    // review
    git gerrit review

    // submit
    git gerrit submit

    // reset
    git gerrit reset


### Usage

    Usage: git-gerrit [<options>] init
       or: git-gerrit [<options>] merge <branch>
       or: git-gerrit [<options>] push
       or: git-gerrit [<options>] changes [<search operators>]
       or: git-gerrit [<options>] changes [<change number>]
       or: git-gerrit [<options>] apply <change number>
       or: git-gerrit [<options>] reset [-f]
       or: git-gerrit [<options>] update
       or: git-gerrit [<options>] rebase <change number>
       or: git-gerrit [<options>] diff <patchset1> [<patchset2>]
       or: git-gerrit [<options>] review
       or: git-gerrit [<options>] submit
       or: git-gerrit [<options>] abandon

    init
      init the gerrit hook.

    merge <branch>
      Merge the current gerrit branch with the <branch>, with squashing commit.

    push
      Pushes a single patch (or - if confirmed - multiple patches) to gerrit for review.
      If you are not on a review branch, you need to confirm the branch to push to and
      you may choose a topic.

      If your HEAD is a tracking branch $this will promt to reset it to the remote
      branch after successfully pushing the changeset.
      If you are working on a non-tracking branch, that branch will be left alone.

      If you are on a review branch or if you have specified a change number with -c
      (see above), the current patch will be added as a new patchset, following
      the same reset rules as above.

      NOTE: If the BROWSER environment variable is set, the Gerrit page for the pushed
      change will be opened in that browser (e.g. "open" or "/usr/local/bin/firefox"),
      otherwise the URL will be displayed.

    changes [<change number>]
      Show the detail of specific <change number>.

    changes [<search operators>]
      Show the changes information, <status:open> by default. The <search operators> are
      the same with the operators of Gerrit Code Review - Searching Changes.

      The following are particial <search operators>:
          commit:'SHA1'
          status:open
          status:merged
          status:abandoned

      For more information of <search operators>, please refer to the Gerrit Documentation
      Gerrit Code Review - Searching Changes

    apply <change number>
      Applies the latest patch for the change at <change number> on top of the current
      branch, if it's a tracking branch, or master on a branch named for <change number>,
      allowing you to review the change.

    reset [-f]
      Removes the current change branch created by the "start" subcommand and switches
      back to tracking branch.
      Use -f to reset if the current branch has uncommitted changes, otherwise reset will
      refuse to do this.
      If the the current branch does not start with "r" followed by an integer, nothing
      will be done and $this exists with an error.

    update
      Updates the review branch that you are currently on to the latest patch.

    rebase [<change number>]
      Rebases the latest patch for a given change number (or the current change branch)
      against tracking branch, then submits it as a new patch to that change.
      This helps deal with Gerrit's "Your change could not be merged due to a path
      conflict" error message.

    diff [<patch number> [<patch number>]]
      Depending of the number of arguments, displays a diff of
        (0) the last two patchsets.
        (1) the given patchset und the last patchset.
        (2) the given patchsets. You can swap the two numbers to get an inverse diff.
        (3) a specific change specified with <change> <patchset1> <patchset2>. Giving a
            change number means you can use this command without being on a review branch.

    review
      Review the current patch but does not merge it.
      You will be promted for your vote and for a message.

    submit
      Submit the current patch to merge it.

    abandon
      Abandon the current patch.


## Installation

You can either install it locally for your user only or you can install it globally for all users.

First cd into the downloaded directoy into the subdir bin:

	cd git-gerrit/bin/

### Local install

If the directory ~/bin does not exist, create it in your in your home path:

	if [[ ! -d $HOME/bin ]]; then mkdir $HOME/bin; fi

Now check if your $PATH variable already contains that path or add it do ~/.bashrc:

	if [[ ! $PATH =~ $HOME/bin ]]; then echo -e "\nexport PATH=\$PATH:\$HOME/bin" >> $HOME/.bashrc; source $HOME/.bashrc; fi

Finally symlink all files (you need to be in git-gerrit/bin/) and make them executable:

	for i in *; do ln -s `pwd`/$i $HOME/bin/$i; chmod +x $i; done

Check if all worked by running:

	cd ; git gerrit

It will print "git-gerrit can only be run from a git repository." in red (unless your home directory is already a git repository ;) )

### Global install

First become root:

	sudo su

Then you can either create the symlinks like above (make sure to be in git-gerrit bin) or you can cp the files:

    for i in *; do ln -s `pwd`/$i /bin/$i; chmod +x $i; done

or

	for i in *; do cp -u $i /bin/; chmod +x /bin/$i; done

Now quit root:

	exit

Finally check if it worked by running:

	cd ; git gerrit

It will print "git-gerrit can only be run from a git repository." in red (unless your home directory is already a git   repository ;) )

### Homebrew install for Mac OS X

    brew install https://raw.github.com/fbzhong/homebrew-library/master/Library/git-gerrit.rb


## Bash Completion

 Bash completion support for [git-gerrit](https://github.com/fbzhong/git-gerrit)

### Installation

 To achieve git-gerrit completion nirvana:

  0. Install git-completion.

  1. Install this file. Either:

     a. Place it in a `bash-completion.d` folder:

        * /etc/bash-completion.d
        * /usr/local/etc/bash-completion.d
        * ~/bash-completion.d

     b. Or, copy it somewhere (e.g. ~/.git-gerrit-completion.bash) and put the following line in
        your .bashrc:

            source ~/.git-gerrit-completion.bash

  2. If you are using Git < 1.7.1: Edit git-completion.sh and add the following line to the giant
     $command case in _git:

         gerrit)        _git_gerrit ;;


## Contributing

Feel free to fork and send a pull request if you think you've improved anything.
