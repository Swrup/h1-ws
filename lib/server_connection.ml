module IOVec = H1.IOVec

type t = Websocket_connection.t

type error = Websocket_connection.error

let create ~websocket_handler =
  let t = Websocket_connection.create ~mode:`Server ~websocket_handler in
  t

let next_read_operation = Websocket_connection.next_read_operation
let next_write_operation = Websocket_connection.next_write_operation

let read t bs ~off ~len = Websocket_connection.read t bs ~off ~len

let read_eof t bs ~off ~len = Websocket_connection.read_eof t bs ~off ~len

let report_write_result t result = Websocket_connection.report_write_result t result

let yield_writer t f = Websocket_connection.yield_writer t f

let is_closed t = Websocket_connection.is_closed t
let close t = Websocket_connection.close t
