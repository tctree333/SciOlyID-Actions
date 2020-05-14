#!/bin/sh

# Setup ssh
mkdir ~/.ssh
echo $INPUTS_SSH_PRIVATE_KEY >~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts
chmod 600 ~/.ssh/id_rsa
ssh-keyscan $INPUTS_DOKKU_HOST >>~/.ssh/known_hosts

if [$INPUTS_ENABLE_SENTRY -eq 1]; then
    echo "### ADDING SENTRY RELEASE ###"

    export SENTRY_AUTH_TOKEN="$INPUTS_SENTRY_AUTH"
    export SENTRY_ORG="$INPUTS_SENTRY_ORG"
    VERSION=$(sentry-cli releases propose-version)

    for project in $INPUTS_SENTRY_PROJECTS; do
        sentry-cli releases new -p project $VERSION
    done
    sentry-cli releases set-commits --auto $VERSION
    sentry-cli releases finalize $VERSION
fi

if [$INPUTS_ENABLE_UPDATE_REDIS -eq 1]; then
    echo "### UPDATING REDIS_URL ###"
    echo \
        "machine api.heroku.com
  login $INPUTS_HEROKU_EMAIL
  password $INPUTS_HEROKU_TOKEN
machine git.heroku.com
  login $INPUTS_HEROKU_EMAIL
  password $INPUTS_HEROKU_TOKEN" >~/.netrc

    export $HEROKU_REDIS_URL=$(heroku redis:credentials -a $INPUTS_HEROKU_APP_NAME)
    ssh -i ~/.ssh/id_rsa dokku@$INPUTS_DOKKU_HOST -- config:set -no-restart $INPUTS_DOKKU_APP_NAME REDIS_URL="$HEROKU_REDIS_URL"
fi

echo "### DEPLOYING TO DOKKU ###"
git push dokku@$INPUTS_DOKKU_HOST:$INPUTS_DOKKU_APP_NAME master
