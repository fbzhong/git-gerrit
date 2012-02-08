# Git-Gerrit

A few scripts to make code review via [Gerrit Code Review](http://gerrit.googlecode.com) easier for developers.
They are improved and maintained to fit the needs of the [TYPO3](http://typo3.org) review workflow.

This project is forked from my [gerrit-tools](https://github.com/fbzhong/gerrit-tools) repo, which was originally developed by [André Arko](https://github.com/indirect/gerrit-tools), modified by [Steffen Gebert](https://github.com/StephenKing/gerrit-tools) and [Philipp Gampe](https://github.com/pgampe/gerrit-tools).

## Change Logs

    v0.3.0
        + squashing push commit to refs/changes/<number> in review branch.
        + add --all-approvals in changes command.
        - remove rebase command.
        * bug fixing.

    v0.2.0
        + patchset command.
        + more bash completion support.
        + installation scripts.
        * bug fix.

    v0.1.0 fork from gerrit tools.

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

    // show patchset diff.
    git gerrit patchset

    // verify...
    rake

    // review
    git gerrit review

    // submit
    git gerrit submit

    // reset
    git gerrit reset

When we have to update and re-submit the changeset according to the code review result, we can do like that:

    // apply change for review
    git gerrit apply 123

    // let's update the code and commit locally, just like development.
    vim ... ; git commit ; ...

    // ok, time to submit changeset again.
    git gerrit push
    // your changes are already submit to gerrit.

    // update current review branch if you press n before.
    git gerrit update

### Usage

    Usage: git-gerrit [<options>] init
       or: git-gerrit [<options>] open [<change number>]
       or: git-gerrit [<options>] merge <branch>
       or: git-gerrit [<options>] push [<repository>] [<refspec>]
       or: git-gerrit [<options>] changes [<search operators>]
       or: git-gerrit [<options>] changes [<change number>]
       or: git-gerrit [<options>] apply <change number>
       or: git-gerrit [<options>] reset [-f]
       or: git-gerrit [<options>] update
       or: git-gerrit [<options>] patchset [<git-diff options>] [<commit>]
       or: git-gerrit [<options>] diff <patchset1> [<patchset2>]
       or: git-gerrit [<options>] review
       or: git-gerrit [<options>] submit
       or: git-gerrit [<options>] abandon

    init
      Init the gerrit hook.

    open
      Open current change or <change number> in browser, if the BROWSER environment
      variable is set. Otherwise the URL will be displayed.

    merge <branch>
      Merge the current gerrit branch with the <branch>, with squashing commit.

    push [<repository>] [<refspec>]
      Pushes a single patch (or - if confirmed - multiple patches) to <repository> <refspec> for review.
      If you are not on a review branch, you need to confirm the <refspec> to push to and
      you may choose a topic.

      If you are not on a review branch, $this will execute 'git pull --rebase' to make sure
      your HEAD is up to date.

      If you are on a review branch , the current patch will be added as a new patchset, following
      the same reset rules as above.

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
      Gerrit Code Review - Searching Changes http://gerrit.googlecode.com/svn/documentation/2.2.1/user-search.html

    apply <change number>
      Applies the latest patch for the <change number> change on "upstream" of the current
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

    patchset [<git-diff options>] [<commit>]
        Display a diff between the top of previous branch and <commit>. <commit> will
        be HEAD when <commit> is not specified.

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

### Bash Completion

By referencing the project [git-flow-completion](https://github.com/bobthecow/git-flow-completion), I do implement a bash completion script git-gerrit-completion.bash.

## Installation (Latest Release Version)

### Mac OS X

    brew install https://raw.github.com/fbzhong/homebrew-library/master/Library/git-gerrit.rb

### Linux

    curl https://raw.github.com/fbzhong/git-gerrit/master/install.sh | bash

## Installation (Latest Development Version)

### Mac OS X and Linux

    curl https://raw.github.com/fbzhong/git-gerrit/master/develop.sh | bash

or clone to local, then

    bash install_local.sh

## Contributing

Feel free to fork and send a pull request if you think you've improved anything.

##New BSD License

Copyright (c) 2012, Robin Zhong <fbzhong@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Robin Zhong nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Credit

* [André Arko](https://github.com/indirect/gerrit-tools)

* [Steffen Gebert](https://github.com/StephenKing/gerrit-tools)

* [Philipp Gampe](https://github.com/pgampe/gerrit-tools).

* [Justin Hileman](https://github.com/bobthecow/git-flow-completion)
