open Unix

let serve_index (): string =
  let ch = open_in "index.html" in
  really_input_string ch (in_channel_length ch)

let start_server (port: file_perm): file_descr =
  print_endline ("Starting server on " ^ (string_of_int port));
  let sock = socket PF_INET SOCK_STREAM 0 in
  bind sock (ADDR_INET (inet_addr_loopback, port));
  listen sock 10;
  sock

let handle_request (client_sock: file_descr): unit =
  let buffer = Bytes.create 1024 in
  let len = recv client_sock buffer 0 (Bytes.length buffer) [] in
  if len > 0 then print_endline ("Received data " ^ (Bytes.sub_string buffer 0 len));

  (* append some HTML to this *)
  let response = ("HTTP/1.1 200 OK\r\n\r\n" ^ serve_index ()) in
  let _ = send client_sock (Bytes.of_string response) 0 (String.length response) [] in
  close client_sock

let accept_connections (sock: file_descr): unit =
  while true do
    let (client_sock, _) = accept sock in
    handle_request client_sock
  done
