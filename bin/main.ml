open Fr_webserver.Feral

let () =
  let server_socket = start_server 8080 in
  accept_connections server_socket
