#!/bin/bash

project_root=$(git rev-parse --show-toplevel)
project_url=$(git config --get remote.origin.url)

if [[ "$project_url" = "https://github.com/SuhasHebbar/vim_config.git" ]]
then
  cp -r $HOME/.vim/bin $project_root/
  cp -r $HOME/.vim/ftplugin $project_root/
  cp $HOME/.vimrc $project_root/
else
  >&2 echo "project_url=$project_url\nNot valid git repo"
fi

