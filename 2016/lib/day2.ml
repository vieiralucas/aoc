type instruction = U | D | L | R [@@deriving show]

let parse_line (line : string) : instruction list =
  let char_to_instruction c =
    match c with
    | 'U' -> U
    | 'D' -> D
    | 'L' -> L
    | 'R' -> R
    | _ -> failwith "Invalid instruction character"
  in
  line |> String.trim |> String.to_seq |> Seq.map char_to_instruction |> List.of_seq

let parse_input (input : string) : instruction list list =
  input |> String.split_on_char '\n'
  |> List.filter_map (fun line ->
         let line = String.trim line in
         if String.length line > 0 then Some (parse_line line) else None)

let pos_to_digit = function
  | 0, 0 -> 1
  | 1, 0 -> 2
  | 2, 0 -> 3
  | 0, 1 -> 4
  | 1, 1 -> 5
  | 2, 1 -> 6
  | 0, 2 -> 7
  | 1, 2 -> 8
  | 2, 2 -> 9
  | x, y -> failwith (Printf.sprintf "invalid position: (%d, %d)" x y)

let step (x, y) instruction =
  match instruction with
  | L -> (max 0 (x - 1), y)
  | R -> (min 2 (x + 1), y)
  | U -> (x, max 0 (y - 1))
  | D -> (x, min 2 (y + 1))

let walk pos instructions = List.fold_left step pos instructions

let part1 (input : string) : string =
  let all_instructions = parse_input input in
  let rec iter pos digits = function
    | [] -> digits
    | instructions :: rest ->
        let pos = walk pos instructions in
        let digit = pos_to_digit pos in
        let digits = List.cons digit digits in
        if List.length rest == 0 then List.rev digits else iter pos digits rest
  in
  let digits = iter (0, 0) [] all_instructions in
  let result = List.map string_of_int digits |> String.concat "" in
  result

let part2 (_input : string) : string = "not implemented"
