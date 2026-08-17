module Cli = struct
  let baud = ref 0
  and port = ref ""

  let parse () =
    Arg.parse
      [
        ("-p", Arg.Set_int baud, "Set baud rate");
        ("-p", Arg.Set_string port, "Set port");
      ]
      ignore "receive_data [-b BAUD_RATE] [-p PORT]"
end

let () =
  Cli.parse ();

  Serialport.with_open_communication !Cli.port @@ fun pd ->
  let bytes = Bytes.create 100 in

  while true do
    match Serialport_unix.Descriptor.read pd bytes 0 100 with
    | 0 -> ()
    | length ->
        print_endline @@ Bytes.sub_string bytes 0 length;
        flush stdout
  done
