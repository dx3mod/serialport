let port_name = "/dev/ttyUSB0"
and baud_rate = 9600

let () =
  let mode = Mode.make ~baud_rate () in

  Serialport_unix.with_open_communication ~mode port_name @@ fun ser_port ->
  let ic, _ = Serialport_unix.to_channels ser_port in

  (* Out_channel.output_string oc "Hello from OCaml code!\n"; *)

  while true do
  In_channel.input_char ic |> Option.iter print_char
  done

  (* In_channel.input_line ic |> Option.iter print_endline *)
