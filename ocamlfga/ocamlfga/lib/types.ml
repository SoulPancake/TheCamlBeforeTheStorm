type check_request = {
  user: string;
  relation: string;
  object_: string;
} [@@deriving yojson]

type check_response = {
  allowed: bool;
} [@@deriving yojson]



