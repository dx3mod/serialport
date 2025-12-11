type t = Miou_unix.Ownership.file_descr

let open_communication ~opts:port_opts port_name =
  Serialport.Utils.assert_port_exist port_name;

  let fd = Unix.openfile port_name [ O_RDWR; O_NOCTTY; O_NONBLOCK ] 0o000 in
  Serialport.Platform_depend.setup_serial_port_generic fd port_opts;

  Miou_unix.Ownership.of_file_descr fd

let close_communication = Miou_unix.Ownership.close

let with_open_communication ~opts port_name f =
  let port = open_communication ~opts port_name in

  Miou.protect ~on_cancellation:ignore
    ~finally:(fun ~cancelled:_ -> close_communication port)
    (fun () -> f port)
