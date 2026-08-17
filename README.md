<img src="https://i.ibb.co/kRmrSqJ/serportlogo-001.png" width="170"> 

# Serialport

A cross-platform serial port communication library for OCaml that supports both POSIX and Windows systems and any concurrent I/O runtime.

#### Comparison with OSerial library

The oldest OCaml library for working with serial ports is the [OSerial] library. It is a simple and hardcoded library for POSIX serial port manipulation that only works with [Lwt]. It does not support all the necessary features and does not look like a real library, so you probably wouldn't want to use it.

In comparison, Serialport offers more rich features and a cross-platform implementation (supports Linux, macOS and Windows), an agnostic I/O runtime interface, and lightweight abstractions with detailed documentation.

## Quick start

You can install the `serialport` library using the [OPAM] package manager or any other method you prefer.

```console
$ opam install serialport
```
If you want to use the `Lwt` runtime or other concurrent I/O runtimes (that are supported by Serialport), they should already be installed on your system.


You can also get the latest version of the upstream (developer) branch.
```console
$ opam pin serialport.dev https://github.com/dx3mod/serialport.git
```

If you are using [Dune], please add the `serialport` library to your dependencies.

### In use

A simple example of using a serial port to send the message "Hello World!" using channels.

```ocaml
let () = 
  Serialport.with_open_communication "/dev/tty.uart-device" @@ fun pd ->
  Serialport.Descriptor.configure' pd ~baud_rate:9600 "8N1";

  let (_, oc) = Serialport.Descriptor.to_channels pd in 
  Out_channel.output_string oc "Hello World!\n"
```

In more realistic scenarios, you would need to use a specific I/O library for your application's runtime, such as `serialport.unix` for synchronous Unix code or `serialport.lwt` for Lwt programming.

```ocaml
Serialport_unix.Descriptor.write_string pd "Hello World!\n"
```

You need to keep in mind that you are interacting with a physical device outside of the operating system, which is why there may be delays and other issues!


For more details, see [API references](https://ocaml.org/p/serialport/latest/doc/index.html) and [`examples/`](./examples/) directory.


## References

For research this topic you should read [Serial Programming Guide for POSIX Operating Systems](https://www.msweet.org/serial/serial.html)
for Unix systems and [Windows Serial Port Programming](https://ds.opdenbrouw.nl/micprg/pdf/serial-win.pdf) for Windows platform.

Other implementations
* outdated OCaml Serial Module [m-laniakea/oserial](https://github.com/m-laniakea/oserial),
* Rust [serialport](https://docs.rs/serialport/latest/serialport/),
* Golang [bugst/go-serial](https://github.com/bugst/go-serial).

## Credits

I would like to express my deep gratitude to the author of the [Simple UART] library, from which platform-dependent code was borrowed.

## Showcases

Look at projects that use the Serial port library. They are good examples of how to do things.

* [Burav] is a utility for burning firmware onto AVR MCUs. Uses Serialport to communicate with bootloaders and programmer devices.

## License

The project is licensed under [the MIT License](./LICENSE), which allows for all permissions.
Just use it and enjoy yourself without fear. We are always open to pull requests!

[OSerial]: https://github.com/m-laniakea/oserial
[Lwt]: https://github.com/ocsigen/lwt
[Simple UART]: https://github.com/AndreRenaud/simple_uart
[OPAM]: https://opam.ocaml.org/
[Dune]: https://dune.build
[Burav]: https://github.com/dx3mod/burav