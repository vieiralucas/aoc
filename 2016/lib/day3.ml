let is_triangle (a, b, c) = a + b > c && a + c > b && b + c > a
let parse_row line = String.split_on_char ' ' line |> List.filter_map int_of_string_opt
let parse_lines input = String.trim input |> String.split_on_char '\n'

let rec transpose = function
  | [] | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose (List.map List.tl rows)

let rec chunks3 = function a :: b :: c :: rest -> (a, b, c) :: chunks3 rest | _ -> []

let part1 (input : string) : string =
  parse_lines input
  |> List.map parse_row
  |> List.concat_map chunks3
  |> List.filter is_triangle
  |> List.length
  |> string_of_int

let part2 (input : string) : string =
  parse_lines input
  |> List.map parse_row
  |> transpose
  |> List.concat_map chunks3
  |> List.filter is_triangle
  |> List.length
  |> string_of_int
