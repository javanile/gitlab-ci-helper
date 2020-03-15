#!/usr/bin/env bash

##
# gitlab-ci-helper.sh
#
# Copyright (c) 2020 Francesco Bianco <bianco@javanile.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##

set -e

VERSION=0.0.1
GITLAB_PROJECT_API_URL="https://gitlab.com/api/v4/projects/${CI_PROJECT_NAMESPACE}%2F${CI_PROJECT_NAME}"

usage () {
    echo "Usage: ./gitlab-ci-helper.sh [OPTION]... [COMMAND] [ARGUMENT]..."
    echo ""
    echo "Support your CI workflow with useful macro."
    echo ""
    echo "List of available commands"
    echo "  create:branch NAME REF   Create new branch"
    echo ""
    echo "List of available options"
    echo "  -h, --help               Display this help and exit"
    echo "  -v, --version            Display current version"
    echo ""
    echo "Documentation can be found at https://github.com/javanile/lcov.sh"
}

options=$(getopt -n gitlab-ci-helper.sh -o vh -l version,help -- "$@")

eval set -- "${options}"

while true; do
    case "$1" in
        -v|--version) echo "gitlab-ci-helper (version ${VERSION})"; exit ;;
        -h|--help) usage; exit ;;
        --) shift; break ;;
    esac
    shift
done

##
#
##
error () {
    echo "ERROR --> $1"
    exit 1
}

##
# Ref: https://docs.gitlab.com/ee/api/branches.html#create-repository-branch
##
create_branch () {
    [[ -z "$1" ]] && error "Missing new branch name"
    [[ -z "$2" ]] && error "Missing branch ref"

    curl \
        --request POST \
        --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" \
        "${GITLAB_PROJECT_API_URL}/repository/branches?branch=$1R&ref=$2"
}

##
#
##
main () {
    [[ -z "${GITLAB_PRIVATE_TOKEN}" ]] && error "Missing or empty GITLAB_PRIVATE_TOKEN variable."

    case "$1" in
        create:branch) create_branch $2 $3 ;;
    esac
}

##
main
