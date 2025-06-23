open Cmdliner

(* Read file and return contents as a single string *)
let read_file filename =
  let ic = open_in filename in
  let n = in_channel_length ic in
  let s = really_input_string ic n in
  close_in ic;
  s

(* Tokenize string into words *)
let tokenize ?(lowercase=false) s =
  let s = if lowercase then String.lowercase_ascii s else s in
  let re = Str.regexp "[^a-zA-Z0-9']+" in
  Str.split re s

(* Count frequencies *)
let count_words words =
  let table = Hashtbl.create 100 in
  List.iter (fun word ->
    if word <> "" then
      Hashtbl.replace table word (1 + (Hashtbl.find_opt table word |> Option.value ~default:0))
  ) words;
  table

(* Print top N *)
let print_top table n =
  let word_freqs = Hashtbl.fold (fun word count acc -> (word, count) :: acc) table [] in
  let sorted = List.sort (fun (_, c1) (_, c2) -> compare c2 c1) word_freqs in
  List.iteri (fun i (word, count) ->
    if i < n then Printf.printf "%-15s %d\n" word count
  ) sorted

(* CLI glue *)
let run filename top lowercase =
  let content = read_file filename in
  let words = tokenize ~lowercase content in
  let table = count_words words in
  print_top table top

(* Cmdliner args *)
let filename_arg =
  let doc = "Input text file" in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"FILE" ~doc)

let top_arg =
  let doc = "Number of top words to show" in
  Arg.(value & opt int 10 & info ["top"] ~docv:"N" ~doc)

let lowercase_arg =
  let doc = "Convert words to lowercase before counting" in
  Arg.(value & flag & info ["lowercase"] ~doc)

let cmd =
  let doc = "Word frequency counter" in
  let info = Cmd.info "wordfreq" ~version:"0.1" ~doc in
  Cmd.v info Term.(const run $ filename_arg $ top_arg $ lowercase_arg)

let () = exit (Cmd.eval cmd)
