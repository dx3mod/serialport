(** The module provides a simple synchronization interface for non-concurrent
    programs, as well as a {{!Platform_depend.S}low-level native abstraction}
    for setting up serial ports and {{!Mode}configuring} them. *)

type t
(** Interface for a opened {{!Platform_depend.S.serial_port}serial port}. *)

val open_communication : mode:Mode.t -> string -> t
(** [open_communication ~mode port_location] open opens the
    {{!Platform_depend.S.serial_port}serial port} using the specified
    {{!Mode}[mode]s} configuration. *)

val with_open_communication : mode:Mode.t -> string -> (t -> 'a) -> 'a
(** [with_open_communication ~mode port_location callback] similar to
    {!open_communication} but with an auto-{{!close_communication}closing}
    mechanism. *)

val close_communication : t -> unit
(** [close serial_port] close the {{!Platform_depend.S.serial_port}serial port}.
*)

(** {1 I/O} *)

val to_channels : t -> in_channel * out_channel
(** [to_channels serial_port]

    @return Channel abstraction pair for input/output tasks. *)

(** {1 Configuration} *)

module Mode = Mode

(** {1 Pretty print} *)

val pp : Format.formatter -> t -> unit

(** {1 Low level} *)

module Platform_depend = Platform_depend
