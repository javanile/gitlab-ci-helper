
.PHONY: test

push:
	git config credential.helper 'cache --timeout=3600'
	date > PUSH
	git add .
	git commit -am "push"
	git push

## -------
## Testing
## -------
test: push
	bash test/release-test.sh

test-release: push
	bash test/release-test.sh

test-accept-merge-request:
	bash test/accept-merge-request-test.sh

test-create-merge-request:
	bash test/create-merge-request-test.sh

test-check-branch:
	@bash test/check-branch-test.sh

test-create-file:
	@bash test/create-file-test.sh

test-list-pipelines:
	@bash test/list-pipelines-test.sh

test-wait-pipelines:
	@bash test/wait-pipelines-test.sh

test-git-clone:
	@bash test/git-clone-test.sh

test-git-snapshot:
	@bash test/git-snapshot-test.sh

test-help:
	@bash gitlab-ci-helper.sh --help
