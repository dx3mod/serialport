type t = {
  native_port : Serialport.Platform_depend.serial_port;
  ic : in_channel;
  oc : out_channel;
  port_location : string;
}

let make ~port_location native_port =
  let ic = Unix.in_channel_of_descr native_port in
  let oc = Unix.out_channel_of_descr native_port in

  { native_port; ic; oc; port_location }

let close_communication { native_port; _ } = Unix.close native_port

let open_communication ~mode port_name =
  Serialport.Utils.assert_port_exist port_name;

  let fd = Unix.openfile port_name [ O_RDWR; O_NONBLOCK ] 0o000 in
  Serialport.Platform_depend.setup_serial_port_generic fd mode;
  make ~port_location:port_name fd

let with_open_communication ~mode port f =
  let serial_port = open_communication ~mode port in
  Fun.protect
    (fun () -> f serial_port)
    ~finally:(fun () -> close_communication serial_port)

let to_channels { oc; ic; _ } = (ic, oc)

let pp fmt { port_location; _ } =
  Format.fprintf fmt "SerialPort(%s)" port_location
