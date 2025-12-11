#include <sys/ioctl.h>
#include <termios.h>

#include <caml/mlvalues.h>
#include <caml/fail.h>

CAMLprim
    value
    caml_set_serial_port_pin(value unix_fd, value serial_lines, value level)
{
    static const int8_t status_map[] = {[0] = TIOCM_RTS, [1] = TIOCM_DTR};
    const int8_t status = status_map[Int_val(serial_lines)];

    if (Bool_val(level))
        ioctl(Int_val(unix_fd), TIOCMBIS, &status);
    else
        ioctl(Int_val(unix_fd), TIOCMBIC, &status);

    return Val_unit;
}

CAMLprim value caml_serial_port_flush(value unix_fd)
{
    tcflush(Int_val(unix_fd), TCIOFLUSH);
    return Val_unit;
}

CAMLprim value caml_set_serial_port_exclusive(value unix_fd, value enable)
{
    if (Bool_val(enable))
    {
        if (ioctl(Int_val(unix_fd), TIOCEXCL) < 0)
            caml_failwith("failed to set exclusive on serial port");
    }
    else if (ioctl(Int_val(unix_fd), TIOCNXCL) < 0)
        caml_failwith("failed to unset exclusive on serial port");

    return Val_unit;
}