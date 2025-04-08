module IOVec = H1.IOVec

type error = [ `Exn of exn ]

type frame_handler =
    opcode:Websocket.Opcode.t -> is_fin:bool -> Bigstringaf.t -> off:int -> len:int -> unit

type input_handlers =
  { frame_handler : frame_handler
  ; eof   : unit -> unit }

type t =
  { wsd    : Wsd.t
  ; reader : [`Parse of string list * string] Reader.t
  ; eof : unit -> unit
  }

let create ~mode ~websocket_handler =
  let wsd          = Wsd.create mode in
  let { frame_handler; eof } = websocket_handler wsd in
  { wsd
  ; reader = Reader.create frame_handler
  ; eof
  }

let next_read_operation t =
  Reader.next t.reader

let next_write_operation t =
  Wsd.next t.wsd

let read t bs ~off ~len =
  Reader.read_with_more t.reader bs ~off ~len Incomplete

let read_eof t bs ~off ~len =
  let len = Reader.read_with_more t.reader bs ~off ~len Complete in
  t.eof ();
  len

let is_closed t = Wsd.is_closed t.wsd

let close t =
  Wsd.close t.wsd

let yield_writer t k =
  if is_closed t
  then begin
    close t;
    k ()
  end else
    Wsd.when_ready_to_write t.wsd k

let report_write_result t result =
  Wsd.report_result t.wsd result
