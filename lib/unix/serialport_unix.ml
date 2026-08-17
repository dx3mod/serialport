exception Timeout

module Descriptor = struct
  let wait_to_read' ?(timeout = 50.) unix_fd =
    match Unix.select [ unix_fd ] [] [] timeout with
    | [ _ ], _, _ -> ()
    | _ -> raise Timeout

  and wait_to_write' ?(timeout = 50.) unix_fd =
    match Unix.select [] [ unix_fd ] [] timeout with
    | _, [ _ ], _ -> ()
    | _ -> raise Timeout

  let wait_to_read ?timeout pd =
    Serialport.Descriptor.to_unix_fd pd |> wait_to_read' ?timeout

  and wait_to_write ?timeout pd =
    Serialport.Descriptor.to_unix_fd pd |> wait_to_write' ?timeout

  let read pd bytes off len =
    let unix_fd = Serialport.Descriptor.to_unix_fd pd in
    wait_to_read' unix_fd;
    Unix.read unix_fd bytes off len

  and write pd bytes off len =
    let unix_fd = Serialport.Descriptor.to_unix_fd pd in
    wait_to_write' unix_fd;
    Unix.write unix_fd bytes off len

  let rec read_exact pd bytes off len =
    if len <= 0 then ()
    else begin
      let r = read pd bytes off len in
      if r = 0 then raise End_of_file
      else read_exact pd bytes (off + r) (len - r)
    end

  and write_exact pd bytes off len =
    match write pd bytes off len with
    | 0 -> ()
    | length when length <= len ->
        write_exact pd bytes (off + length) (len - length)
    | _ -> failwith "illegal state"

  let read_string pd len =
    let bytes = Bytes.create len in
    read_exact pd bytes 0 len;
    Bytes.unsafe_to_string bytes

  and write_string pd string =
    let bytes = Bytes.unsafe_of_string string in
    write_exact pd bytes 0 String.(length string)
end
