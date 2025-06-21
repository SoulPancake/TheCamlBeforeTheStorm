open Lwt

type check_request = {
  user: string;
  relation: string;
  object_: string;
}

type check_response = {
  allowed: bool;
}

val check : base_url:string -> store_id:string -> request:check_request -> check_response Lwt.t 