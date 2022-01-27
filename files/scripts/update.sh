#!/usr/bin/env bash
set -xo pipefail

echo "Enter path to workspace containing repositories, RELATIVE to ~"
read path
cd ~/$path

for dir in */; do
    cd $dir
    if [ -d .git ]; then
        git pull
    fi

    # assume submodules already initialized
    if [ -f .gitmodules ]; then
        git submodule update --recursive
    fi
    cd ..
    echo
done
