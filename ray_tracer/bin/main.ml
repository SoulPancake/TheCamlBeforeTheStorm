open Graphics
open Raytracer

(* Window dimensions *)
let width = 800
let height = 600

(* Scene setup *)
let sphere = { center = vec3 0. 0. (-5.); radius = 1. }
let camera_origin = vec3 0. 0. 0.

(* Light position - initially to the right and above *)
let light_position = ref (vec3 3. 2. (-3.))

(* Convert screen coordinates to world ray *)
let screen_to_ray x y =
  let aspect = float_of_int width /. float_of_int height in
  let fov = 45. *. 3.14159265359 /. 180. in
  let half_height = tan (fov /. 2.) in
  let half_width = aspect *. half_height in
  
  let u = (float_of_int x /. float_of_int width -. 0.5) *. 2. *. half_width in
  let v = (0.5 -. float_of_int y /. float_of_int height) *. 2. *. half_height in
  
  let direction = normalize (vec3 u v (-1.)) in
  { origin = camera_origin; direction }

(* Trace a ray and return color intensity *)
let trace_ray ray =
  match intersect_sphere ray sphere with
  | None -> 0.  (* Background *)
  | Some t ->
    let hit_point = point_at_ray ray t in
    let normal = sphere_normal sphere hit_point in
    let current_light = { position = !light_position; intensity = 1. } in
    shade current_light sphere hit_point normal

(* Render the scene *)
let render () =
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      let ray = screen_to_ray x y in
      let intensity = trace_ray ray in
      let color_value = int_of_float (intensity *. 255.) in
      let color = rgb color_value color_value color_value in
      set_color color;
      plot x y
    done
  done

(* Handle keyboard input to move light *)
let handle_input () =
  if key_pressed () then (
    let key = read_key () in
    let step = 0.5 in
    match key with
    | 'a' -> light_position := add !light_position (vec3 (-.step) 0. 0.)
    | 'd' -> light_position := add !light_position (vec3 step 0. 0.)
    | 'w' -> light_position := add !light_position (vec3 0. step 0.)
    | 's' -> light_position := add !light_position (vec3 0. (-.step) 0.)
    | 'q' -> light_position := add !light_position (vec3 0. 0. (-.step))
    | 'e' -> light_position := add !light_position (vec3 0. 0. step)
    | 'r' -> light_position := vec3 3. 2. (-3.)  (* Reset *)
    | _ -> ()
  )

(* Draw UI text *)
let draw_ui () =
  set_color black;
  moveto 10 (height - 30);
  draw_string "Ray Tracer - Move light: WASD (X/Y), Q/E (Z), R (reset)";
  moveto 10 (height - 50);
  let pos = !light_position in
  draw_string (Printf.sprintf "Light position: (%.1f, %.1f, %.1f)" pos.x pos.y pos.z)

(* Main application loop *)
let main_loop () =
  (* Initial render *)
  clear_graph ();
  render ();
  draw_ui ();
  
  (* Interactive loop *)
  let running = ref true in
  while !running do
    handle_input ();
    
    (* Re-render on space or enter *)
    if key_pressed () then (
      let key = read_key () in
      match key with
      | ' ' | '\r' ->
        clear_graph ();
        render ();
        draw_ui ()
      | '\027' -> running := false  (* Escape to quit *)
      | _ -> ()
    );
    
    Unix.sleepf 0.016  (* ~60 FPS *)
  done

(* Initialize and run *)
let () =
  open_graph (Printf.sprintf " %dx%d" width height);
  set_window_title "OCaml Ray Tracer";
  auto_synchronize false;
  
  print_endline "Ray Tracer GUI Started!";
  print_endline "Controls:";
  print_endline "  WASD - Move light X/Y";
  print_endline "  Q/E  - Move light Z";
  print_endline "  R    - Reset light position";
  print_endline "  SPACE/ENTER - Re-render";
  print_endline "  ESC  - Quit";
  
  try
    main_loop ();
    close_graph ()
  with
  | Graphic_failure _ -> 
    print_endline "Graphics window closed";
    close_graph ()
  | e -> 
    close_graph ();
    raise e