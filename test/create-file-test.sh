#!/usr/bin/env bash
set -e -o allexport

source ./test/bootstrap.sh

bash ./gitlab-ci-helper.sh create:file filename.txt content-of-file --branch test2
