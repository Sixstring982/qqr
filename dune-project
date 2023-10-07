(lang dune 3.11)

(name qqr)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name qqr)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends 
   ocaml 
   dune 
   (dream (>= 1.0.0~alpha5))
   (producer (>= 0.1.0))
   (sqlite3 (>= 5.1.0))
   (uuidm (>= 0.9.8))
   (tyxml (>= 4.6.0))
   (tyxml-ppx (>= 4.6.0)))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
