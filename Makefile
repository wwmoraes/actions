SHELL_FILES = $(shell find . -name "*.sh" -o -name "*.bash" -not -path "./node_modules/*")

export PREFIX=$(PWD)/test
export PACKAGES=$(PWD)/node_modules

.PHONY: all
all: lint test

.PHONY: test
test: node_modules/.bin/bats
	@node_modules/.bin/bats -r .

.PHONY: lint
lint:
	shellcheck $(SHELL_FILES)

chmod: $(SHELL_FILES)
	chmod +x $^

node_modules/.bin/bats: node_modules

node_modules: yarn.lock
	@yarn install --frozen-lockfile

yarn.lock: package.json
	@yarn install
