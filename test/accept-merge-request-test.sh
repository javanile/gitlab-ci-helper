#!/usr/bin/env bash
set -e -o allexport

source ./test/bootstrap.sh

bash ./gitlab-ci-helper.sh accept:mr test
