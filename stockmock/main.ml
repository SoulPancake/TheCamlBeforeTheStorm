(* stockmock/main.ml *)

open Lwt.Infix
open Notty
open Notty_lwt

let fetch_stock_price symbol =
  let url = Printf.sprintf "https://query1.finance.yahoo.com/v7/finance/quote?symbols=%s" symbol in
  Cohttp_lwt_unix.Client.get (Uri.of_string url) >>= fun (_, body) ->
  Cohttp_lwt.Body.to_string body >|= fun body_str ->
  let json = Yojson.Safe.from_string body_str in
  let open Yojson.Safe.Util in
  try
    let price =
      json
      |> member "quoteResponse"
      |> member "result"
      |> to_list
      |> List.hd
      |> member "regularMarketPrice"
      |> to_float
    in
    Some price
  with _ -> None

let fetch_stock_history symbol =
  (* For demo: generate fake data. Replace with real API for history. *)
  Lwt.return (Array.init 30 (fun i -> 100. +. (Random.float 10. -. 5.)))

let draw_graph data =
  let max_v = Array.fold_left max data.(0) data in
  let min_v = Array.fold_left min data.(0) data in
  let height = 10 in
  let width = Array.length data in
  let scale v = int_of_float ((v -. min_v) /. (max_v -. min_v +. 0.01) *. float_of_int (height - 1)) in
  let rows = Array.make_matrix height width ' ' in
  Array.iteri (fun x v ->
    let y = height - 1 - scale v in
    if y >= 0 && y < height then rows.(y).(x) <- '#') data;
  let lines = Array.map (fun row -> String.init width (fun i -> row.(i))) rows in
  I.vcat (List.map (fun s -> I.string A.empty s) (Array.to_list lines))

let draw_ui symbol price_opt graph_img input =
  let price_str = match price_opt with
    | Some p -> Printf.sprintf "Current price: $%.2f" p
    | None -> "Price not found"
  in
  I.vcat [
    I.string A.(st bold) "Stock TUI";
    I.string A.empty ("Symbol: " ^ symbol);
    I.string A.empty price_str;
    graph_img;
    I.string A.empty "";
    I.string A.empty ("> " ^ input);
    I.string A.empty "Type a symbol and press Enter. Press q to quit."
  ]

let rec event_loop term symbol input =
  fetch_stock_price symbol >>= fun price_opt ->
  fetch_stock_history symbol >>= fun history ->
  let graph_img = draw_graph history in
  let img = draw_ui symbol price_opt graph_img input in
  Term.image term img >>= fun () ->
  Lwt_stream.get (Term.events term) >>= function
  | Some (`Key (`ASCII 'q', _)) -> Lwt.return_unit
  | Some (`Key (`Enter, _)) when input <> "" ->
      event_loop term input ""
  | Some (`Key (`ASCII c, _)) when Char.code c >= 32 && Char.code c < 127 ->
      event_loop term symbol (input ^ String.make 1 c)
  | Some (`Key (`Backspace, _)) | Some (`Key (`Delete, _)) ->
      let len = String.length input in
      let input' = if len > 0 then String.sub input 0 (len - 1) else "" in
      event_loop term symbol input'
  | _ -> event_loop term symbol input

let () =
  let term = Term.create () in
  Lwt_main.run (event_loop term "AAPL" "")
