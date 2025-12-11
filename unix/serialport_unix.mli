(** The module provides a simple synchronization interface for non-concurrent
    programs, as well as a {{!Platform_depend.S}low-level native abstraction}
    for setting up serial ports and {{!Port_options}configuring} them. *)

type t
(** Interface for a opened {{!Platform_depend.S.serial_port}serial port}. *)

val open_communication : opts:Port_options.t -> string -> t
(** [open_communication ~opts port_name] open opens the
    {{!Platform_depend.S.serial_port}serial port} using the specified
    {{!Port_options}[port options]} configuration. *)

val with_open_communication : opts:Port_options.t -> string -> (t -> 'a) -> 'a
(** [with_open_communication ~opts port_name callback] similar to
    {!open_communication} but with an auto-{{!close_communication}closing}
    mechanism. *)

val close_communication : t -> unit
(** [close serial_port] close the {{!Platform_depend.S.serial_port}serial port}.
*)

(** {1 I/O} *)

val to_channels : ?buffered:bool -> t -> in_channel * out_channel
(** [to_channels serial_port]

    @return Channel abstraction pair for input/output tasks. *)

(** {2 Modem} *)

module Modem : sig
  val write_request_to_send : t -> bool -> unit
  val write_data_terminal_ready : t -> bool -> unit
end

(** {1 Exceptions} *)

exception Not_found_port of string

(** {1 Pretty print} *)

val pp : Format.formatter -> t -> unit
