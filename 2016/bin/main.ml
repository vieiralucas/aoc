type day = { number : int; part1 : string -> string; part2 : string -> string }

let days =
  [
    { number = 1; part1 = Aoc2016.Day1.part1; part2 = Aoc2016.Day1.part2 };
    { number = 2; part1 = Aoc2016.Day2.part1; part2 = Aoc2016.Day2.part2 };
  ]

let read_file path =
  try
    let ic = open_in path in
    let n = in_channel_length ic in
    let s = really_input_string ic n in
    close_in ic;
    Some s
  with Sys_error _ -> None

let run_part day part use_sample fn =
  let suffix = if use_sample then "sample" else "actual" in
  let path = Printf.sprintf "inputs/day%02d_%s.txt" day suffix in
  match read_file path with
  | None ->
      Printf.printf "Day %d Part %d%s: Input file not found (%s)\n" day part
        (if use_sample then " (sample)" else "")
        path
  | Some input ->
      let result = fn input in
      Printf.printf "Day %d Part %d%s: %s\n" day part
        (if use_sample then " (sample)" else "")
        result

let run_day day use_sample =
  match List.find_opt (fun d -> d.number = day) days with
  | Some d ->
      run_part day 1 use_sample d.part1;
      run_part day 2 use_sample d.part2
  | None -> Printf.printf "Day %d not implemented yet\n" day

let () =
  let use_sample = ref false in
  let day_arg = ref None in
  Array.iter
    (fun arg ->
      if arg = "--sample" then use_sample := true
      else if !day_arg = None then day_arg := Some arg)
    (Array.sub Sys.argv 1 (Array.length Sys.argv - 1));
  match !day_arg with
  | Some s -> (
      match int_of_string_opt s with
      | Some d -> run_day d !use_sample
      | None -> Printf.printf "Invalid day argument: %s\n" s)
  | None -> List.iter (fun d -> run_day d.number !use_sample) days
