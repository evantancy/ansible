#!/usr/bin/env bash

# necessary on ubuntu
export TERMINAL=gnome-terminal

GOGH_PATH="$HOME/install_dir/gogh"
cd "$GOGH_PATH" && \
for file in themes/*; do
    if [[ "$file" == *.sh ]]; then
        chmod 755 "$file"
        ./"$file"
    fi
done
