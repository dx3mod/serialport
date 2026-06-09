<img src="https://gist.githubusercontent.com/dx3mod/402ef4c5f3f06645c6c7100da2e8676f/raw/31f21f19923ed2dd4a1a477d8cbbc1d06d59f07b/serialport.svg" width="170px">

# serialport

A cross-platform serial communication library written in OCaml is designed to work with any I/O runtime.

## Installation

Installation from the OPAM repository using the OPAM package manager.
```console
$ opam install serialport
```

You can also get the latest version of the upstream (developer) branch using OPAM.
```console
$ opam pin serialport.dev https://github.com/dx3mod/serialport.git
```

If you are using Dune, please add the `serialport` library to your dependencies.

## Usage

Typically, an example of usage is communication between a PC and an Arduino board
or other devices via an old-school serial port.

```ocaml
# #require "serialport.unix";;

# let port_opts = Serialport.Port_options.make ~baud_rate:9600 ()
  and port_name = "/dev/ttyUSB0" in

  Serialport_unix.with_open_communication ~opts:port_opts port_name
    begin fun ser_port ->
      (* Get channels abstractions for high-level working with I/O without buffering. *)
      let ic, oc = Serialport_unix.to_channels ser_port in
      (* Wait until Arduino has been initialized. *)
      Unix.sleep 2;
      (* Send the message to the Arduino via the serial port. *)
      Out_channel.output_string oc "Hello from PC!\n";
      (* Read the response from the serial port. *)
      In_channel.input_line ic
    end
```

## References

For research this topic you should read [Serial Programming Guide for POSIX Operating Systems](https://www.msweet.org/serial/serial.html)
for Unix systems and [Windows Serial Port Programming](https://ds.opdenbrouw.nl/micprg/pdf/serial-win.pdf) for Windows platform.

Other implementations
* outdated OCaml Serial Module [m-laniakea/oserial](https://github.com/m-laniakea/oserial),
* Rust [serialport](https://docs.rs/serialport/latest/serialport/),
* Golang [bugst/go-serial](https://github.com/bugst/go-serial).

## License

The project is licensed under [the MIT License](./LICENSE), which allows for all permissions.
Just use it and enjoy yourself without fear. We are always open to pull requests!

[OSerial]: https://github.com/m-laniakea/oserial
