type t
(** Interface for a opened {{!Serialport.Native.S.t}serial port}. *)

val open_communication :
  ?switch:Lwt_switch.t ->
  ?exclusive:bool ->
  opts:Port_options.t ->
  string ->
  t Lwt.t

(** [open_communication ?switch ?exclusive ~opts port_name] open the
    {{!Serialport.Native.S.t}serial port} using the specified
    {{!Port_options}[opts]} configuration.

    @raise Not_found_port if the port name does not exist.
    @raise Unix.Unix_error *)

val with_open_communication :
  ?exclusive:bool ->
  opts:Port_options.t ->
  string ->
  (t -> 'a Lwt.t) ->
  'a Lwt.t
(** [with_open_communication ?exclusive ~opts port_name callback] similar to
    {!open_communication} but with an auto-{{!close_communication}closing}
    mechanism.

    @raise Not_found_port if the port name does not exist.
    @raise Unix.Unix_error *)

val close_communication : t -> unit Lwt.t
(** [close ser_port] close the {{!Platform_depend.S.serial_port}serial port}. *)

(** {1 I/O} *)

val to_channels : t -> Lwt_io.input_channel * Lwt_io.output_channel
(** [to_channels ser_port]
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

val pp : Lwt_fmt.formatter -> t -> unit Lwt.t
