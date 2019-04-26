#!/usr/bin/env bash

project_root=$(git rev-parse --show-toplevel)
project_url=$(git config --get remote.origin.url)

if [[ "$project_url" \
  =~ ^(https://|git@)github.com/SuhasHebbar/vim-config((.git)?)$ ]]
then
  rsync -avh --delete $HOME/.vim/bin/ $project_root/bin
  rsync -avh --delete $HOME/.vim/ftplugin/ $project_root/ftplugin
  rsync -avh $HOME/.vimrc $project_root/.vimrc
else
  >&2 echo "project_url=$project_url is not a valid git repo"
fi

