#!/usr/bin/env bash
set -e -o allexport

source ./.env

echo "CI_PROJECT_PATH=${CI_PROJECT_PATH}"
echo "GITLAB_PRIVATE_TOKEN=${GITLAB_PRIVATE_TOKEN}"

bash ./gitlab-ci-helper.sh accept:mr test
