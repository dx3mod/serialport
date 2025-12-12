open Lwt.Syntax

type t = {
  fd : Lwt_unix.file_descr;
  oc : Lwt_io.output_channel;
  ic : Lwt_io.input_channel;
  port_name : string;
}

let make ~port_name fd =
  let oc = Lwt_io.of_fd ~mode:Output fd in
  let ic = Lwt_io.of_fd ~mode:Input fd in

  { fd; oc; ic; port_name }

exception Not_found_port of string

let open_communication ?switch ?(exclusive = true) ~opts:port_opts port_name =
  let* _ =
    if not (Sys.file_exists port_name) then Lwt.fail (Not_found_port port_name)
    else Lwt.return_unit
  in

  let* fd =
    Lwt_unix.openfile port_name [ O_RDWR; O_NOCTTY; O_NONBLOCK ] 0o000
  in

  Lwt_switch.add_hook switch (fun () -> Lwt_unix.close fd);

  let unix_fd = Lwt_unix.unix_file_descr fd in

  Serialport.Native.flush_serial_port unix_fd;
  Serialport.Native.initialize_serial_port_by_port_opts unix_fd port_opts;
  Serialport.Native.set_serial_port_exclusive unix_fd exclusive;

  Lwt.return @@ make ~port_name fd

let close_communication { oc; _ } = Lwt_io.close oc

let with_open_communication ?(exclusive = true) ~opts port_name f =
  Lwt_switch.with_switch @@ fun switch ->
  Lwt.Infix.(open_communication ~switch ~exclusive ~opts port_name >>= f)

let to_channels { ic; oc; _ } = (ic, oc)
let[@inline] to_unix_fd { fd; _ } = Lwt_unix.unix_file_descr fd

module Modem = struct
  let set_request_to_send ser_port level =
    Serialport.Modem.set_request_to_send (to_unix_fd ser_port) level

  and set_data_terminal_ready ser_port level =
    Serialport.Modem.set_data_terminal_ready (to_unix_fd ser_port) level
end

let set_exclusive ser_port enable =
  Serialport.Native.set_serial_port_exclusive (to_unix_fd ser_port) enable

let pp fmt { port_name; _ } = Lwt_fmt.fprintf fmt "SerialPort(%s)" port_name
