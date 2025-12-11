type t = Miou_unix.Ownership.file_descr

exception Not_found_port of string

let open_communication ~opts:port_opts port_name =
  if not (Sys.file_exists port_name) then raise (Not_found_port port_name);

  let fd = Unix.openfile port_name [ O_RDWR; O_NOCTTY; O_NONBLOCK ] 0o000 in
  Serialport.Native.initialize_serial_port_by_port_opts fd port_opts;

  Miou_unix.Ownership.of_file_descr fd

let close_communication = Miou_unix.Ownership.close

let with_open_communication ~opts port_name f =
  let port = open_communication ~opts port_name in

  Miou.protect ~on_cancellation:ignore
    ~finally:(fun ~cancelled:_ -> close_communication port)
    (fun () -> f port)
