(** A module containing serial port settings *)

module Parity : sig
  type t = None | Odd | Even
end

module Flow_control : sig
  type t = None | Hardware | Software
end

type t = private {
  baud_rate : int;  (** The serial port bitrate (aka baud rate) *)
  data_bits : int;  (** Size of the character (must be 5, 6, 7 or 8) *)
  parity : Parity.t;  (** Parity describes a serial port parity setting *)
  stop_bits : int;  (** Serial port stop bits setting (must be 1 or 2) *)
  flow_control : Flow_control.t;  (** Flow control modes *)
}

val make :
  ?flow_control:Flow_control.t ->
  ?data_bits:int ->
  ?parity:Parity.t ->
  ?stop_bits:int ->
  baud_rate:int ->
  unit ->
  t
(** Construct a configuration value with default values.

    {b Example}

    {[
    Serialport.Configuration.make ~baud_rate:11500 ()
    ]}

    @param flow_control is {!Flow_control.None} by default
    @param data_bits is 8 bits by default
    @param parity is {!Parity.None} by default
    @param stop_bits is 1 bits by default *)

val of_string : baud_rate:int -> string -> t
(** [of_string ~baud_rate mode_string]

    Parse [mode_string], such as [8N1] or [7E2], indicates the number of data
    bits, the parity bit, and the number of stop bits. The most common setting
    is [8N1]. It also accepts [H] to enable hardware flow control (RTS/CTS) and
    [S] to enable software flow control.

    {b Example}

    {[
    Serialport.Configuration.of_string ~baud_rate:9600 "8N1F"
    ]}

    @raise Invalid_argument if [mode_string] contains illegal characters *)

val to_string : t -> string
(** [to_string config] returns mode string value. See also {!of_string}. *)
