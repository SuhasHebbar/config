#!/bin/bash

project_root=$(git rev-parse --show-toplevel)
project_url=$(git config --get remote.origin.url)

if [[ "$project_url" = "https://github.com/SuhasHebbar/vim_config.git" ]]
then
  rm -rvf $HOME/.vim/bin
  rm -rvf $HOME/.vim/ftplugin
  rm -rvf $HOMe/.vimrc
  cp -r $project_root/bin $HOME/.vim/ 
  cp -r $project_root/ftplugin $HOME/.vim/
  cp $project_root/.vimrc $HOME/.vimrc 
else
  >&2 echo "project_url=$project_url\nNot valid git repo"
fi
