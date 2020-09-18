#!/bin/zsh -e

: 'setup environment' && {
  export DOTPATH=$(pwd)
  mkdir ~/.zsh.d
  mkdir ~/.tmux
}

: 'install zshrc' && {
  ln -s $DOTPATH/zsh/.zshrc ~/.zshrc
  ln -s $DOTPATH/zsh/.zshenv ~/.zshenv
  for FILE in $(find $DOTPATH/zsh/.zsh.d -type f);
  do
    FILENAME=$(basename $FILE)
    echo load $FILENAME ...
    ln -s $DOTPATH/zsh/.zsh.d/$FILENAME ~/.zsh.d/$FILENAME
  done
}

: 'install tmux' && {
  ln -s $DOTPATH/tmux/.tmux.conf ~/.tmux.conf
  for FILE in $(find $DOTPATH/tmux/.tmux -type f);
  do
    FILENAME=$(basename $FILE)
    echo load $FILENAME ...
   ln -s $DOTPATH/tmux/.tmux/$FILENAME ~/.tmux/$FILENAME
  done
}
