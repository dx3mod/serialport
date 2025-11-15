open Lwt.Syntax

let wait_line ~timeout ic =
  let p, r = Lwt.task () in

  Lwt_timeout.start
  @@ Lwt_timeout.create timeout (fun () ->
      Lwt.async begin fun () ->
          let+ line = Lwt_io.read_line ic in
          Lwt.wakeup r line
        end);

  p

let send_command serial_port command =
  let ic, oc = Serialport_lwt.to_channels serial_port in

  let* _ = Lwt_io.write_line oc command in
  let* line = wait_line ~timeout:5 ic in

  Lwt_io.printlf "received for %s" line

let demo connection =
  let commands =
    [ "G28"; "G0 Z60"; "M81"; "G4 S1"; "G0 Z50"; "G4 P200"; "G0 Z40" ]
  in

  let* _ = Lwt_io.printl "Starting demo...." in
  let* _ = Lwt_list.iter_s (send_command connection) commands in
  Lwt_io.printl "Commands sent."

let port : Serialport.Platform_depend.serial_port_name =
  Obj.magic "/dev/ttyUSB0"

and baud_rate = 115200

let () =
  Lwt_main.run
    begin
      Lwt_switch.with_switch @@ fun switch ->
      Serialport_lwt.open_communication ~switch ~mode:{ baud_rate } port |> demo
    end
