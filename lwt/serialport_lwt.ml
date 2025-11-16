open Lwt.Syntax
module Platform_depend = Serialport.Platform_depend
module Mode = Serialport.Mode

type t = {
  fd : Lwt_unix.file_descr;
      (** Unix fd and Windows HANDLE representation hacks. *)
  ic : Lwt_io.input_channel;
  oc : Lwt_io.output_channel;
}

let make fd =
  let oc = Lwt_io.of_fd ~mode:Output fd in
  let ic = Lwt_io.of_fd ~mode:Input fd in

  { fd; oc; ic }

let close_communication { fd; _ } = Lwt_unix.close fd

let open_communication ?switch ~mode port_location =
  let* fd = Lwt_unix.openfile port_location [ O_RDWR; O_NONBLOCK ] 0o000 in

  Platform_depend.setup_serial_port_generic (Lwt_unix.unix_file_descr fd) mode;

  let serial_port = make fd in
  Lwt_switch.add_hook switch (fun () -> close_communication serial_port);

  Lwt.return serial_port

let to_channels { oc; ic; _ } = (ic, oc)
