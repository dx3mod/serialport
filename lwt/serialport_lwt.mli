(** The module provides a {{:https://github.com/ocsigen/lwt}Lwt}-based
    asynchronous interface for concurrent programming. *)

type t
(** Interface for a opened {{!Platform_depend.S.serial_port}serial port}. *)

val open_communication :
  ?switch:Lwt_switch.t -> mode:Serialport.Mode.t -> string -> t Lwt.t
(** [open_communication ?switch ~mode port_location] open opens the
    {{!Platform_depend.S.serial_port}serial port} using the specified
    {{!Mode}[mode]s} configuration.

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

(** {1 Aliases} *)

module Mode = Serialport.Mode
module Platform_depend = Serialport.Platform_depend
