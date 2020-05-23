#!/bin/sh

# Setup ssh
echo "### Creating Files ###"
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

echo "### Deploying to Dokku ###"
GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git push dokku@$INPUT_DOKKU_HOST:$INPUT_DOKKU_APP_NAME master:master --force
echo "Done!"
