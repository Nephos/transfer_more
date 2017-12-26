NAME := transfer_more
PREFIX := /usr/local

all: deps_opt build

run:
	crystal run src/transfer_more.cr
build:
	crystal build src/transfer_more.cr --stats -o $(NAME)
release:
	crystal build src/transfer_more.cr --stats --release -o $(NAME)
test:
	crystal spec
deps:
	crystal deps install
deps_update:
	crystal deps update
deps_opt:
	@[ -d lib/ ] || make deps
doc:
	crystal docs
install:
	mkdir -p $(PREFIX)/bin
	cp $(NAME) $(PREFIX)/bin/$(NAME)
uninstall:
	rm $(PREFIX)/bin/$(NAME)

.PHONY: all run build release test deps deps_update doc install uninstall
