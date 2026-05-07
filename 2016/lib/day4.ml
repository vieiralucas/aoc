let parse_line line =
  match String.split_on_char '[' line with
  | [ name_and_id; checksum_bracket ] ->
      let checksum = String.sub checksum_bracket 0 (String.length checksum_bracket - 1) in
      let parts = String.split_on_char '-' name_and_id in
      let id = List.hd (List.rev parts) |> int_of_string in
      let name = List.rev (List.tl (List.rev parts)) in
      (name, id, checksum)
  | _ -> failwith ("bad line: " ^ line)

let checksum_from_counts counts =
  Hashtbl.to_seq counts
  |> List.of_seq
  |> List.sort (fun (c1, n1) (c2, n2) ->
         match compare n2 n1 with 0 -> compare c1 c2 | n -> n)
  |> List.map fst
  |> List.to_seq
  |> Seq.take 5
  |> String.of_seq

let count_chars s =
  let counts = Hashtbl.create 26 in
  String.iter
    (fun c ->
      let n = Hashtbl.find_opt counts c |> Option.value ~default:0 in
      Hashtbl.replace counts c (n + 1))
    s;
  counts

let is_valid name checksum =
  checksum_from_counts (count_chars (String.concat "" name)) = checksum

let lines str = String.trim str |> String.split_on_char '\n'
let parse_rooms input = lines input |> List.map parse_line
let a_code = Char.code 'a'
let char_range = Char.code 'z' - Char.code 'a' + 1

let shift n c =
  let normalized = Char.code c - a_code in
  ((normalized + n) mod char_range) + a_code |> Char.chr

let decrypt key str = String.map (shift key) str
let decrypt_parts key hashed = List.map (decrypt key) hashed |> String.concat " "

let part1 input =
  parse_rooms input
  |> List.filter (fun (name, _, checksum) -> is_valid name checksum)
  |> List.map (fun (_, id, _) -> id)
  |> List.fold_left ( + ) 0
  |> string_of_int

let part2 input =
  parse_rooms input
  |> List.filter (fun (name, _, checksum) -> is_valid name checksum)
  |> List.map (fun (name, id, _) -> (id, decrypt_parts id name))
  |> List.find (fun (_, name) -> name = "northpole object storage")
  |> fst
  |> string_of_int
