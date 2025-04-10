module IOVec = H1.IOVec

type t

type error =
  [ H1.Client_connection.error
  | `Handshake_failure of H1.Response.t * H1.Body.Reader.t ]

val create
  :  nonce             : string
  -> host              : string
  -> port              : int
  -> resource          : string
  -> sha1              : (string -> string)
  -> error_handler     : (error -> unit)
  -> websocket_handler : (Wsd.t -> Websocket.input_handlers)
  -> t

val next_read_operation  : t -> [ `Read | `Close ]
val next_write_operation : t -> [ `Write of Bigstringaf.t IOVec.t list | `Yield | `Close of int ]

val read : t -> Bigstringaf.t -> off:int -> len:int -> int
val read_eof : t -> Bigstringaf.t -> off:int -> len:int -> int

val report_write_result : t -> [`Ok of int | `Closed ] -> unit

val yield_writer : t -> (unit -> unit) -> unit

val close : t -> unit
