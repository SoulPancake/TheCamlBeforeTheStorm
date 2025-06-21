include module type of Types
include Types
let check = Check.check

type check_request = {
  user: string;
  relation: string;
  object_: string;
}

type check_response = {
  allowed: bool;
}

val check : base_url:string -> store_id:string -> request:Types.check_request -> Types.check_response Lwt.t 