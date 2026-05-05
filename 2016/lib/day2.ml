type instruction = U | D | L | R [@@deriving show]
type pos = int * int [@@deriving show]

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

let pos_to_digit1 = function
  | 0, 0 -> Some '1'
  | 1, 0 -> Some '2'
  | 2, 0 -> Some '3'
  | 0, 1 -> Some '4'
  | 1, 1 -> Some '5'
  | 2, 1 -> Some '6'
  | 0, 2 -> Some '7'
  | 1, 2 -> Some '8'
  | 2, 2 -> Some '9'
  | _, _ -> None

let pos_to_digit2 = function
  | 0, 0 -> None
  | 1, 0 -> None
  | 2, 0 -> Some '1'
  | 3, 0 -> None
  | 4, 0 -> None
  | 0, 1 -> None
  | 1, 1 -> Some '2'
  | 2, 1 -> Some '3'
  | 3, 1 -> Some '4'
  | 4, 1 -> None
  | 0, 2 -> Some '5'
  | 1, 2 -> Some '6'
  | 2, 2 -> Some '7'
  | 3, 2 -> Some '8'
  | 4, 2 -> Some '9'
  | 0, 3 -> None
  | 1, 3 -> Some 'A'
  | 2, 3 -> Some 'B'
  | 3, 3 -> Some 'C'
  | 4, 3 -> None
  | 0, 4 -> None
  | 1, 4 -> None
  | 2, 4 -> Some 'D'
  | 3, 4 -> None
  | 4, 4 -> None
  | _, _ -> None

let step pos_to_digit (x, y) instruction =
  let pos =
    match instruction with
    | L -> (x - 1, y)
    | R -> (x + 1, y)
    | U -> (x, y - 1)
    | D -> (x, y + 1)
  in
  if Option.is_some (pos_to_digit pos) then pos else (x, y)

let walk pos instructions pos_to_digit =
  List.fold_left (step pos_to_digit) pos instructions

let solve input start pos_to_digit =
  let all_instructions = parse_input input in
  let rec iter pos digits = function
    | [] -> digits
    | instructions :: rest -> (
        let pos = walk pos instructions pos_to_digit in
        let digit = pos_to_digit pos in
        match digit with
        | Some digit ->
            let digits = List.cons digit digits in
            if List.length rest == 0 then List.rev digits else iter pos digits rest
        | None -> iter pos digits rest)
  in
  let result = iter start [] all_instructions |> List.to_seq |> String.of_seq in
  result

let part1 (input : string) : string = solve input (0, 0) pos_to_digit1
let part2 (input : string) : string = solve input (0, 2) pos_to_digit2
