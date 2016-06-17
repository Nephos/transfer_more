all: build

build: deps_opt
	crystal compile -s src/transfer_more.cr

release: deps_opt
	crystal compile -s --release src/transfer_more.cr

deps:
	shards install

deps_opt:
	@[ -d libs/ ] || make deps

test:
	crystal spec

doc:
	crystal docs && echo "Documentation built in doc/index.html"

.PHONY: all build release deps deps_opt test doc
