module Platform_depend = Serialport.Platform_depend

type t = {
  native_port : Platform_depend.serial_port;
  ic : Lwt_io.input_channel;
  oc : Lwt_io.output_channel;
}

let make native_port =
  (* Hacks for Unix. xd. Fix it! *)
  let oc = Lwt_io.of_unix_fd ~mode:Output @@ Obj.magic native_port in
  let ic = Lwt_io.of_unix_fd ~mode:Input @@ Obj.magic native_port in

  { native_port; oc; ic }

let close_communication { native_port; _ } =
  Platform_depend.close_serial_port native_port

let open_communication ?switch ~mode port =
  let native_port = Platform_depend.open_serial_port port in
  Platform_depend.setup_serial_port_generic native_port
    ~baud_rate:mode.Serialport.Mode.baud_rate;

  let serial_port = make native_port in
  (* Add auto-closing features. *)
  Lwt_switch.add_hook switch (fun () ->
      close_communication serial_port;
      Lwt.return_unit);

  serial_port

let to_channels { oc; ic; _ } = (ic, oc)
