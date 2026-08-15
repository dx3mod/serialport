module Parity = struct
  type t = None | Odd | Even

  let of_char = function
    | 'N' -> None
    | 'E' -> Even
    | 'O' -> Odd
    | _ -> invalid_arg "illegal parity char (legal N/E/O)"

  let to_char = function None -> 'N' | Even -> 'E' | Odd -> 'O'
end

module Flow_control = struct
  type t = None | Hardware | Software

  let of_char = function
    | 'S' -> Software
    | 'H' -> Hardware
    | _ -> invalid_arg "illegal flow control char (legal F/H)"

  let pp_char ppf = function
    | Hardware -> Format.pp_print_char ppf 'H'
    | Software -> Format.pp_print_char ppf 'S'
    | None -> ()
end

type t = {
  baud_rate : int;
  data_bits : int;
  parity : Parity.t;
  stop_bits : int;
  flow_control : Flow_control.t;
}

let make ?(flow_control = Flow_control.None) ?(data_bits = 8)
    ?(parity = Parity.None) ?(stop_bits = 1) ~baud_rate () =
  assert (stop_bits = 1 || stop_bits = 2);
  assert (data_bits >= 5 && data_bits <= 8);

  { baud_rate; data_bits; parity; stop_bits; flow_control }

let of_string ~baud_rate s =
  match String.to_seq s |> List.of_seq with
  | data_bits :: parity :: stop_bits :: maybe_flow_control ->
      let flow_control =
        match maybe_flow_control with
        | [ flow_control ] -> Some Flow_control.(of_char flow_control)
        | _ -> None
      in

      make ?flow_control
        ~data_bits:(int_of_char data_bits - 48)
        ~parity:(Parity.of_char parity)
        ~stop_bits:(int_of_char stop_bits - 48)
        ~baud_rate ()
  | _ -> invalid_arg ""

let to_string c =
  Format.asprintf "%d%c%d%a" c.data_bits
    Parity.(to_char c.parity)
    c.stop_bits Flow_control.pp_char c.flow_control
