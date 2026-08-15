#include <caml/mlvalues.h>
#include <caml/fail.h>
#include <caml/alloc.h>
#include <caml/memory.h>

#if defined(__linux__) || defined(__APPLE__)
#include <sys/ioctl.h>
#include <termios.h>
#include <sys/fcntl.h>
#else // Windows
#endif

enum
{
  SERIAL_PORT_PIN_RTS = 0,
  SERIAL_PORT_PIN_CTS,
  SERIAL_PORT_PIN_DSR,
  SERIAL_PORT_PIN_DCD,
  SERIAL_PORT_PIN_DTR,
  SERIAL_PORT_PIN_RI,
} serial_port_pin;

typedef enum
{
  NONE_FLOW_CONTROL = 0,
  HARDWARE_FLOW_CONTROL,
  SOFTWARE_FLOW_CONTROL
} flow_control_t;

typedef enum
{
  NO_PARITY = 0,
  ODD_PARITY,
  EVEN_PARITY
} parity_t;

value caml_open_serial_port(value port_name)
{
  CAMLparam1(port_name);
  CAMLlocal1(unix_fd);

#if defined(__linux__) || defined(__APPLE__)
  const int fd = open(String_val(port_name), O_RDWR | O_NDELAY | O_NOCTTY);

  if (fd == -1)
    caml_failwith("failed to open serial port by name");

  signal(SIGIO, SIG_IGN);
  fcntl(fd, F_SETFL, 0);

  unix_fd = Val_int(fd);

#else // Windows
#error "not implemented"
#endif

  CAMLreturn(unix_fd);
}

CAMLprim value caml_flush_serial_port(value unix_fd)
{
#if defined(__linux__) || defined(__APPLE__)
  tcflush(Int_val(unix_fd), TCIOFLUSH);
#else // Windows
#error "not implemented"
#endif
  return Val_unit;
}

CAMLprim value caml_drain_serial_port(value unix_fd)
{
#if defined(__linux__) || defined(__APPLE__)
  tcdrain(Int_val(unix_fd));
#else // Windows
#error "not implemented"
#endif
  return Val_unit;
}

value caml_get_configuration_serial_port(value unix_fd)
{
  CAMLparam1(unix_fd);
  CAMLlocal1(config);

  config = caml_alloc(5, 0);

#if defined(__linux__) || defined(__APPLE__)
  struct termios options;

  if (tcgetattr(Int_val(unix_fd), &options) < 0)
    caml_failwith("failed to get attributes of serial port");

  Store_field(config, 0, Val_int(cfgetispeed(&options)));

  {
    uint8_t data_bits = 0;
    if (options.c_cflag & CS8)
      data_bits = 8;
    else if (options.c_cflag & CS7)
      data_bits = 7;
    else if (options.c_cflag & CS6)
      data_bits = 6;
    else if (options.c_cflag & CS5)
      data_bits = 5;

    Store_field(config, 1, Val_int(data_bits));
  }

  {
    parity_t parity = NO_PARITY;
    if (options.c_cflag & (PARENB | PARODD))
      parity = ODD_PARITY;
    else if ((options.c_cflag & PARENB) && !(options.c_cflag & PARODD))
      parity = EVEN_PARITY;

    Store_field(config, 2, Val_int(parity));
  }

  {
    const uint8_t stop_bits = (options.c_cflag & CSTOPB) ? 2 : 1;
    Store_field(config, 3, Val_int(stop_bits));
  }

  {
    flow_control_t flow_control = NONE_FLOW_CONTROL;

    if (options.c_cflag & CRTSCTS)
      flow_control = HARDWARE_FLOW_CONTROL;
    else if (options.c_cflag & (IXON | IXOFF))
      flow_control = SOFTWARE_FLOW_CONTROL;

    Store_field(config, 4, Val_int(flow_control));
  }
#else // Windows
#error "not implemented"
#endif

  CAMLreturn(config);
}

CAMLprim value caml_configure_serial_port(value unix_fd, value config)
{
  CAMLparam2(unix_fd, config);

  const int fd = Int_val(unix_fd);

  const int baud_rate = Int_val(Field(config, 0));
  const uint8_t data_bits = Int_val(Field(config, 1));
  const parity_t parity = Int_val(Field(config, 2));
  const uint8_t stop_bits = Int_val(Field(config, 3));
  const flow_control_t flow_control = Int_val(Field(config, 4));

#if defined(__linux__) || defined(__APPLE__)
  struct termios options;

  if (tcgetattr(fd, &options) < 0)
    caml_failwith("failed to get attributes of serial port");

  ////////////////////////////////////////////////
  // GENERAL CONFIGURATION

  // raw input mode
  options.c_lflag &= (tcflag_t) ~(ICANON | ECHO | ECHOE | ISIG);

  // maintain carriage return on input, and don't translate it
  options.c_iflag &= (tcflag_t) ~(IGNCR | ICRNL | INLCR);

  // raw output mode
  options.c_oflag &= (tcflag_t)~OPOST;

  options.c_cc[VTIME] = 0;
  options.c_cc[VMIN] = 0;

  options.c_cflag &= (tcflag_t) ~(HUPCL);
  options.c_cflag |= CREAD | CLOCAL;

  ////////////////////////////////////////////////
  // SETUP BAUD RATE SPEED
  cfsetospeed(&options, baud_rate);
  cfsetispeed(&options, baud_rate);

  ////////////////////////////////////////////////
  // SETUP PARITY
  switch (parity)
  {
  case NO_PARITY:
    options.c_cflag &= (tcflag_t)~PARENB;
    break;
  case EVEN_PARITY:
    options.c_cflag |= PARENB;
    options.c_cflag &= (tcflag_t)~PARODD;
    break;
  case ODD_PARITY:
    options.c_cflag |= PARENB;
    options.c_cflag |= PARODD;
    break;
  }

  ////////////////////////////////////////////////
  // SETUP STOP BITS

  if (stop_bits == 2)
    options.c_cflag |= CSTOPB;
  else // 1
    options.c_cflag &= (tcflag_t)~CSTOPB;

  ////////////////////////////////////////////////
  // FLUSH DATA ON EACH WRITE
  // if (HAS_OPTION('W'))
  //   options.c_lflag |= NOFLSH;

  ////////////////////////////////////////////////
  // SETUP CHARACTER SIZE
  options.c_cflag &= (tcflag_t)~CSIZE;

  switch (data_bits)
  {
  case 8:
    options.c_cflag |= CS8;
    break;
  case 7:
    options.c_cflag |= CS7;
    break;
  case 6:
    options.c_cflag |= CS6;
    break;
  case 5:
    options.c_cflag |= CS5;
    break;
  }

  ////////////////////////////////////////////////
  // SETUP FLOW CONTROL

  if (flow_control == HARDWARE_FLOW_CONTROL)
    options.c_cflag |= CRTSCTS;
  else
    options.c_cflag &= ~CRTSCTS;

  /* clear and set software flow control */
  options.c_iflag &= (tcflag_t) ~(IXON | IXOFF | IXANY);
  if (flow_control == SOFTWARE_FLOW_CONTROL)
    options.c_iflag |= IXON | IXOFF;

  ////////////////////////////////////////////////
  // APPLY THE OPTIONS

  tcflush(fd, TCIOFLUSH);

  if (tcsetattr(fd, TCSANOW, &options) < 0)
    caml_failwith("failed to apply the configuration's options");

#else // Windows
#error "not implemented"
#endif

  CAMLreturn(Val_unit);
}

CAMLprim value caml_get_serial_port_pin(value unix_fd, value pin)
{
  CAMLparam2(unix_fd, pin);
  CAMLlocal1(res);

#if defined(__linux__) || defined(__APPLE__)
  int status;

  if (ioctl(Int_val(unix_fd), TIOCMGET, &status) < 0)
    caml_failwith("failed to get all modem bits");

  switch (Int_val(pin))
  {
  case SERIAL_PORT_PIN_CTS:
    res = Val_bool((status & TIOCM_CTS) ? 1 : 0);
  case SERIAL_PORT_PIN_DSR:
    res = Val_bool((status & TIOCM_DSR) ? 1 : 0);
  case SERIAL_PORT_PIN_DCD:
    res = Val_bool((status & TIOCM_CAR) ? 1 : 0);
  case SERIAL_PORT_PIN_RI:
    res = Val_bool((status & TIOCM_RI) ? 1 : 0);
  case SERIAL_PORT_PIN_RTS:
    res = Val_bool((status & TIOCM_RTS) ? 1 : 0);
  default:
    caml_invalid_argument("illegal serial port's pin for getting");
  }

#else // Windows
#error "not implemented"
#endif

  CAMLreturn(res);
}

CAMLprim value caml_set_serial_port_pin(value unix_fd, value pin, value high)
{
  CAMLparam3(unix_fd, pin, high);

#if defined(__linux__) || defined(__APPLE__)
  int bits;

  switch (Int_val(pin))
  {
  case SERIAL_PORT_PIN_RTS:
    bits = TIOCM_RTS;
    break;
  case SERIAL_PORT_PIN_DTR:
    bits = TIOCM_DTR;
    break;
  default:
    caml_invalid_argument("illegal serial port's pin for setting");
  }

  if (ioctl(Int_val(unix_fd), Bool_val(high) ? TIOCMBIS : TIOCMBIC, &bits) < 0)
    caml_failwith("failed to set modems bits");
#else // Windows
#error "not implemented"
#endif

  CAMLreturn(Val_unit);
}

CAMLprim value caml_send_break_signal_to_serial_port(value unix_fd)
{
  CAMLparam1(unix_fd);

#ifdef __linux__
  if (ioctl(Int_val(unix_fd), TCSBRK, 1) < 0)
    goto fail;
#elif defined(__APPLE__)
  if (tcsendbreak(Int_val(unix_fd), 1) < 0)
    goto fail;
#else // Windows
#error "not implemented"
#endif

fail:
  caml_failwith("failed to send break signal to serial port");

  CAMLreturn(Val_unit);
}