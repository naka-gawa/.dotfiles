#!/usr/bin/env bash

ZSHV="$ZSHV"

function main() {
  case "$1" in
    "install")
      if [ "$(uname)" == 'Darwin' ]; then
        plistchange
      elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        :
      else
        echo "Your platform ($(uname -a)) is not supported."
        exit 1
      fi
      install
      ;;
    "clean")
      clean
      ;;
    *)
      echo "$0: illegal command \"$1\" "
      usage
      ;;
  esac
}

function usage() {
  echo "Usage: $0 [COMMANDS]"
  echo ""
  echo "Argument:"
  echo "help   : Show this message"
  echo "install: Install .dotfiles"
  echo "clean  : Remove temporary files"
}

function plistchange() {
  echo "[INFO]plist Change"
  # GeneralSetting
  sudo pmset -a standbydelay 86400
  sudo nvram SystemAudioVolume=" "
  sudo systemsetup -setrestartfreeze on
  sudo systemsetup -setcomputersleep Off > /dev/null
  defaults write com.apple.finder AppleShowAllFiles -bool YES
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write com.apple.CrashReporter DialogType -string "none"
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
  defaults write -globalDomain com.apple.mouse.scaling -float 3.0
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE H:mm'

  # Dock
  defaults write com.apple.dock mineffect -string "scale"
  defaults write com.apple.dock show-process-indicators -bool true
  defaults write com.apple.dock static-only -bool true
  defaults write com.apple.dock launchanim -bool false
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dashboard mcx-disabled -bool true

  # Finder
  defaults write com.apple.finder DisableAllAnimations -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write NSGlobalDomain com.apple.springing.enabled -bool true
  defaults write NSGlobalDomain com.apple.springing.delay -float 0
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  chflags nohidden ~/Library
  sudo chflags nohidden /Volumes
}

function install() {
  cd ~
  echo "[INFO].DOTFILES COPY"
  cp -p ~/.dotfiles/tmux/.tmux.conf ~
  cp -p ~/.dotfiles/zsh/.zshrc ~
  cp -p ~/.dotfiles/vim/.vimrc ~

  if [ "$(uname)" == 'Darwin' ]; then

    echo "[INFO]APP INSTALL"
    brew tap Homebrew/bundle

    echo "[INFO]COLORSCHEME DOWNLOAD"
    mkdir ~/scheme && \
      curl https://raw.githubusercontent.com/Arc0re/Iceberg-iTerm2/master/iceberg.itermcolors -o ~/scheme/iceberg.itermcolors
    mkdir -p ~/.vim/color && \
      cd $_ && \
      curl https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim -o ~/.vim/color/iceberg.vim
    cd ~

  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

    echo "[INFO]APP INSTALL"
      cd ~
      yum install -y ncurses-devel wget
      yum groupinstall -y "Development"
      cd /usr/local/src
      wget https://sourceforge.net/projects/zsh/files/zsh/$ZSHV/zsh-$ZSHV.tar.xz/download -O zsh-$ZSHV.tar.xz && \
        tar xvf zsh-$ZSHV.tar.xz && \
        cd zsh-$ZSHV && \
        ./configure --enable-multibyte && \
        make && make install
      echo /usr/local/bin/zsh >> /etc/shells && \
        chsh -s /usr/local/bin/zsh
      curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | /usr/local/zsh
      cd /usr/local/src && git clone https://github.com/vim/vim.git && cd vim/src && make && make install
      cd ~

    echo "[INFO]COLORSCHEME DOWNLOAD"
    mkdir -p ~/.vim/color && \
      cd $_ && \
      curl https://raw.githubusercontent.com/cocopon/iceberg.vim/master/colors/iceberg.vim -o ~/.vim/color/iceberg.vim
    cd ~

  else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
  fi

  echo "[INFO]FONT DOWNLOAD"
  git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && \
    ./install.sh && \
    cd ../ && \
    rm -rf fonts && \
    cd ~

  cd /usr/local/bin
  if [ "$(uname)" == 'Darwin' ]; then

    echo "[INFO]POWERLINE-GO DOWNLOAD"
    cd /usr/local/bin
    wget https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-darwin-amd64
    mv powerline-go-darwin-amd64 powerline-go
    chmod +x /usr/local/bin/powerline-go
    cd ~

  elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then

    echo "[INFO]POWERLINE-GO DOWNLOAD"
    cd /usr/local/bin
    wget https://github.com/justjanne/powerline-go/releases/download/v1.11.0/powerline-go-linux-amd64
    mv powerline-go-linux-amd64 powerline-go
    chmod +x /usr/local/bin/powerline-go
    cd ~

  else
    echo "Your platform ($(uname -a)) is not supported."
    exit 1
  fi
}

if [ $# -eq 0 ]; then
  usage
  exit 1
else
  main $1
  exit 0
fi
