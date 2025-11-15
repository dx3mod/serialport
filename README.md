<img src="https://gist.githubusercontent.com/dx3mod/402ef4c5f3f06645c6c7100da2e8676f/raw/31f21f19923ed2dd4a1a477d8cbbc1d06d59f07b/serialport.svg" width="170px">

# serialport

A cross-platform serial port communication library for modern OCaml that supports POSIX and Windows systems, as well as different I/O libraries (i.e., Lwt/Async/Eio for concurrency or a simple Unix interface).

[Documentation]()


> [!WARNING]
>
> The development stage of the project is not yet suitable for use.

The main motivation for creating this project was to address the lack of a comprehensive library for managing serial (COM) port communication in various environments, as well as the absence of an intuitive API for this task. The exist [OSerial] library has significant limitations in terms of functionality and future development, making it unsuitable for use in today's advanced environments.

## Installation

Now you can get only upstream (developer branch) version using OPAM, building from sources:
```console
$ opam install serialport.dev https://github.com/dx3mod/serialport.git
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