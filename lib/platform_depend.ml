module type S = sig
  type serial_port
  and serial_port_name
  and serial_port_options

  val setup_serial_port : serial_port -> serial_port_options -> unit
  val setup_serial_port_generic : serial_port -> Mode.t -> unit
end

(* for checking signature *)
module _ : S = Platform_depend_intf
include Platform_depend_intf
