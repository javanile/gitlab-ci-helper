
.PHONY: test

push:
	git add .
	git commit -am "push"
	git push

test: push
	bash test/test.sh
