#!/usr/bin/env bash

INI_FILE="${HOME}/.aws/credentials"
INI_SECTION=x_principal_arn

ACCOUNT=$(grep ${INI_SECTION} ${INI_FILE} | awk -F "=" '{print $2}' | sed "s/ //g" | awk -F ":" '{print $5}')

CFOCOM="057575985710"
pane_id="${TMUX_PANE}"
echo ${ACCOUNT} | grep -q ${CFOCOM}
if [ $? -eq 0 ]; then
  tmux set-option status-bg colour23
else
  tmux set-option status-bg default
fi

echo $ACCOUNT
