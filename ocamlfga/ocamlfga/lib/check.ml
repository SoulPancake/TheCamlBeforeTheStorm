open Lwt.Infix
open Types
open Openfga
open Cohttp 

let check ~base_url ~store_id ~request =
 let path = "/stores" ^ store_id ^ "/authorize/check"  in 
let url = base_url ^ path in 
let json_body = check_request_to_yojson request in 
post_json ~url ~body:json_body >>= fun (resp, body_str) ->
 match Response.status resp with
 | `OK -> 
   begin match Yojson.Safe.from_string body_str |> check_response_of_yojson with 
   | Ok response -> Lwt.return response 
   | Error e -> Lwt.fail_with("Parse error: " ^ e)
   end
  | _ -> Lwt.fail_with("Request failed: " ^ body_str)


