open Errors

let[@inline] assert_port_exist path =
  if not (Sys.file_exists path) then raise (Not_found_port path)
