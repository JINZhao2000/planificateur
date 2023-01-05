(lang dune 3.5)

(name planificateur)

(generate_opam_files true)

(source
 (github JINZhao2000/projet-ipf-2022))

(authors "Zhao JIN")

(maintainers "Zhao JIN")

(license "Apache License 2.0")

(package
 (name planificateur)
 (synopsis "Planner")
 (description "A travel planner in a Martian base")
 (depends ocaml dune)
 (tags
  ("graph")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
