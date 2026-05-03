type direction = N | S | E | W [@@deriving show]

let dir_c = function N -> "N" | S -> "S" | E -> "E" | W -> "W"

type turn = R | L [@@deriving show]

let turn dir turn =
  match (dir, turn) with
  | N, R -> E
  | E, R -> S
  | S, R -> W
  | W, R -> N
  | N, L -> W
  | W, L -> S
  | S, L -> E
  | E, L -> N

type instruction = { turn : turn; steps : int } [@@deriving show]
type pos = int * int [@@deriving show]
type state = { pos : pos; dir : direction } [@@deriving show]

let get_deltas dir =
  match dir with N -> (0, 1) | S -> (0, -1) | E -> (1, 0) | W -> (-1, 0)

let walk_step state dir instruction =
  let x, y = state.pos in
  let dx, dy = get_deltas dir in
  ({ pos = (x + dx, y + dy); dir }, { instruction with steps = instruction.steps - 1 })

let walk state instruction =
  let dir = turn state.dir instruction.turn in
  let rec inner state instruction =
    let state, instruction = walk_step state dir instruction in
    if instruction.steps == 0 then state else inner state instruction
  in
  inner state instruction

let parse_instruction str =
  let str = String.trim str in
  let len = String.length str in
  let c_turn = String.get str 0 in
  let str_steps = String.sub str 1 (len - 1) in
  let steps = int_of_string str_steps in
  match c_turn with
  | 'R' -> { turn = R; steps }
  | 'L' -> { turn = L; steps }
  | c -> failwith (Printf.sprintf "unknown turn: %c" c)

let parse_input line = String.split_on_char ',' line |> List.map parse_instruction
let lin_distance (x1, y1) (x2, y2) = abs x1 - x2 + (abs y1 - y2)

let part1 (input : string) : string =
  let instructions = parse_input input in
  let initial_state = { pos = (0, 0); dir = N } in
  let final_state = List.fold_left walk initial_state instructions in
  string_of_int (lin_distance final_state.pos initial_state.pos)

module PosSet = Set.Make (struct
  type t = pos

  let compare = compare
end)

let show_pos_set s =
  PosSet.elements s |> List.map show_pos |> String.concat "; " |> Printf.sprintf "{ %s }"

let part2 (input : string) : string =
  let rec walk_part2 visited state = function
    | [] -> state.pos
    | instruction :: rest ->
        let prev_dir = state.dir in
        let dir = turn state.dir instruction.turn in
        let state, instruction = walk_step state dir instruction in
        if PosSet.mem state.pos visited then state.pos
        else
          let visited = PosSet.add state.pos visited in
          let instructions =
            if instruction.steps == 0 then rest else instruction :: rest
          in
          let state =
            if instruction.steps == 0 then state else { state with dir = prev_dir }
          in
          walk_part2 visited state instructions
  in
  let initial_state = { pos = (0, 0); dir = N } in
  let instructions = parse_input input in
  let hq = walk_part2 PosSet.empty initial_state instructions in
  string_of_int (lin_distance hq initial_state.pos)
