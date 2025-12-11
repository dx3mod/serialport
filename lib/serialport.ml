(** Base module with platform-independent and native functions for low-level
    serial port communication. *)

(** {1 Control options} *)

module Port_options = Port_options
(** The module describes the configuration options for a serial port. *)

(** {2 Modem} *)

module Modem = Modem

(** {1 Low level}

    The native implementation for target system. *)

module Native = Native
