module IOVec = H1.IOVec

type t = Ws_connection.t
type error = [ `Exn of exn ]

let create ~websocket_handler =
  let t = Ws_connection.create ~mode:`Server ~websocket_handler in
  t

let next_read_operation = Ws_connection.next_read_operation
let next_write_operation = Ws_connection.next_write_operation
let read t bs ~off ~len = Ws_connection.read t bs ~off ~len
let read_eof t bs ~off ~len = Ws_connection.read_eof t bs ~off ~len
let report_write_result t result = Ws_connection.report_write_result t result
let yield_writer t f = Ws_connection.yield_writer t f
let is_closed t = Ws_connection.is_closed t
let close t = Ws_connection.close t
