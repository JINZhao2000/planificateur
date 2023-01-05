.DEFAULT_GOAL=build

build:
	@dune build

doc: build
	@ODOC_WARN_ERROR=true dune build @doc

clean:
	@dune clean