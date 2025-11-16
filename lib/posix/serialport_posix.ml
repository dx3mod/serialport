type serial_port = Unix.file_descr
and serial_port_name = string
and serial_port_options = Unix.terminal_io -> Unix.terminal_io

let setup_serial_port fd opts =
  let attr = Unix.tcgetattr fd in
  Unix.tcsetattr fd Unix.TCSANOW (opts attr)

let setup_serial_port_generic fd mode =
  let attr_of_parity parity attr =
    match parity with
    | Mode.No_parity ->
        Unix.{ attr with c_parenb = false; c_parodd = false; c_inpck = false }
    | Mode.Odd_parity ->
        Unix.{ attr with c_parenb = true; c_parodd = true; c_inpck = true }
    | Mode.Even_parity ->
        Unix.{ attr with c_parenb = true; c_parodd = false; c_inpck = true }
  and attr_of_stop_bits stop_bits attr =
    assert (stop_bits = 1 || stop_bits = 2);
    Unix.{ attr with c_cstopb = stop_bits }
  in

  let attr_of_mode (mode : Mode.t) attr =
    Unix.
      {
        attr with
        c_ibaud = mode.baud_rate;
        c_echo = false;
        c_icanon = false;
        c_obaud = mode.baud_rate;
        c_opost = false;
        c_csize = mode.data_bits;
      }
    |> attr_of_parity mode.parity
    |> attr_of_stop_bits mode.stop_bits
  in

  setup_serial_port fd @@ attr_of_mode mode
