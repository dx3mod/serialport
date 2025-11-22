<img src="https://gist.githubusercontent.com/dx3mod/402ef4c5f3f06645c6c7100da2e8676f/raw/31f21f19923ed2dd4a1a477d8cbbc1d06d59f07b/serialport.svg" width="170px">

# serialport

A cross-platform library for serial port communication in OCaml that supports both POSIX and Windows operating systems, and also provides a synchronous and asynchronous interface for various input/output (I/O) libraries such as Lwt, Async, and Eio.

[Documentation]()

The main motivation behind creating this project is to address the lack of a comprehensive library for managing serial port communication in different environments, as well as the lack of an intuitive API for this task. The existing [OSerial] library has significant limitations in terms of functionality and future development, making it unsuitable for use in modern environments.

## Installation

Now you can get (aka pin) only upstream (developer branch) version using OPAM, building from sources:
```console
$ opam pin serialport.dev https://github.com/dx3mod/serialport.git
```

## Quick start

```ocaml
# #require "serialport.unix";;

# let mode = Mode.make ~baud_rate:11500 ()
  and device_path = "/dev/ttyS3" in
  Serialport_unix.with_open_communication ~mode device_path @@ fun ser_port_conn -> 
  (* get abstractions for I/O *)
  let (ic, oc) = Serialport_unix.to_channels ser_port_conn in
  (* working *)
  Out_channel.output_string oc "Hello from PC!"
```

## References

For research this topic you should read [Serial Programming Guide for POSIX Operating Systems](https://www.msweet.org/serial/serial.html) for Unix systems and [Windows Serial Port Programming](https://ds.opdenbrouw.nl/micprg/pdf/serial-win.pdf) for Windows platform.

Other implementations: 
outdated OCaml Serial Module [m-laniakea/oserial](https://github.com/m-laniakea/oserial),
Rust [serialport](https://docs.rs/serialport/latest/serialport/),
Golang [bugst/go-serial](https://github.com/bugst/go-serial).

## License

The project is licensed under [the MIT License](./LICENSE), which allows for all permissions. Just use it and enjoy yourself without fear. We are always open to pull requests!

[OSerial]: https://github.com/m-laniakea/oserial