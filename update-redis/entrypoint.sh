#!/bin/bash

# Setup ssh
echo "### Creating File ###"
mkdir "$HOME/.ssh"
touch "$HOME/.ssh/known_hosts"

echo "### Writing Keys ###"
echo "$INPUT_SSH_PRIVATE_KEY" > "$HOME/.ssh/server_key"

echo "### Setting Permissions ###"
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/known_hosts"
chmod 600 "$HOME/.ssh/server_key"

echo "### Adding keys ###"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/server_key"
ssh-keyscan "$INPUT_DOKKU_HOST" >> "$HOME/.ssh/known_hosts"

echo "### Fetching REDIS_URL ###"
echo \
  "machine api.heroku.com
  login $INPUT_HEROKU_EMAIL
  password $INPUT_HEROKU_TOKEN
machine git.heroku.com
  login $INPUT_HEROKU_EMAIL
  password $INPUT_HEROKU_TOKEN" >"$HOME/.netrc"
export HEROKU_REDIS_URL="$(heroku redis:credentials REDIS_URL -a $INPUT_HEROKU_APP_NAME)"

echo "### Updating REDIS_URL ###"
ssh -o StrictHostKeyChecking=no dokku@$INPUT_DOKKU_HOST -- config:set -no-restart $INPUT_DOKKU_APP_NAME REDIS_URL="$HEROKU_REDIS_URL"
