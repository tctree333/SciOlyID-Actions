#!/bin/sh

# Setup ssh
mkdir ~/.ssh
touch ~/.ssh/known_hosts
echo $INPUT_SSH_PRIVATE_KEY >~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts
chmod 600 ~/.ssh/id_rsa
ssh-keyscan $INPUT_DOKKU_HOST >>~/.ssh/known_hosts

if [$INPUT_ENABLE_SENTRY -eq "1"]; then
    echo "### ADDING SENTRY RELEASE ###"

    export SENTRY_AUTH_TOKEN="$INPUT_SENTRY_AUTH"
    export SENTRY_ORG="$INPUT_SENTRY_ORG"
    VERSION=$(sentry-cli releases propose-version)

    for project in $INPUT_SENTRY_PROJECTS; do
        sentry-cli releases new -p project $VERSION
    done
    sentry-cli releases set-commits --auto $VERSION
    sentry-cli releases finalize $VERSION
fi

if [$INPUT_ENABLE_UPDATE_REDIS -eq "1"]; then
    echo "### UPDATING REDIS_URL ###"
    echo \
        "machine api.heroku.com
  login $INPUT_HEROKU_EMAIL
  password $INPUT_HEROKU_TOKEN
machine git.heroku.com
  login $INPUT_HEROKU_EMAIL
  password $INPUT_HEROKU_TOKEN" >~/.netrc

    export $HEROKU_REDIS_URL=$(heroku redis:credentials -a $INPUT_HEROKU_APP_NAME)
    ssh -i ~/.ssh/id_rsa dokku@$INPUT_DOKKU_HOST -- config:set -no-restart $INPUT_DOKKU_APP_NAME REDIS_URL="$HEROKU_REDIS_URL"
fi

echo "### DEPLOYING TO DOKKU ###"
git push dokku@"$INPUT_DOKKU_HOST":"$INPUT_DOKKU_APP_NAME" master
