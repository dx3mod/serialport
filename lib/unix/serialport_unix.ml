exception Timeout

module Descriptor = struct
  let wait_to_read ?(timeout = 50.) pd =
    let unix_fd = Serialport.Descriptor.to_unix_fd pd in
    match Unix.select [ unix_fd ] [] [] timeout with
    | [ _ ], _, _ -> ()
    | _ -> raise Timeout
end
