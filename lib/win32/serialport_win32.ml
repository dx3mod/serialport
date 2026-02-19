type t = Unix.file_descr
and port_name = string

and port_options = {
  baudrate : int;
  databbits : int;
  stopbits : int;
  parity : int;
}

module Intf = struct
  let int_of_parity = function
    | Port_options.Even_parity -> 0x0400
    | Port_options.Odd_parity -> 0x0200
    | Port_options.No_parity -> 0x0100

  external win32_setup_com_port_timeouts : t -> unit
    = "caml_win32_setup_com_port_timeouts"

  external win32_set_com_port_dcb :
    t -> baudrate:int -> databbits:int -> stopbits:int -> parity:int -> unit
    = "caml_win32_set_com_port_dcb"
end

let initialize_serial_port fd { baudrate; databbits; stopbits; parity } =
  Intf.win32_setup_com_port_timeouts fd;
  Intf.win32_set_com_port_dcb fd ~baudrate ~databbits ~stopbits ~parity

let initialize_serial_port_by_port_opts fd (opts : Port_options.t) =
  initialize_serial_port fd
    {
      baudrate = opts.baud_rate;
      databbits = opts.data_bits;
      stopbits = opts.stop_bits;
      parity = Intf.int_of_parity opts.parity;
    }

type serial_lines = Request_to_send | Data_terminal_ready

external set_serial_modem_bits : t -> serial_lines -> bool -> unit
  = "caml_set_serial_port_pin"

external flush_serial_port : t -> unit = "caml_serial_port_flush"

let set_serial_port_exclusive _ _ = ( (* not supported *) )
