module Configuration = Configuration
module Descriptor = Descriptor

module Intf = struct
  external open_port : string -> Unix.file_descr = "caml_open_serial_port"
end

let open_communication port_name =
  try
    let unix_fd = Intf.open_port port_name in
    Descriptor.of_unix_fd ~name:port_name unix_fd
  with Failure _ ->
    raise @@ Sys_error Printf.(sprintf "%s: no such serial port" port_name)

let close_communication pd = Descriptor.to_unix_fd pd |> Unix.close

let with_open_communication port_name f =
  let pd = open_communication port_name in
  Fun.protect ~finally:(fun () -> close_communication pd) (fun () -> f pd)

let get_posix_ports () =
  let path_globs =
    [
      ("/sys/class/tty/", Str.regexp "ttyS[0-9]*");
      ("/dev/", Str.regexp "ttyUSB*");
      ("/dev/", Str.regexp "ttyACM*");
      (* macOS *)
      ("/dev/", Str.regexp "tty\\..*");
    ]
    |> List.to_seq
  in

  Seq.flat_map
    (fun (path, re) ->
      try
        Sys.readdir path |> Array.to_seq
        |> Seq.filter (fun path -> Str.string_match re path 0)
      with Sys_error _ -> Seq.empty)
    path_globs

and get_win32_ports () =
  Seq.init 255 Printf.(sprintf "COM%d") |> Seq.filter Sys.file_exists

let ports () =
  if Sys.unix then get_posix_ports ()
  else if Sys.win32 then get_win32_ports ()
  else failwith "not implemented"
