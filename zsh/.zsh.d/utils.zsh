#!/usr/local/bin/zsh -e

copy_str() {
  if [[ $# -eq 0 ]]; then
    cat <&0
  elif [[ $# -eq 1 ]]; then
    if [[ -f "$1" ]] && [[ -r "$1" ]]; then
      cat "$1"
    else
      echo "$1"
    fi
  else
    return 1
  fi
}

lower() {
  copy_str | tr "[:upper:]" "[:lower:]"
}

upper() {
  copy_str | tr "[:lower:]" "[:upper:]"
}

ostype() {
  uname | lower
}

os_detect() {
  export PLATFORM
  case "$(ostype)" in
  *'linux'*) PLATFORM='linux' ;;
  *'darwin'*) PLATFORM='osx' ;;
  *) PLATFORM='unknown' ;;
  esac
}

is_osx() {
  os_detect
  if [[ ${PLATFORM} = "osx" ]]; then
    return 0
  else
    return 1
  fi
}

is_linux() {
  os_detect
  if [[ ${PLATFORM} = "linux" ]]; then
    return 0
  else
    return 1
  fi
}

function getExpireTime(){
  TIME=$( grep x_security_token_expires ~/.aws/credentials | awk -F "=" '{print $2}' | sed "s/ //g")
  EXPIRE=$(( $(gdate -d $TIME +%s) - $(date +%s) ))
  H=$(( $EXPIRE % 86400 / 3600 ))
  M=$(( $EXPIRE % 86400 % 3600 / 60 ))
  S=$(( $EXPIRE % 86400 % 3600 % 60 ))
  if   [ $M -le  9 ]; then
    COLOR="%F{1}"
  else
    COLOR="%F{2}"
  fi
  if [ $EXPIRE -le 0 ]; then
    export TIMER=""
  else
    export TIMER=$COLOR$(printf "%.2d:%.2d:%.2d" $H $M $S)"%f"
  fi
}

function sta(){
  SESSIONTIMER=$((${1:-"3"}*60*60))
  saml2aws login --skip-prompt --force --session-duration=$SESSIONTIMER
}

function lssh () {
  IP=$(lsec2 $@ | peco | awk -F "\t" '{print $2}')
  if [ $? -eq 0 -a "${IP}" != "" ]
  then
    echo ">>> SSH to ${IP}"
    ssh ${IP}
  fi
}

function peco-history-selection() {
  BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}

function ts() {
  tmux split-window -h
  tmux split-window -v
  tmux resize-pane -D 15
  tmux select-pane -t 1
}

function login_clusterops() {
  cd ${HOME}/.github.com/clusterops
	docker run -it --rm \
		-v ${HOME}/.aws:/root/.aws \
		-v ${PWD}:/root/clusterops \
    -e AWS_PROFILE="saml" \
		-e EDITOR="vi" \
		clusterops bash
}

function load_dev() {
  if is_osx; then
    source $(brew --prefix asdf)/asdf.sh
    D
  fi
}
