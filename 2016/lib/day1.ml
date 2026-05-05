type direction = N | S | E | W [@@deriving show]
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

let step_one state =
  let dx, dy = get_deltas state.dir in
  let x, y = state.pos in
  { state with pos = (x + dx, y + dy) }

let rec walk_blocks state = function
  | [] -> Seq.empty
  | instr :: rest ->
      let state = { state with dir = turn state.dir instr.turn } in
      let rec advance state n () =
        if n = 0 then walk_blocks state rest ()
        else
          let state = step_one state in
          Seq.Cons (state, advance state (n - 1))
      in
      advance state instr.steps

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
let lin_distance (x1, y1) (x2, y2) = abs (x1 - x2) + abs (y1 - y2)

let part1 (input : string) : string =
  let instructions = parse_input input in
  let init = { pos = (0, 0); dir = N } in
  let blocks = walk_blocks init instructions in
  let final = Seq.fold_left (fun _ s -> s) init blocks in
  let distance = lin_distance init.pos final.pos in
  string_of_int distance

module PosSet = Set.Make (struct
  type t = pos

  let compare = compare
end)

let part2 (input : string) : string =
  let init = { pos = (0, 0); dir = N } in
  let rec find visited seq =
    match seq () with
    | Seq.Nil -> None
    | Seq.Cons (s, rest) ->
        if PosSet.mem s.pos visited then Some s.pos
        else find (PosSet.add s.pos visited) rest
  in
  match find (PosSet.singleton init.pos) (walk_blocks init (parse_input input)) with
  | Some p -> string_of_int (lin_distance init.pos p)
  | None -> failwith "no revisit"
