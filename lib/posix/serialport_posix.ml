type t = Unix.file_descr
and port_name = string
and port_options = Unix.terminal_io -> Unix.terminal_io

let initialize_serial_port fd opts =
  let attr = Unix.tcgetattr fd in
  Unix.tcsetattr fd Unix.TCSANOW (opts attr)

let initialize_serial_port_by_port_opts fd port_options =
  let attr_of_parity parity attr =
    match parity with
    | Port_options.No_parity ->
        Unix.{ attr with c_parenb = false; c_parodd = false; c_inpck = false }
    | Port_options.Odd_parity ->
        Unix.{ attr with c_parenb = true; c_parodd = true; c_inpck = true }
    | Port_options.Even_parity ->
        Unix.{ attr with c_parenb = true; c_parodd = false; c_inpck = true }
  and attr_of_stop_bits stop_bits attr =
    assert (stop_bits = 1 || stop_bits = 2);
    Unix.{ attr with c_cstopb = stop_bits }
  in

  let attr_of_port_opts (options : Port_options.t) attr =
    Unix.
      {
        attr with
        c_ibaud = options.baud_rate;
        c_obaud = options.baud_rate;
        c_echo = false;
        c_icanon = false;
        c_isig = false;
        c_opost = false;
        c_csize = options.data_bits;
      }
    |> attr_of_parity options.parity
    |> attr_of_stop_bits options.stop_bits
  in

  initialize_serial_port fd @@ attr_of_port_opts port_options

type serial_lines = Request_to_send | Data_terminal_ready

external set_serial_modem_bits : t -> serial_lines -> bool -> unit
  = "caml_set_serial_port_pin"

external flush_serial_port : t -> unit = "caml_serial_port_flush"

external set_serial_port_exclusive : t -> bool -> unit
  = "caml_set_serial_port_exclusive"
