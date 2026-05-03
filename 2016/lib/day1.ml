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

let walk state instruction =
  let x, y = state.pos in
  let dir = turn state.dir instruction.turn in
  let dx, dy = get_deltas dir in
  { pos = (x + (dx * instruction.steps), y + (dy * instruction.steps)); dir }

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

let part2 (_input : string) : string = "not implemented"
