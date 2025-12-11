module type S = sig
  type t
  and port_name
  and port_options

  val initialize_serial_port : t -> port_options -> unit
  val initialize_serial_port_by_port_opts : t -> Port_options.t -> unit

  type serial_lines = Request_to_send | Data_terminal_ready

  val set_pin : t -> serial_lines -> bool -> unit
end

include Native_intf
