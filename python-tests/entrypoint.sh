#!/bin/sh

pip install -r requirements.txt
pip install coverage pytest

curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
chmod +x ./cc-test-reporter
./cc-test-reporter before-build

coverage run --source=bot/ -m pytest -x

coverage xml
./cc-test-reporter after-build --exit-code 0