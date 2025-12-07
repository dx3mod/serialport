type t = Miou_unix.Ownership.file_descr

val open_communication : mode:Mode.t -> string -> t
val close_communication : t -> unit
val with_open_communication : mode:Mode.t -> string -> (t -> 'a) -> 'a
