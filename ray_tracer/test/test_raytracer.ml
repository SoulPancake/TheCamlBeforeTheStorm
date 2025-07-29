open Raytracer

(* Test helper functions *)
let float_equal a b = abs_float (a -. b) < 1e-6

let vec3_equal v1 v2 = 
  float_equal v1.x v2.x && float_equal v1.y v2.y && float_equal v1.z v2.z

(* Test vector operations *)
let test_vector_operations () =
  let v1 = vec3 1. 2. 3. in
  let v2 = vec3 4. 5. 6. in
  
  (* Test addition *)
  let sum = add v1 v2 in
  assert (vec3_equal sum (vec3 5. 7. 9.));
  
  (* Test subtraction *)
  let diff = sub v2 v1 in
  assert (vec3_equal diff (vec3 3. 3. 3.));
  
  (* Test scaling *)
  let scaled = scale v1 2. in
  assert (vec3_equal scaled (vec3 2. 4. 6.));
  
  (* Test dot product *)
  let dot_product = dot v1 v2 in
  assert (float_equal dot_product 32.);
  
  (* Test length *)
  let v3 = vec3 3. 4. 0. in
  let len = length v3 in
  assert (float_equal len 5.);
  
  (* Test normalization *)
  let normalized = normalize v3 in
  assert (float_equal (length normalized) 1.);
  
  print_endline "✓ Vector operations tests passed"

(* Test ray-sphere intersection *)
let test_ray_sphere_intersection () =
  let sphere = { center = vec3 0. 0. 0.; radius = 1. } in
  
  (* Ray that hits the sphere *)
  let ray1 = { origin = vec3 (-2.) 0. 0.; direction = normalize (vec3 1. 0. 0.) } in
  (match intersect_sphere ray1 sphere with
   | Some t -> 
     let hit_point = point_at_ray ray1 t in
     assert (float_equal hit_point.x (-1.));
     assert (float_equal (length (sub hit_point sphere.center)) sphere.radius)
   | None -> failwith "Ray should intersect sphere");
  
  (* Ray that misses the sphere *)
  let ray2 = { origin = vec3 (-2.) 2. 0.; direction = normalize (vec3 1. 0. 0.) } in
  (match intersect_sphere ray2 sphere with
   | Some _ -> failwith "Ray should not intersect sphere"
   | None -> ());
  
  print_endline "✓ Ray-sphere intersection tests passed"

(* Test sphere normal calculation *)
let test_sphere_normal () =
  let sphere = { center = vec3 0. 0. 0.; radius = 1. } in
  let point = vec3 1. 0. 0. in
  let normal = sphere_normal sphere point in
  assert (vec3_equal normal (vec3 1. 0. 0.));
  assert (float_equal (length normal) 1.);
  
  print_endline "✓ Sphere normal tests passed"

(* Test shading calculation *)
let test_shading () =
  let light = { position = vec3 2. 2. 2.; intensity = 1. } in
  let sphere = { center = vec3 0. 0. 0.; radius = 1. } in
  let hit_point = vec3 1. 0. 0. in
  let normal = vec3 1. 0. 0. in
  
  let shading = shade light sphere hit_point normal in
  assert (shading >= 0. && shading <= 1.);
  
  print_endline "✓ Shading tests passed"

(* Run all tests *)
let () =
  print_endline "Running ray tracer tests...";
  test_vector_operations ();
  test_ray_sphere_intersection ();
  test_sphere_normal ();
  test_shading ();
  print_endline "All tests passed! ✅"