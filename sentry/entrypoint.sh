#!/bin/sh

echo "### ADDING SENTRY RELEASE ###"

export SENTRY_AUTH_TOKEN="$INPUT_SENTRY_AUTH"
export SENTRY_ORG="$INPUT_SENTRY_ORG"
VERSION=$(sentry-cli releases propose-version)

if [[ -z "${INPUT_SENTRY_PROJECT_2}" ]]; then
    sentry-cli releases new -p $INPUT_SENTRY_PROJECT_1 "$VERSION"
else
    sentry-cli releases new -p $INPUT_SENTRY_PROJECT_1 -p $INPUT_SENTRY_PROJECT_2 "$VERSION"
fi

sentry-cli releases set-commits --auto "$VERSION"
sentry-cli releases finalize "$VERSION"
sentry-cli releases deploys "$VERSION" new -e "Deploy to Dokku"
