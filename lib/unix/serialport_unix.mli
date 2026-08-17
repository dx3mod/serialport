(** The {!Serialport.Descriptor} module extension for POSIX systems. *)
module Descriptor : sig
  (** {2 Waiting for read or write}

      The module uses the [Unix.select] mechanism to wait for the serial port to
      read or write bytes using standard functions. *)

  val wait_to_read : ?timeout:float -> Serialport.Descriptor.t -> unit
  (** [wait_to_read ?timeout pd]

      {b Example}
      {[
      Serialport_unix.Descriptor.wait_to_read pd;
      rally_input_string ic 10 (* some standard way to read bytes *)
      ]}

      @param timeout by default is [50.] seconds

      @raise Timeout *)

  val wait_to_write : ?timeout:float -> Serialport.Descriptor.t -> unit
  (** [wait_to_write ?timeout pd]

      Similar to {!wait_to_read}, but it waits to write bytes. *)

  (** {2 Reading} *)

  val read : Serialport.Descriptor.t -> bytes -> int -> int -> int
  (** [read pd bytes off len]

      Similar to [Unix.read] function but it for serial port. *)

  val read_exact : Serialport.Descriptor.t -> bytes -> int -> int -> unit
  (** [read_exact pd bytes off len] *)

  val read_string : Serialport.Descriptor.t -> int -> string
  (** [read_string pd len] *)

  (** {2 Writing} *)

  val write : Serialport.Descriptor.t -> bytes -> int -> int -> int
  (** [write pd bytes off len]

      Similar to [Unix.write] function but it for serial port. *)

  val write_exact : Serialport.Descriptor.t -> bytes -> int -> int -> unit
  (** [write_exact pd bytes off len] *)

  val write_string : Serialport.Descriptor.t -> string -> unit
  (** [write_string pd string] *)
end

exception Timeout
