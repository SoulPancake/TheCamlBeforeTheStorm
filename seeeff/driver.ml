(* Driver code for Codeforces problems *)

(* Function to read input from stdin *)
let read_input () =
  let line = read_line () in
  Scanf.sscanf line "%d %d" (fun x d -> (x, d))

(* Function to solve the problem *)
let solve (x, d) =
  if x = d then "double it"
  else "string"

(* Main driver function *)
let () =
  let (x, d) = read_input () in
  let result = solve (x, d) in
  print_endline result
