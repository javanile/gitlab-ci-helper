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

VERSION=0.1.0
GITLAB_PROJECTS_API_URL="https://gitlab.com/api/v4/projects"
CI_CURRENT_PROJECT_SLUG="${CI_PROJECT_PATH//\//%2F}"
CI_CURRENT_BRANCH="${CI_COMMIT_BRANCH}"

usage () {
    echo "Usage: ./gitlab-ci-helper.sh [OPTION]... [COMMAND] [ARGUMENT]..."
    echo ""
    echo "Support your CI workflow with useful macro."
    echo ""
    echo "List of available commands"
    echo "  create:branch NAME REF        Create new branch with NAME from REF"
    echo "  create:file NAME CONTENT      Create new file with NAME and CONTENT into BRANCH"
    echo "  info                          Create new file with NAME and CONTENT into BRANCH"
    echo ""
    echo "List of available options"
    echo "  -b, --branch BRANCH      Set current branch"
    echo "  -h, --help               Display this help and exit"
    echo "  -v, --version            Display current version"
    echo ""
    echo "Documentation can be found at https://github.com/javanile/lcov.sh"
}

options=$(getopt -n gitlab-ci-helper.sh -o vh -l version,help -- "$@")

eval set -- "${options}"

while true; do
    case "$1" in
        -v|--version) echo "GitLab CI Helper [0.0.1] - by Francesco Bianco <bianco@javanile.org>"; exit ;;
        -h|--help) usage; exit ;;
        --) shift; break ;;
    esac
    shift
done

##
# Print-out error message and exit.
##
error() {
    echo "ERROR --> $1"
    exit 1
}

##
# Call CURL POST request to GitLab API.
##
ci_curl_post() {
    local url="${GITLAB_PROJECTS_API_URL}/${CI_CURRENT_PROJECT_SLUG}/$1"

    echo "POST ${url}"
    curl -XPOST -fsSL ${url} \
         -H "Content-Type: application/json" \
         -H "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" \
         --data "$2"
}

##
# Create a new branch if not exists based on current branch.
#
# Ref: https://docs.gitlab.com/ee/api/branches.html#create-repository-branch
##
ci_create_branch () {
    [[ -z "$1" ]] && error "Missing new branch name"
    [[ -z "$2" ]] && local ref="${CI_CURRENT_BRANCH}" || local ref="$2"

    ci_curl_post "repository/branches?branch=$1&ref=${ref}"
}

##
# Create a new file if not exists on current branch.
#
# Ref: https://docs.gitlab.com/ee/api/branches.html#create-repository-branch
##
ci_create_file () {
    [[ -z "$1" ]] && error "Missing file name"
    [[ -z "$2" ]] && error "Missing file content"
    #[[ -z "$3" ]] && error "Missing branch name"

    ci_curl_post "repository/files/$1" "{
        \"branch\": \"${CI_CURRENT_BRANCH}\",
        \"content\": \"$2\",
        \"commit_message\": \"Create file $1\"
    }"
}

##
# Create a new file if not exists on current branch.
#
# Ref: https://docs.gitlab.com/ee/api/branches.html#create-repository-branch
##
ci_create_merge_request () {
    [[ -z "$1" ]] && error "Missing target branch"
    [[ -z "$2" ]] && error "Missing merge request title"

    ci_curl_post "merge_requests" "{
        \"source_branch\": \"${CI_CURRENT_BRANCH}\",
        \"target_branch\": \"$1\",
        \"title\": \"Create file $2\"
    }"
}

##
# Exit with a message
##
ci_fail() {
    echo "================"
    echo ">>>   FAIL   <<<"
    echo "================"
    echo "MESSAGE: $1"
    exit 1
}

##
# Print-out useful information.
##
ci_info() {
    echo "CI_CURRENT_PROJECT_SLUG=${CI_CURRENT_PROJECT_SLUG}"
    echo "CI_CURRENT_BRANCH=${CI_CURRENT_BRANCH}"
}

##
# Main function
##
main () {
    [[ -z "$1" ]] && error "Missing command"
    [[ -z "${GITLAB_PRIVATE_TOKEN}" ]] && error "Missing or empty GITLAB_PRIVATE_TOKEN variable."

    case "$1" in
        create:branch)
            ci_create_branch $2 $3
            ;;
        create:file)
            ci_create_file $2 $3
            ;;
        create:merge-request|create:mr)
            ci_create_merge_request $2 $3
            ;;
        fail)
            ci_fail
            ;;
        info)
            ci_info
            ;;
        *)
            error "Unknown command: $1"
            ;;
    esac

    echo ""
}

## Entrypoint
main "$@"
