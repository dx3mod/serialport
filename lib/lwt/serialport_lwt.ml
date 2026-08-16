module Descriptor = struct
  let to_channels pd =
    let unix_fd = Serialport.Descriptor.to_unix_fd pd in

    let ic = Lwt_io.of_unix_fd ~mode:Input unix_fd
    and oc = Lwt_io.of_unix_fd ~mode:Output unix_fd in

    (ic, oc)
end
