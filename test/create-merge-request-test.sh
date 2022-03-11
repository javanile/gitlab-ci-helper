#!/usr/bin/env bash
set -e -o allexport

CI_COMMIT_BRANCH=test
source ./test/bootstrap.sh

message="$(date)"
bash ./gitlab-ci-helper.sh update:file filename.txt "${message}"
bash ./gitlab-ci-helper.sh --close create:mr main "(1) merge request ${message}"
bash ./gitlab-ci-helper.sh accept:mr main
bash ./gitlab-ci-helper.sh --debug --close create:mr main "(2) merge request ${message}"
