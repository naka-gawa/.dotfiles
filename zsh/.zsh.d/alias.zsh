#!/usr/local/bin/zsh -e

: 'Global alias' && {
  # color setting
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'

  # common aliases
  alias rm='rm -i'
  alias cp='cp -i'
  alias mv='mv -i'
  alias mkdir='mkdir -p'
  alias tf='terraform'
  alias ..="cd .."
  alias ...="cd ../.."
  alias ....="cd ../../.."
  alias .....="cd ../../../.."
}

: 'Alias for ls or exa' && {
  if is_osx; then
    if type gdircolors > /dev/null 2>&1; then
      abbrev-alias ls='ls -G'
    fi
  elif is_linux; then
    if type dircolors > /dev/null 2>&1; then
      abbrev-alias ls='ls --color=auto'
    fi
  fi
  if (($+commands[exa])); then
    alias ls="exa -F"
    alias ll="exa -hlBFS"
    alias ld="exa -ld"
    alias la="exa -aF"
  else
    abbrev-alias ll="ls -hlS"
    abbrev-alias ld="echo 'Not found ld command.'"
    abbrev-alias la="ls -la"
  fi
}

: 'Alias for tmux' && {
  if (($+commands[tmux])); then
    alias t='tmux new -s "$(date +%Y-%m-%d_%H-%M-%S)"'
    alias tl='tmux ls'
  fi
}

: 'Alias for aws' && {
  alias lsec2='lsec2 --region=ap-northeast-1'
}

: 'Alias for git' && {
  if (($+commands[git])); then
    alias ga='git add'
    alias gc='git commit -m'
    alias gp='git push'
  fi
}

: 'Alias for kubernetes config' && {
  if (($+commands[kubectl])); then
    alias k='kubectl'
    alias kc='kubectx'
    alias kn='kubens'
  fi
}

: 'Alias for vim' && {
  alias vi='vim'
  alias view='vim -R'
}
