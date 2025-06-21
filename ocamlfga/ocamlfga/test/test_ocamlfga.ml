open Ocamlfga
open Types
open Check
let () =
  let base_url = "http://localhost:8079" in
  let store_id = "default" in
  let request = {
    user = "user:123";
    relation = "member";
    object_ = "group:admin"
  } in
  let open Lwt.Infix in
  Lwt_main.run (
    check ~base_url ~store_id ~request >|= fun response ->
    print_endline (Yojson.Safe.to_string (check_response_to_yojson response))
  )