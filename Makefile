NAME	   := DotfileInstaller
VERSION  := 1.0.0

.PHONY: install clean

install:
	/bin/bash ./setup.sh install

clean:
	/bin/bash ./setup.sh clean

zshchange:
	/bin/cp -i ./zsh/.zshrc ~/.zshrc

tmuxchange:
	/bin/cp -i ./tmux/.tmux.conf ~/.tmux.conf

