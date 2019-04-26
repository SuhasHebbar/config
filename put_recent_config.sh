#!/usr/bin/env bash

project_root=$(git rev-parse --show-toplevel)
project_url=$(git config --get remote.origin.url)

source $project_root/utils/utils/utils.sh

if [[ "$project_url" \
  =~ ($repo_url_regex) ]]
then
  rsync -avh --delete $project_root/bin/ $HOME/.vim/bin
  rsync -avh --delete $project_root/ftplugin/ $HOME/.vim/ftplugin
  rsync -avh $project_root/.vimrc $HOME/.vimrc 
else
  >&2 echo "project_url=$project_url\nNot valid git repo"
fi

vim +PlugInstall +qall

source $HOME/.vim/venv/bin/activate
pip3 install rope mccabe pyls-mypy pyls-black pyflakes
deactivate

