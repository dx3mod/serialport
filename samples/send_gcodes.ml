open Lwt.Syntax

let send_command serial_port command =
  let ic, oc = Serialport_lwt.to_channels serial_port in

  let* _ = Lwt_io.write_line oc command in
  let* line = Lwt_io.read_line ic in

  Lwt_io.printlf "received for %s" line

let demo connection =
  let commands =
    [ "G28"; "G0 Z60"; "M81"; "G4 S1"; "G0 Z50"; "G4 P200"; "G0 Z40" ]
  in

  let* _ = Lwt_io.printl "Starting demo...." in
  let* _ = Lwt_list.iter_s (send_command connection) commands in
  Lwt_io.printl "Commands sent."

let port = Obj.magic "/dev/ttyVA00"
and baud_rate = 115200

let () =
  Lwt_main.run
    begin
      Lwt_switch.with_switch @@ fun switch ->
      Serialport_lwt.open_communication ~switch ~mode:{ baud_rate } port |> demo
    end
