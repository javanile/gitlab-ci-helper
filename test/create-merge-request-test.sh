#!/usr/bin/env bash
set -e -o allexport

CI_COMMIT_BRANCH=test
source ./test/bootstrap.sh



bash ./gitlab-ci-helper.sh --debug create:mr main "test merge request"
