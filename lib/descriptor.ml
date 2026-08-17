type t = {
  fd : Unix.file_descr;
  name : string;
  mutable configuration : Configuration.t option;
}

let to_unix_fd { fd; _ } = fd
and of_unix_fd ?(name = "UNKNOWN") fd = { fd; configuration = None; name }

let to_channels ?(buffering = false) { fd; _ } =
  let ic = Unix.in_channel_of_descr fd and oc = Unix.out_channel_of_descr fd in
  Out_channel.set_buffered oc buffering;

  (ic, oc)

(* Native bindings functions  *)
module Intf = struct
  [@@@warning "-37"]

  external flush : Unix.file_descr -> unit = "caml_flush_serial_port"
  external drain : Unix.file_descr -> unit = "caml_drain_serial_port"

  external configure : Unix.file_descr -> Configuration.t -> unit
    = "caml_configure_serial_port"

  external get_configuration : Unix.file_descr -> Configuration.t
    = "caml_get_configuration_serial_port"

  type modem_bits = Rts | Cts | Dsr | Dcd | Dtr | Ri

  external get_pin : Unix.file_descr -> modem_bits -> bool
    = "caml_get_serial_port_pin"

  external set_pin : Unix.file_descr -> modem_bits -> bool -> unit
    = "caml_set_serial_port_pin"

  external send_break : Unix.file_descr -> unit
    = "caml_send_break_signal_to_serial_port"
end

let configure pd config =
  try
    pd.configuration <- Some config;
    Intf.configure pd.fd config
  with Failure msg -> raise @@ Sys_error msg

let configure_with_mode pd ~baud_rate mode =
  configure pd Configuration.(of_string ~baud_rate mode)

let configuration pd =
  match pd.configuration with
  | None ->
      let configuration = Intf.get_configuration pd.fd in
      pd.configuration <- Some configuration;
      configuration
  | Some configuration -> configuration

module Modem = struct
  let set_request_to_send { fd; _ } high = Intf.set_pin fd Rts high
  and set_data_terminal_ready { fd; _ } high = Intf.set_pin fd Dtr high

  let get_request_to_send { fd; _ } = Intf.get_pin fd Rts
  and get_data_terminal_ready { fd; _ } = Intf.get_pin fd Dtr
end

let send_break_signal { fd; _ } = Intf.send_break fd

let flush { fd; _ } = Intf.flush fd
and drain { fd; _ } = Intf.drain fd

let pp ppf pd =
  Format.fprintf ppf "Serialport.Descriptor(%S, %s)" pd.name
    Configuration.(to_string @@ configuration pd)
