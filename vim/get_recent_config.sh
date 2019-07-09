#!/usr/bin/env bash

project_root=$(git rev-parse --show-toplevel)
project_url=$(git config --get remote.origin.url)

source $project_root/utils/utils/utils.sh

if [[ "$project_url" \
  =~ ($repo_url_regex) ]]
then
  rsync -avh --delete $HOME/.vim/bin/ $project_root/bin
  rsync -avh --delete $HOME/.vim/ftplugin/ $project_root/ftplugin
  rsync -avh $HOME/.vimrc $project_root/.vimrc
else
  >&2 echo "project_url=$project_url is not a valid git repo"
fi

