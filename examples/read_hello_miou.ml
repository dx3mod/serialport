let port_name = "/dev/ttyUSB0"
and baud_rate = 9600

let () =
  Miou_unix.run @@ fun () ->
  let opts = Port_options.make ~baud_rate () in
  Serialport_miou.with_open_communication ~opts port_name begin fun ser_port ->
      let buf = Bytes.create 100 in
      while true do
        Miou_unix.Ownership.read ser_port buf |> ignore;
        print_endline @@ Bytes.to_string buf
      done
    end
