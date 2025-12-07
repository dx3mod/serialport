let port_name = "/dev/ttyUSB0"
and baud_rate = 9600

let handle_ser_port ser_port =
  Miou_unix.Ownership.write ser_port "Hello from OCaml code!\n";
  let buf = Bytes.init 50 (Fun.const '.') in
  Miou_unix.Ownership.read ser_port buf |> ignore;
  print_endline @@ Bytes.to_string buf 

let () =
  Miou_unix.run @@ fun () ->
  let mode = Mode.make ~baud_rate () in
  Serialport_miou.with_open_communication ~mode port_name handle_ser_port
