(** [Mode] module describes a
    {{!Serialport.Platform_depend.S.serial_port}serial port} configuration. *)

type t = { baud_rate : int  (** The serial port bitrate (aka Baudrate). *) }
