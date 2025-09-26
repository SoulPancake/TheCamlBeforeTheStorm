// 
open Core


let () =
  let open Command.Let_syntax in
  let%map_open () = return () in
  (* Your command logic goes here *)
  print_endline "Hello, World!"

  (* 
    I want to create a simple CLI projectile app, that shows a rocket projectile in ASCII
     *)

let rocket_ascii_art =
        "       /\\\n\
         /\\  //\\\\\n\
        //\\\\//  \\\\\n\
        \\//\\/\n\
         \\/
                \n\
        \n\
        \n\
        \n\
        \n\
        \n\
        \n\
        \n\
                
        \n\
                
                        
                                
                                        
        \n\
        \n\"
let print_rocket () =
  print_endline rocket_ascii_art                

let () =
  let open Command.Let_syntax in
  let%map_open () = return () in
  print_rocket ();
  print_endline "Rocket launched!"
  
(* To run the command, you can use:
   dune exec ./main.exe *)


   function main () =
           let open Command.Let_syntax in
                  let%map_open () = return () in
                        print_rocket ();
