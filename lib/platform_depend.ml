module type S = sig
  type serial_port
  and serial_port_name
  and serial_port_options

  val open_serial_port : serial_port_name -> serial_port
  val setup_serial_port : serial_port -> serial_port_options -> unit
  val setup_serial_port_generic : serial_port -> baud_rate:int -> unit
  val close_serial_port : serial_port -> unit
end

(* for checking signature *)
module T : S = Platform_depend_intf
include T
