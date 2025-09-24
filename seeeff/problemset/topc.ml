(* Problem solution for TOPC (Take Or Pass Challenge) *)
(* https://codeforces.com/gym/106084/problem/A *)

(* Function to determine the decision *)
let topc_decision x d =
  if x > d then "take it"
  else "double it"

(* Function to read input from stdin *)
let read_input () =
  let line = read_line () in
  Scanf.sscanf line "%d %d" (fun x d -> (x, d))

(* Main function *)
let () =
  let (x, d) = read_input () in
  let result = topc_decision x d in
  print_endline result
