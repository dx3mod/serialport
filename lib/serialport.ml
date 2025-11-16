(** {1 Configuration} *)

module Mode = Mode
(** [Mode] module describes a {{!Platform_depend.S.serial_port}serial port}
    configuration. *)

(** {1 Errors} *)

include Errors

(** {1 Low level}

    The native implementation for target system. *)

module Platform_depend = Platform_depend

(** {1 Utils} *)

module Utils = Utils
