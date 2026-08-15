(** The descriptor module of a serial port provides types and low-level
    functions. *)

type t
(** Descriptor type. *)

(** {1 Construction} *)

val of_unix_fd : ?name:string -> Unix.file_descr -> t
(** [of_unix_fd ?name fd]

    Construct a serial port descriptor from a file descriptor with the passed
    name.

    {b Example}

    {[
    let pd = Serialport.Descriptor.of_unix_fd ~name:"/dev/ttys003" fd in
    ]}

    @param ?name
      It is optional to use a pretty name for a descriptor. By default, it is
      "UNKNOWN". *)

val to_unix_fd : t -> Unix.file_descr
(** [to_unix_fd pd]

    Extract a file descriptor from the serial port descriptor. *)

(** {2 Conversions} *)

val to_channels : ?buffering:bool -> t -> in_channel * out_channel
(** [to_channel ?buffering pd]

    Create an input and output channels from the serial port descriptor.

    @param ?buffering Set buffering for the output channel. Default is false. *)

(** {1 Configuration} *)

val configure : t -> Configuration.t -> unit
(** [configure pd configuration]

    Apply all [configuration] options to the serial port descriptor. See
    {!Configuration.make} or {!Configuration.of_string} functions for creating
    options.

    {b Example}

    {[
    Serialport.Configuration.of_string ~baud_rate:9800 "8N1H"
    |> Serialport.Descriptor.configure pd
    ]}

    @raise Sys_error if something went wrong *)

val configure' : t -> baud_rate:int -> string -> unit
(** [configure' pd ~baud_rate mode]

    Apply the configuration [mode] string to the serial port descriptor. See the
    {!Configuration.of_string} function for details about mode string syntax. *)

val configuration : t -> Configuration.t
(** [configuration pd]

    Returns an actual serial port configuration. *)

(** {1 Modem} *)

(** A serial port modem module. *)
module Modem : sig
  (** {1 Setting pins} *)

  val set_request_to_send : t -> bool -> unit
  (** [set_request_to_send pd high]

      Sets the state of the RTS (Request To Send) control signal. *)

  val set_data_terminal_ready : t -> bool -> unit
  (** [set_data_terminal_ready pd high]

      Sets the state of the Data Terminal Ready pin. *)

  (** {1 Getting pins} *)

  val get_request_to_send : t -> bool
  (** [get_request_to_send pd] *)

  val get_data_terminal_ready : t -> bool
  (** [get_data_terminal_ready pd] *)
end

(** {1 Misc} *)

(** {2 Flushing} *)

val flush : t -> unit
(** [flush pd]

    Flush the serial port. *)

val drain : t -> unit
(** [drain pd]

    Drain the serial port. *)

(** {2 Break signal} *)

val send_break_signal : t -> unit
(** [send_break_signal pd]

    Send a BREAK signal to the serial port. *)

(** {2 Pretty print} *)

val pp : Format.formatter -> t -> unit [@@ocaml.toplevel_printer]
