let port_name = "/dev/ttyUSB0"
and baud_rate = 9600

let () =
  let opts = Port_options.make ~baud_rate () in

  Serialport_unix.with_open_communication ~opts port_name begin fun ser_port ->
      Serialport_unix.Modem.set_request_to_send ser_port false;
      Serialport_unix.Modem.set_data_terminal_ready ser_port false;

      Unix.sleepf 0.2;

      Serialport_unix.Modem.set_request_to_send ser_port true;
      Serialport_unix.Modem.set_data_terminal_ready ser_port true;

      Unix.sleepf 0.25
    end
