(** A cross-platform serial port communication library for OCaml that supports
    both POSIX and Windows systems and any concurrent I/O runtime. *)

(** {1 Port descriptor} *)

module Configuration = Configuration
module Descriptor = Descriptor

(** {1 Open communication} *)

val with_open_communication : string -> (Descriptor.t -> 'a) -> 'a
(** [with_open_communication port_name f]

    Opens the serial port with the specified name and returns the result of
    calling the function [f] with a serial port descriptor.

    {b Note}. It does not function to configure the serial port. Instead, it
    uses the {!Descriptor.configure} function.

    {b See also} {!open_communication}.

    {b Example}

    {[
    Serialport.with_open_communication "/dev/tty.uart-device" @@ fun pd ->
    Serialport.Descriptor.configure_with_mode pd ~baud_rate "8N1"
    ]} *)

val open_communication : string -> Descriptor.t
(** [open_communication port_name]

    Opens the serial port with the specified name and returns a serial port
    descriptor.

    @raise Sys_error *)

val close_communication : Descriptor.t -> unit
(** [close_communication pd]

    Close the serial port. *)

(** {1 Getting port listings} *)

val ports : unit -> string Seq.t
(** [ports ()]

    Returns a list of ports that are currently available on the system.

    {b Example}

    {[
    Serialport.ports () |> Seq.iter print_endline
    ]} *)
