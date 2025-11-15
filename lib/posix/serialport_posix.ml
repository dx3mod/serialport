type serial_port = Unix.file_descr
and serial_port_name = string
and serial_port_options = Unix.terminal_io -> Unix.terminal_io

let setup_serial_port fd opts =
  let attr = Unix.tcgetattr fd in
  Unix.tcsetattr fd Unix.TCSANOW (opts attr)

let setup_serial_port_generic fd ~baud_rate =
  setup_serial_port fd @@ fun attr ->
  {
    attr with
    c_ibaud = baud_rate;
    c_echo = false;
    c_icanon = false;
    c_obaud = baud_rate;
    c_opost = false;
  }
