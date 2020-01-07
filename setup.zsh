#!/bin/zsh -e

DOTPATH=$(pwd)
ln -s $DOTPATH/zsh/.zshrc ~/.zshrc

mkdir ~/.zsh.d
for FILE in $(find $DOTPATH/zsh/.zsh.d);
do
  FILENAME=$(basename $FILE)
  ln -s $DOTPATH/zsh/.zsh.d/$FILENAME ~/.zsh.d
done
