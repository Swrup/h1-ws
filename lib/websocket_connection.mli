module IOVec = H1.IOVec

type t

type error = [ `Exn of exn ]

type frame_handler =
    opcode:Websocket.Opcode.t -> is_fin:bool -> Bigstringaf.t -> off:int -> len:int -> unit

type input_handlers =
  { frame_handler : frame_handler
  ; eof   : unit -> unit }

val create
  :  mode:Wsd.mode -> websocket_handler : (Wsd.t -> input_handlers)
  -> t

val next_read_operation  : t -> [ `Read | `Close ]
val next_write_operation : t -> [ `Write of Bigstringaf.t IOVec.t list | `Yield | `Close of int ]

val read : t -> Bigstringaf.t -> off:int -> len:int -> int
val read_eof : t -> Bigstringaf.t -> off:int -> len:int -> int
val report_write_result : t -> [`Ok of int | `Closed ] -> unit

val yield_writer : t -> (unit -> unit) -> unit

val is_closed : t -> bool
val close : t -> unit
