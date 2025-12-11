(** The module provides a simple synchronization interface for non-concurrent
    programs, as well as a {{!Serialport.Native.S}low-level native abstraction}
    for setting up serial ports and {{!Port_options}configuring} them. *)

type t
(** Interface for a opened {{!Serialport.Native.S.t}serial port}. *)

val open_communication : ?exclusive:bool -> opts:Port_options.t -> string -> t
(** [open_communication ~opts port_name] open opens the
    {{!Serialport.Native.S.t}serial port} using the specified
    {{!Port_options}[opts]} configuration.

    @raise Not_found_port if the port name does not exist.
    @raise Unix.Unix_error *)

val with_open_communication :
  ?exclusive:bool -> opts:Port_options.t -> string -> (t -> 'a) -> 'a
(** [with_open_communication ~opts port_name callback] similar to
    {!open_communication} but with an auto-{{!close_communication}closing}
    mechanism.

    @raise Not_found_port if the port name does not exist.
    @raise Unix.Unix_error *)

val close_communication : t -> unit
(** [close serial_port] close the {{!Platform_depend.S.serial_port}serial port}.
*)

(** {1 I/O} *)

val to_channels : ?buffered:bool -> t -> in_channel * out_channel
(** [to_channels serial_port]

    @return Channel abstraction pair for input/output tasks. *)

(** {2 Modem} *)

(** Modem controls. *)
module Modem : sig
  val set_request_to_send : t -> bool -> unit
  (** [set_request_to_send ser_port flag] set RTS bit in the modem control
      registers. *)

  val set_data_terminal_ready : t -> bool -> unit
  (** [set_data_terminal_ready ser_port flag] set DTR bit in the modem control
      registers. *)
end

(** {1 Exclusive} *)

val set_exclusive : t -> bool -> unit
(** [set_exclusive ser_port enable]

    @raise Failure *)

(** {1 Exceptions} *)

exception Not_found_port of string
(** raise if the port name does not exist. *)

(** {1 Pretty print} *)

val pp : Format.formatter -> t -> unit
