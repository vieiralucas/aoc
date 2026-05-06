module CharMap = Map.Make (Char)

let parse_line line =
  let line = String.split_on_char '[' line in
  let name_and_id = List.take 1 line |> List.hd in
  let checksum = List.drop 1 line |> List.hd in
  let checksum = String.sub checksum 0 (String.length checksum - 1) in
  let name_parts = String.split_on_char '-' name_and_id in
  let name = List.take (List.length name_parts - 1) name_parts |> String.concat "" in
  let id = List.drop (List.length name_parts - 1) name_parts |> List.hd in
  (id, (name, checksum))

let checksum_from_counts map =
  CharMap.to_list map
  |> List.sort (fun (c1, n1) (c2, n2) ->
         let ncomp = compare n1 n2 in
         if ncomp == 0 then compare c1 c2 else ncomp * -1)
  |> List.map fst
  |> List.to_seq
  |> String.of_seq

let count_chars (s : string) : int CharMap.t =
  String.fold_left
    (fun acc c ->
      CharMap.update c (function Some n -> Some (n + 1) | None -> Some 1) acc)
    CharMap.empty s

let is_valid name checksum =
  let counts = count_chars name in
  let actual = checksum_from_counts counts in
  let actual = String.sub actual 0 (String.length checksum) in
  actual = checksum

let part1 input =
  let lines = String.trim input |> String.split_on_char '\n' in
  let result =
    List.map parse_line lines
    |> List.filter (fun (_, (name, checksum)) -> is_valid name checksum)
    |> List.map fst
    |> List.map int_of_string
    |> List.fold_left ( + ) 0
  in
  string_of_int result

let part2 _input = "not implemented"
