#!/usr/bin/env bash

source ./.env

echo "====[ ENVIRONMENT ]===="
echo "CI_PIPELINE_ID=${CI_PIPELINE_ID}"
echo "CI_PROJECT_PATH=${CI_PROJECT_PATH}"
echo "CI_COMMIT_BRANCH=${CI_COMMIT_BRANCH}"
echo "GITLAB_PRIVATE_TOKEN=${GITLAB_PRIVATE_TOKEN}"

echo ""
echo "====[ TESTING ]===="
