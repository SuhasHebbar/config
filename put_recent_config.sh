#!/usr/bin/env bash

project_root=$(git rev-parse --show-toplevel)
project_url=$(git config --get remote.origin.url)

if [[ "$project_url" = "https://github.com/SuhasHebbar/vim-config.git" \
  || "$project_url" = "git@github.com:SuhasHebbar/vim-config.git" ]]
then
  rsync -avh --delete $project_root/bin/ $HOME/.vim/bin
  rsync -avh --delete $project_root/ftplugin/ $HOME/.vim/ftplugin
  rsync -avh $HOME/.vimrc $project_root/.vimrc
else
  >&2 echo "project_url=$project_url\nNot valid git repo"
fi

vim +PlugInstall +qall

source $HOME/.vim/venv/bin/activate
pip3 install rope mccabe pyls-mypy pyls-black pyflakes
deactivate

