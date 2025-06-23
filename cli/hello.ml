let name = ref "autumn"

let speclist = [
  ("-name", Arg.Set_string name, "Name to greet");
]

let usage_msg = "Usage: hello [-name YOUR_NAME]"

let () =
  Arg.parse speclist print_endline usage_msg;
  Printf.printf "Hello, %s!\n" !name
