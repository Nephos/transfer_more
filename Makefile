all: build
build: deps_opt
	@crystal build -s src/transfer_more.cr
release: deps_opt
	@crystal build -s --release src/transfer_more.cr
update:
	@shards update
install:
	@shards install
deps_opt:
	@[ -d libs/ ] || make install
test:
	@crystal spec
doc:
	@crystal docs && echo "Documentation built in doc/index.html"

.PHONY: all build release deps deps_opt test doc
