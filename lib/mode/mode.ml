(** [Mode] module describes a
    {{!Serialport.Platform_depend.S.serial_port}serial port} configuration. *)

type t = {
  baud_rate : int;  (** The serial port bitrate (aka Baudrate). *)
  data_bits : int;  (** Size of the character (must be 5, 6, 7 or 8) *)
  parity : parity;  (** Parity describes a serial port parity setting *)
  stop_bits : int;
      (** StopBits describe a serial port stop bits setting (must be 1 or 2) *)
}

and parity = No_parity | Odd_parity | Even_parity

let make ?(data_bits = 8) ?(parity = No_parity) ?(stop_bits = 1) ~baud_rate () =
  assert (stop_bits = 1 || stop_bits = 2);
  assert (data_bits >= 5 && data_bits <= 8);

  { baud_rate; data_bits; parity; stop_bits }
