let is_triangle (a, b, c) =
  let sides = List.sort compare [ a; b; c ] in
  match sides with [ x; y; z ] -> x + y > z | _ -> false

let parse_line_pt1 line =
  let as_list =
    String.split_on_char ' ' line
    |> List.filter (fun l -> String.trim l |> String.length > 0)
    |> List.map (Fun.compose int_of_string String.trim)
  in
  match as_list with [ a; b; c ] -> (a, b, c) | _ -> failwith ("Invalid line: " ^ line)

let parse_input_pt1 input =
  String.trim input |> String.split_on_char '\n' |> List.map parse_line_pt1

let part1 (input : string) : string =
  let potential = parse_input_pt1 input in
  let posible_count = List.filter is_triangle potential |> List.length in
  string_of_int posible_count

module IntSet = Set.Make (struct
  type t = int

  let compare = compare
end)

let part2 (input : string) : string =
  let all_numbers =
    String.split_on_char '\n' input
    |> List.concat_map (String.split_on_char ' ')
    |> List.filter_map int_of_string_opt
  in
  let rec aux triples visited i list =
    match list with
    | a :: _ :: _ :: b :: _ :: _ :: c :: _ ->
        let triples, visited =
          if IntSet.mem i visited then (triples, visited)
          else
            ( (a, b, c) :: triples,
              IntSet.add i visited |> IntSet.add (i + 3) |> IntSet.add (i + 6) )
        in
        aux triples visited (i + 1) (List.drop 1 list)
    | _ -> triples
  in
  let triples = aux [] IntSet.empty 0 all_numbers in
  let posible = List.filter is_triangle triples in
  string_of_int (List.length posible)
