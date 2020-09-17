#!/usr/bin/env bash
set -e

git config credential.helper 'cache --timeout=3600'
git add .
git commit -am "Release test"
git push

if [[ ! -d "test/fixtures/gitlab-ci-helper" ]]; then
    git clone https://gitlab.com/javanile/gitlab-ci-helper.git test/fixtures/gitlab-ci-helper
fi

cd test/fixtures/gitlab-ci-helper

date > RELEASE_TEST
git add .
git commit -am "run test"
git push