type t = {
  unix_fd : Serialport.Native.t;
  ic : in_channel;
  oc : out_channel;
  port_location : string;
}

let make ~port_location unix_fd =
  let ic = Unix.in_channel_of_descr unix_fd in
  let oc = Unix.out_channel_of_descr unix_fd in

  { unix_fd; ic; oc; port_location }

let close_communication { unix_fd; _ } = Unix.close unix_fd

exception Not_found_port of string

let open_communication ?(exclusive = true) ~opts:port_opts port_name =
  if not (Sys.file_exists port_name) then raise (Not_found_port port_name);

  let fd = Unix.openfile port_name [ O_RDWR; O_NOCTTY ] 0o000 in

  Serialport.Native.flush_serial_port fd;
  Serialport.Native.initialize_serial_port_by_port_opts fd port_opts;

  Serialport.Native.set_serial_port_exclusive fd exclusive;

  make ~port_location:port_name fd

let with_open_communication ?(exclusive = true) ~opts port f =
  let serial_port = open_communication ~exclusive ~opts port in
  Fun.protect
    (fun () -> f serial_port)
    ~finally:(fun () -> close_communication serial_port)

let to_channels ?(buffered = false) { oc; ic; _ } =
  Out_channel.set_buffered oc buffered;
  (ic, oc)

let[@inline] write { unix_fd; _ } buf off len = Unix.write unix_fd buf off len
and[@inline] read { unix_fd; _ } buf off len = Unix.read unix_fd buf off len

let unsafe_unix_fd { unix_fd; _ } = unix_fd

let pp fmt { port_location; _ } =
  Format.fprintf fmt "SerialPort(%s)" port_location

module Modem = struct
  let set_request_to_send { unix_fd; _ } level =
    Serialport.Modem.set_request_to_send unix_fd level

  and set_data_terminal_ready { unix_fd; _ } level =
    Serialport.Modem.set_data_terminal_ready unix_fd level
end

let set_exclusive { unix_fd; _ } enable =
  Serialport.Native.set_serial_port_exclusive unix_fd enable
