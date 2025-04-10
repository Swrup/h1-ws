module IOVec = H1.IOVec

type t = { connection : H1.Client_connection.t; body : H1.Body.Writer.t }

let create ~nonce ~host ~port ~resource ~error_handler ~response_handler =
  let headers =
    [
      ("upgrade", "websocket");
      ("connection", "upgrade");
      ("host", String.concat ":" [ host; string_of_int port ]);
      ("sec-websocket-version", "13");
      ("sec-websocket-key", nonce);
    ]
    |> H1.Headers.of_list
  in
  let body, connection =
    H1.Client_connection.request
      (H1.Request.create ~headers `GET resource)
      ~error_handler ~response_handler
  in
  { connection; body }

let next_read_operation t =
  H1.Client_connection.next_read_operation t.connection

let next_write_operation t =
  H1.Client_connection.next_write_operation t.connection

let read t = H1.Client_connection.read t.connection

let report_write_result t =
  H1.Client_connection.report_write_result t.connection

let yield_writer t = H1.Client_connection.yield_writer t.connection
let close t = H1.Body.Writer.close t.body
