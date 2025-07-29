open Graphics
open Raytracer

(* Simple non-interactive test to verify rendering *)
let test_render () =
  let width = 400 in
  let height = 300 in
  
  (* Simple scene setup *)
  let sphere = { center = vec3 0. 0. (-5.); radius = 1. } in
  let light_pos = vec3 3. 2. (-3.) in
  let light = { position = light_pos; intensity = 1. } in
  
  (* Convert screen coordinates to world ray *)
  let screen_to_ray x y =
    let aspect = float_of_int width /. float_of_int height in
    let fov = 45. *. 3.14159265359 /. 180. in
    let half_height = tan (fov /. 2.) in
    let half_width = aspect *. half_height in
    
    let u = (float_of_int x /. float_of_int width -. 0.5) *. 2. *. half_width in
    let v = (0.5 -. float_of_int y /. float_of_int height) *. 2. *. half_height in
    
    let direction = normalize (vec3 u v (-1.)) in
    { origin = vec3 0. 0. 0.; direction }
  in
  
  (* Trace a ray and return color intensity *)
  let trace_ray ray =
    match intersect_sphere ray sphere with
    | None -> 0.  (* Background *)
    | Some t ->
      let hit_point = point_at_ray ray t in
      let normal = sphere_normal sphere hit_point in
      shade light sphere hit_point normal
  in
  
  (* Open graphics window *)
  open_graph (Printf.sprintf " %dx%d" width height);
  set_window_title "OCaml Ray Tracer Test";
  
  (* Render the scene *)
  print_endline "Rendering test scene...";
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      let ray = screen_to_ray x y in
      let intensity = trace_ray ray in
      let color_value = int_of_float (intensity *. 255.) in
      let color = rgb color_value color_value color_value in
      set_color color;
      plot x y
    done;
    if y mod 50 = 0 then print_endline (Printf.sprintf "Rendered %d/%d lines" y height)
  done;
  
  print_endline "Rendering complete! Close window to exit.";
  
  (* Wait for window close *)
  try
    ignore (wait_next_event [Key_pressed; Button_down]);
    close_graph ()
  with
  | Graphic_failure _ -> close_graph ()

let () = test_render ()