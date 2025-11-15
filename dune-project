(lang dune 3.20)

(name serialport)

(generate_opam_files true)

(source
 (github dx3mod/serialport))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license MIT)

(package
 (name serialport)
 (synopsis "Serial communication library")
 (description "A cross-platform serial port library for OCaml")
 (depends ocaml)
 (tags
  (serial comport com)))

