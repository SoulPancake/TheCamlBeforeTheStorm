open Raytracer

(* ASCII art renderer test *)
let test_ascii_render () =
  let width = 80 in
  let height = 40 in
  
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
  
  (* Convert intensity to ASCII character *)
  let intensity_to_char intensity =
    let chars = [|' '; '.'; ':'; '-'; '='; '+'; '*'; '#'; '%'; '@'|] in
    let index = int_of_float (intensity *. float_of_int (Array.length chars - 1)) in
    let clamped_index = max 0 (min (Array.length chars - 1) index) in
    chars.(clamped_index)
  in
  
  (* Render the scene *)
  print_endline "ASCII Ray Tracer Test:";
  print_endline "======================";
  for y = 0 to height - 1 do
    let line = Buffer.create width in
    for x = 0 to width - 1 do
      let ray = screen_to_ray x y in
      let intensity = trace_ray ray in
      let char = intensity_to_char intensity in
      Buffer.add_char line char
    done;
    print_endline (Buffer.contents line)
  done;
  
  print_endline "======================";
  print_endline "Ray tracer rendering test complete! ✅"

let () = test_ascii_render ()