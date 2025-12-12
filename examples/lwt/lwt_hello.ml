open Lwt.Infix
(** Send a hello message and wait for a response. *)

let () =
  Lwt_main.run
    begin
      let port_opts = Serialport.Port_options.make ~baud_rate:9600 ()
      and port_name = "/dev/ttyUSB0" in

      Lwt_switch.with_switch @@ fun switch ->
      let%lwt ser_port =
        Serialport_lwt.open_communication ~switch ~opts:port_opts port_name
      in

      let ic, oc = Serialport_lwt.to_channels ser_port in

      Lwt_unix.sleep 2.;%lwt

      Lwt_io.write_line oc "Hello from PC!";%lwt

      Lwt_io.read_line ic >>= Lwt_io.printl
    end
