open Lwt.Infix
open Cohttp
open Cohttp_lwt_unix

let post_json ~url ~body =
  let url = Uri.of_string url in
  let headers = Header.init_with "Content-Type" "application/json" in
  let body = Yojson.Safe.to_string body |> Cohttp_lwt.Body.of_string in
  Client.post ~headers ~body url >>= fun (resp, body_stream) ->
  Cohttp_lwt.Body.to_string body_stream >>= fun body_str ->
  Lwt.return (resp, body_str)

