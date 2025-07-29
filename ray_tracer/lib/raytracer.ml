(* 3D Vector and Ray Tracing Math Library *)

(* 3D Vector type *)
type vec3 = { x: float; y: float; z: float }

(* Vector operations *)
let vec3 x y z = { x; y; z }

let add v1 v2 = { x = v1.x +. v2.x; y = v1.y +. v2.y; z = v1.z +. v2.z }

let sub v1 v2 = { x = v1.x -. v2.x; y = v1.y -. v2.y; z = v1.z -. v2.z }

let scale v s = { x = v.x *. s; y = v.y *. s; z = v.z *. s }

let dot v1 v2 = v1.x *. v2.x +. v1.y *. v2.y +. v1.z *. v2.z

let length v = sqrt (dot v v)

let normalize v = 
  let len = length v in
  if len > 0. then scale v (1. /. len) else v

(* Ray type *)
type ray = { origin: vec3; direction: vec3 }

(* Sphere type *)
type sphere = { center: vec3; radius: float }

(* Light source *)
type light = { position: vec3; intensity: float }

(* Ray-sphere intersection *)
let intersect_sphere ray sphere =
  let oc = sub ray.origin sphere.center in
  let a = dot ray.direction ray.direction in
  let b = 2. *. (dot oc ray.direction) in
  let c = (dot oc oc) -. (sphere.radius *. sphere.radius) in
  let discriminant = b *. b -. 4. *. a *. c in
  if discriminant < 0. then None
  else 
    let sqrt_d = sqrt discriminant in
    let t1 = (-.b -. sqrt_d) /. (2. *. a) in
    let t2 = (-.b +. sqrt_d) /. (2. *. a) in
    let t = if t1 > 0.001 then t1 else if t2 > 0.001 then t2 else -1. in
    if t > 0.001 then Some t else None

(* Calculate point along ray *)
let point_at_ray ray t = add ray.origin (scale ray.direction t)

(* Calculate normal at point on sphere *)
let sphere_normal sphere point = normalize (sub point sphere.center)

(* Simple shading calculation *)
let shade light _sphere hit_point normal =
  let light_dir = normalize (sub light.position hit_point) in
  let diffuse = max 0. (dot normal light_dir) in
  diffuse *. light.intensity