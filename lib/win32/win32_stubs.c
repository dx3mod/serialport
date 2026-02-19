#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/unixsupport.h>

#include <Windows.h>

CAMLprim value caml_win32_setup_com_port_timeouts(value com_port) {
  HANDLE h_com_port = Handle_val(com_port);

  COMMTIMEOUTS timeouts = {0};
  timeouts.ReadIntervalTimeout = 50;
  timeouts.ReadTotalTimeoutConstant = 50;
  timeouts.ReadTotalTimeoutMultiplier = 10;
  timeouts.WriteTotalTimeoutConstant = 50;
  timeouts.WriteTotalTimeoutMultiplier = 10;

  if (SetCommTimeouts(h_com_port, &timeouts) == FALSE)
    caml_failwith("fail SetCommTimeouts");

  if (SetCommMask(h_com_port, EV_RXCHAR) == FALSE)
    caml_failwith("fail SetCommMask");

  return Val_unit;
}

CAMLprim value caml_win32_set_com_port_dcb(value com_port, value baudrate,
                                           value databits, value stopbits,
                                           value parity) {
  CAMLparam5(com_port, baudrate, databits, stopbits, parity);

  HANDLE h_com_port = Handle_val(com_port);

  DCB dcbSerialParams = {0};
  dcbSerialParams.DCBlength = sizeof(dcbSerialParams);

  if (GetCommState(h_com_port, &dcbSerialParams) == FALSE)
    caml_failwith("failed to get COM port state to DCB params");

  dcbSerialParams.BaudRate = Int_val(baudrate);
  dcbSerialParams.ByteSize = Int_val(databits);
  dcbSerialParams.StopBits = Int_val(stopbits) == 1 ? 0 : 2;
  dcbSerialParams.Parity = Int_val(parity);

  if (SetCommState(h_com_port, &dcbSerialParams) == FALSE)
    caml_failwith("failed to set COM port state by DCB params");

  CAMLreturn(Val_unit);
}

CAMLprim value caml_serial_port_flush(value com_port) {
  HANDLE h_com_port = Handle_val(com_port);

  PurgeComm(h_com_port, PURGE_RXCLEAR | PURGE_TXCLEAR);

  return Val_unit;
}

CAMLprim value caml_set_serial_port_pin(value com_port, value serial_lines,
                                        value enable) {
  CAMLparam3(com_port, serial_lines, enable);

  HANDLE h_com_port = Handle_val(com_port);

  DCB dcbSerialParams = {0};
  dcbSerialParams.DCBlength = sizeof(dcbSerialParams);

  if (GetCommState(h_com_port, &dcbSerialParams) == FALSE)
    caml_failwith("failed to get COM port state to DCB params");

  if (Int_val(serial_lines) == 0) {
    dcbSerialParams.fRtsControl = Bool_val(enable);
  } else {
    dcbSerialParams.fDtrControl = Bool_val(enable);
  }

  if (SetCommState(h_com_port, &dcbSerialParams) == FALSE)
    caml_failwith("failed to set COM port state by DCB params");

  CAMLreturn(Val_unit);
}
