#!/usr/bin/env bash
set -e -o allexport

source ./.env

echo "CI_PROJECT_PATH=${CI_PROJECT_PATH}"
echo "GITLAB_PRIVATE_TOKEN=${GITLAB_PRIVATE_TOKEN}"

echo ""
echo "====[ TESTING ]===="
bash ./gitlab-ci-helper.sh check:branch master
