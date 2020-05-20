#!/bin/bash

set -e

local SSH_PATH="$HOME/.ssh"

mkdir -p "$SSH_PATH"
touch "$SSH_PATH/known_hosts"

echo "$INPUT_SSH_PRIVATE_KEY" > "$SSH_PATH/deploy_key"

chmod 700 "$SSH_PATH"
chmod 600 "$SSH_PATH/known_hosts"
chmod 600 "$SSH_PATH/deploy_key"

eval $(ssh-agent)
ssh-add "$SSH_PATH/deploy_key"

ssh-keyscan -t rsa $INPUT_DOKKU_HOST >> "$SSH_PATH/known_hosts"

echo "+++++++++++++++++++RUNNING BEFORE SSH+++++++++++++++++++"
ssh -o StrictHostKeyChecking=no root@$INPUT_DOKKU_HOST ls
echo "+++++++++++++++++++RUNNING BEFORE SSH+++++++++++++++++++"