let set_request_to_send port level =
  Native.set_serial_port_pin port Request_to_send level

let set_data_terminal_ready port level =
  Native.set_serial_port_pin port Data_terminal_ready level
