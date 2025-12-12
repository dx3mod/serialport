(** Send a hello message and wait for a response. *)

let () =
  begin
    let port_opts = Serialport.Port_options.make ~baud_rate:9600 ()
    and port_name = "/dev/ttyUSB0" in

    Serialport_unix.with_open_communication ~opts:port_opts port_name
      begin fun ser_port_conn ->
        let ic, oc = Serialport_unix.to_channels ser_port_conn in
        Unix.sleep 2;
        Out_channel.output_string oc "Hello from PC!\n";
        In_channel.input_line ic |> Option.iter print_endline
      end
  end
