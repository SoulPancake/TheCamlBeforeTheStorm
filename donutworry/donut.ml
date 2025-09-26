open Unix

let pi = 3.14159265
let screen_width = 80
let screen_height = 24
let buffer_size = screen_width * screen_height

let a = ref 0.0
let b = ref 0.0

let z = Array.make buffer_size 0.0
let output = Array.make buffer_size ' '

let luminance = [| '.'; ','; '-'; '~'; ':'; ';'; '='; '!'; '*'; '#'; '$'; '@' |]

let clear_screen () = print_string "\027[H\027[2J"


let render_frame () =
  Array.fill z 0 buffer_size 0.0;
  Array.fill output 0 buffer_size ' ';

  let theta = ref 0.0 in
  while !theta < 2. *. pi do
    let phi = ref 0.0 in
    while !phi < 2. *. pi do
      let sin_phi = sin !phi
      and cos_phi = cos !phi in
      let sin_theta = sin !theta
      and cos_theta = cos !theta in
      let sin_a = sin !a
      and cos_a = cos !a
      and sin_b = sin !b
      and cos_b = cos !b in

      let circle_x = cos_theta +. 2.0 in
      let circle_y = sin_theta in

      let x = circle_x *. (cos_b *. cos_phi +. sin_a *. sin_b *. sin_phi)
      -. circle_y *. cos_a *. sin_b in
      let y = circle_x *. (sin_b *. cos_phi -. sin_a *. cos_b *. sin_phi)
      +. circle_y *. cos_a *. cos_b in
      let z_inv = 1.0 /. (circle_x *. sin_a *. sin_phi +. circle_y *. sin_a +. 5.0) in
      let ooz = z_inv in

      let xp = int_of_float (float_of_int screen_width /. 2. +. 30. *. x *. z_inv) in
      let yp = int_of_float (float_of_int screen_height /. 2. -. 15. *. y *. z_inv) in

      let luminance_index = int_of_float (8. *. ((cos_phi *. cos_theta *. sin_b) -. (cos_a *. cos_theta *. sin_phi) -. (sin_a *. sin_theta) +. (cos_b *. (cos_a *. sin_theta -. cos_theta *. sin_a *. sin_phi)))) in

      if 0 <= xp && xp < screen_width && 0 <= yp && yp < screen_height then
        let idx = xp + yp * screen_width in
        if ooz > z.(idx) then begin
          z.(idx) <- ooz;
          let lum = if luminance_index > 0 then luminance_index else 0 in
          let lum = if lum < Array.length luminance then lum else Array.length luminance - 1 in
          output.(idx) <- luminance.(lum)
        end;

      phi := !phi +. 0.02
    done;
    theta := !theta +. 0.07
  done;

  clear_screen ();
  for i = 0 to buffer_size - 1 do
    if i mod screen_width = 0 then print_newline ();
    print_char output.(i)
  done;

  flush Pervasives.stdout;
  a := !a +. 0.04;
  b := !b +. 0.02;
  Unix.sleepf 0.03

let () =
  while true do
    render_frame ();
    flush_all ();
    Unix.sleepf 0.03
  done
