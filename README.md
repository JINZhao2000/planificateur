# A travel planner
## 1. Environment

`dune 3.6.1` 

`ocaml 4.14.1` 

`odoc 2.1.1` 

## 2. Usage

```bash
dune exec planificateur <phase> <file>
```

or

```bash
make run PHASE=<phase> FILE=<file>
```

where phase can be `1` , `2` , `3` 

## 3. Documentation

### 3.1 main file

```bash
dune build @doc
```

or

```bash
make doc
```

The doc file can be find in `./_build/default/_doc/_html/index.html`

### 3.2 libs

```bash
ODOC_WARN_ERROR=false dune build @doc-private
```

or

```bash
make libdoc
```

if there is an error like
```
File "planificateur__Model.cmti":   
Warning: Couldn't find the following modules:
  Stdlib
File "../../lib/.planificateur.objs/byte/planificateur.odoc":
Warning: Couldn't find the following modules:
  Stdlib
File "../../lib/.planificateur.objs/byte/planificateur.odoc":
Warning: Failed to lookup type unresolvedroot(Stdlib__Set).Make(unresolvedroot(Stdlib).Int).t Parent_module: Unresolved apply
File "../../lib/.planificateur.objs/byte/planificateur.odoc":
Warning: Failed to lookup type unresolvedroot(Stdlib__Map).Make(unresolvedroot(Stdlib).String).t Parent_module: Unresolved apply
File "../../lib/.planificateur.objs/byte/planificateur.odoc":
Warning: Failed to lookup type unresolvedroot(Stdlib__Set).Make(unresolvedroot(Stdlib).String).t Parent_module: Unresolved apply
```

Don't worry, it is juste a bug of odoc in dune

The doc file can be find in `./_build/default/_doc/_html/planificateur@*/Planificateur/index.html`

## 4 Test
run
```bash
make test
```

To test the operations on graph data structure.