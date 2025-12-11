(** Modem control functions. *)

(** [set_request_to_send ser_port level] set RTS bit in the modem control
    registers. *)
let set_request_to_send port level =
  Native.set_serial_modem_bits port Request_to_send level

(** [set_data_terminal_ready ser_port level] set DTR bit in the modem control
    registers. *)
let set_data_terminal_ready port level =
  Native.set_serial_modem_bits port Data_terminal_ready level
