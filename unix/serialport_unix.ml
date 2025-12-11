type t = {
  unix_fd : Serialport.Platform_depend.serial_port;
  ic : in_channel;
  oc : out_channel;
  port_location : string;
}

let make ~port_location unix_fd =
  let ic = Unix.in_channel_of_descr unix_fd in
  let oc = Unix.out_channel_of_descr unix_fd in

  { unix_fd; ic; oc; port_location }

let close_communication { unix_fd; _ } = Unix.close unix_fd

let open_communication ~opts:port_opts port_name =
  Serialport.Utils.assert_port_exist port_name;

  let fd = Unix.openfile port_name [ O_RDWR; O_NOCTTY; O_NONBLOCK ] 0o000 in
  Serialport.Platform_depend.setup_serial_port_generic fd port_opts;
  make ~port_location:port_name fd

let with_open_communication ~opts port f =
  let serial_port = open_communication ~opts port in
  Fun.protect
    (fun () -> f serial_port)
    ~finally:(fun () -> close_communication serial_port)

let to_channels ?(buffered = true) { oc; ic; _ } =
  Out_channel.set_buffered oc buffered;
  (ic, oc)

let pp fmt { port_location; _ } =
  Format.fprintf fmt "SerialPort(%s)" port_location
