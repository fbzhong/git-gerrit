#!/bin/bash

# package information.
url="https://github.com/fbzhong/git-gerrit/tarball/master"

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
    dst_completion=/usr/local/etc/bash_completion.d/
fi

# download package.
curl -L $url > $dst

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
