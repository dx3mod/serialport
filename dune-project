(lang dune 3.20)

(name serialport)

(version 0.1)

(generate_opam_files true)

(source
 (github dx3mod/serialport))

(authors "Mikhail Lopatin <dx3mod@bk.ru>")

(maintainers "Mikhail Lopatin <dx3mod@bk.ru>")

(license MIT)

(package
 (name serialport)
 (synopsis "Serial communication library")
 (description "A cross-platform serial port library for OCaml")
 (depends
  (ocaml
   (>= 4.14)))
 (tags
  (serial comport com unix)))
