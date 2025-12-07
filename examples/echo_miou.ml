let port_name = "/dev/ttyUSB0"
and baud_rate = 9600

let () =
  Miou_unix.run @@ fun () ->
  let mode = Mode.make ~baud_rate () in
  let stdout = Miou_unix.of_file_descr Unix.stdout in

  Serialport_miou.with_open_communication ~mode port_name begin fun ser_port ->
      Miou_unix.sleep 0.5;

      let buf = Bytes.create 100 in
      for i = 0 to 1_000 do
        Miou_unix.Ownership.write ser_port
        @@ Printf.sprintf "%d: Hello from PC!\n" i;
        Miou_unix.sleep 0.2;

        let len = Miou_unix.Ownership.read ser_port buf in

        Miou_unix.write stdout ~len (Bytes.unsafe_to_string buf)
      done
    end
