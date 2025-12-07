type t = private Miou_unix.Ownership.file_descr

val open_communication : mode:Mode.t -> string -> Miou_unix.Ownership.file_descr
val close_communication : Miou_unix.Ownership.file_descr -> unit

val with_open_communication :
  mode:Mode.t -> string -> (Miou_unix.Ownership.file_descr -> 'a) -> 'a
