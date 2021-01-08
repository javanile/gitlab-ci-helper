
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

test-accept-merge-request:
	bash test/accept-merge-request-test.sh
