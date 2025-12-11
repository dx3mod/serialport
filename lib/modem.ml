let write_request_to_send port level = Native.set_pin port Request_to_send level

let write_data_terminal_ready port level =
  Native.set_pin port Data_terminal_ready level
