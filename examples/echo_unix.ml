let port_name = "/dev/ttyUSB0"
and baud_rate = 9600

let () =
  let mode = Mode.make ~baud_rate () in

  Serialport_unix.with_open_communication ~mode port_name begin fun ser_port ->
      let ic, oc = Serialport_unix.to_channels ~buffered:false ser_port in

      Unix.sleepf 2.;

      for i = 0 to 1_000 do
        Printf.fprintf oc "%d: Hello from PC\n" i;
        Unix.sleepf 0.2;

        In_channel.input_line ic |> Option.iter print_endline
      done
    end
