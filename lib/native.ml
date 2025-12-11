module type S = sig
  type t
  (** Native serial port type. *)

  and port_name
  (** Native serial port name type. *)

  and port_options
  (** Native serial port options type. *)

  (** {2 Initialize functions} *)

  val initialize_serial_port : t -> port_options -> unit
  (** [initialize_serial_port ser_port opts] *)

  val initialize_serial_port_by_port_opts : t -> Port_options.t -> unit
  (** [initialize_serial_port_by_port_opts ser_port opts] *)

  val flush_serial_port : t -> unit
  (** [flush_serial_port ser_port] *)

  (** {2 Modem control functions} *)

  type serial_lines =
    | Request_to_send  (** RTS *)
    | Data_terminal_ready  (** DTR *)

  val set_serial_modem_bits : t -> serial_lines -> bool -> unit
  (** [set_serial_modem_bits ser_port ser_lines flag] sets specific bits in the
      modem control registers on a tty device. *)

  (** {2 Port exclusive settings} *)

  val set_serial_port_exclusive : t -> bool -> unit
  (** [set_serial_port_exclusive ser_port enable] *)
end

module Native_intf :
  S
    with type t = Native_intf.t
    with type port_name = Native_intf.port_name
    with type port_options = Native_intf.port_options =
  Native_intf

include Native_intf
