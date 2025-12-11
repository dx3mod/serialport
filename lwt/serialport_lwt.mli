(** The module provides a {{:https://github.com/ocsigen/lwt}Lwt}-based
    asynchronous interface for concurrent programming. *)

type t
(** Interface for a opened {{!Platform_depend.S.serial_port}serial port}. *)

val open_communication :
  ?switch:Lwt_switch.t -> opts:Serialport.Port_options.t -> string -> t Lwt.t
(** [open_communication ?switch ~opts port_name] open opens the
    {{!Platform_depend.S.serial_port}serial port} using the specified
    {{!Port_opts}[opts]s} configuration.

    @param switch
      Pins the serial port to the switch's scope to automatically
      {{!close_communication}close} it when exiting the scope. *)

val close_communication : t -> unit Lwt.t
(** [close serial_port] close the {{!Platform_depend.S.serial_port}serial port}.
*)

(** {1 I/O} *)

val to_channels : t -> Lwt_io.input_channel * Lwt_io.output_channel
(** [to_channels serial_port]

    @return Lwt channel abstraction pair for input/output tasks. *)

(** {1 Exceptions} *)

exception Not_found_port of string
