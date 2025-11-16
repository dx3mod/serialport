module Platform_depend = Platform_depend
module Mode = Mode

type t = {
  native_port : Platform_depend.serial_port;
  ic : in_channel;
  oc : out_channel;
  port_location : string;
}

let make ~port_location native_port =
  let ic = Unix.in_channel_of_descr native_port in
  let oc = Unix.out_channel_of_descr native_port in

  { native_port; ic; oc; port_location }

let close_communication { native_port; _ } = Unix.close native_port

let open_communication ~mode port_location =
  let fd = Unix.openfile port_location [ O_RDWR; O_NONBLOCK ] 0o000 in
  Platform_depend.setup_serial_port_generic fd mode;
  make ~port_location fd

let with_open_communication ~mode port f =
  let serial_port = open_communication ~mode port in
  Fun.protect
    (fun () -> f serial_port)
    ~finally:(fun () -> close_communication serial_port)

let to_channels { oc; ic; _ } = (ic, oc)

let pp fmt { port_location; _ } =
  Format.fprintf fmt "SerialPort(%s)" port_location
