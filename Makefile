all: deps_opt build
run:
	@crystal run src/transfer_more.cr
build: deps_opt
	@crystal build -s src/transfer_more.cr
release: deps_opt
	@crystal build -s --release src/transfer_more.cr
deps:
	@shards install
deps_update:
	@shards update
deps_opt:
	@[ -d libs/ ] || make deps
test:
	@crystal spec
doc:
	@crystal docs && echo "Documentation built in doc/index.html"

.PHONY: all build release deps deps_update deps_opt test doc
