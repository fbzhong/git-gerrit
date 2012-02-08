#!/bin/bash

# package information.
url="https://github.com/fbzhong/git-gerrit/tarball/v0.3.0"
md5="3289ad86d22c3422701361a639d67573"

src_bin=bin
src_completion=completion

dst=/tmp/git-gerrit.latest.tar.gz
dst_bin=/usr/local/bin/
dst_completion=/etc/bash_completion.d/

# common functions.
die() {
    echo "${@}"
    exit 1
}

#Let mac user use homebrew to install.
name=$(uname)
if [ "Darwin" = "$name" ] ; then
    die "Use homebrew to install: brew install https://raw.github.com/fbzhong/homebrew-library/master/Library/git-gerrit.rb"
fi

# download package.
curl -L $url > $dst

# verify download package.
dst_md5=$(md5sum $dst | awk '{print $1}')

if [ "$md5" != "$dst_md5" ] ; then
    die "The file is corrupted, please check your network and try again."
fi

# install.
cd /tmp
extract_dir=$(tar -tzf $dst 2>/dev/null | head -1)
tar -xzf $dst
pushd $extract_dir 1>/dev/null

# copy bin.
sudo cp $src_bin/* "$dst_bin"

if [ ! -d "$dst_completion" ] ; then
    mkdir -p "$dst_completion"
fi

# copy bash-completion.
sudo cp $src_completion/* "$dst_completion"

popd 1>/dev/null

rm -rf "$extract_dir"
rm -rf "$dst"

echo "git-gerrit install success."
