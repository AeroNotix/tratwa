(lang dune 2.9)
(name tratwa)
(generate_opam_files true)

(package
 (name tratwa)
 (depends
   uuidm
   yojson
   ppx_deriving_yojson.runtime
  (ocaml (>= 4.13.0)))
 (synopsis "Raft implementation"))
