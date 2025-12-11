type t = Miou_unix.Ownership.file_descr

val open_communication : opts:Port_options.t -> string -> t
val close_communication : t -> unit
val with_open_communication : opts:Port_options.t -> string -> (t -> 'a) -> 'a
