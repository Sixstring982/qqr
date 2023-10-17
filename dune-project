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
   (caqti-driver-sqlite3 (>= 1.9.0))
   (dream (>= 1.0.0~alpha5))
   (producer (>= 0.2.0))
   (sqlite3 (>= 5.1.0))
   (safepass (>= 3.1))
   (tyxml (>= 4.6.0))
   (tyxml-ppx (>= 4.6.0))
   (uuidm (>= 0.9.8)))
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
