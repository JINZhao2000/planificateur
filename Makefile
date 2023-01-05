.DEFAULT_GOAL=build

PHASE=
FILE=

build:
	@dune build

run:
	@dune exec planificateur $(PHASE) $(FILE)

doc: build
	dune build @doc

libdoc: build
	@dune build @doc-private

test: clean build
	@dune build @runtest

clean:
	@dune clean