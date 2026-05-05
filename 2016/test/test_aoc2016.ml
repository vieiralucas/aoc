let p1_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day1.part1 input) )

let day1_part1 =
  [ p1_case "R2, L3" "5"; p1_case "R2, R2, R2" "2"; p1_case "R5, L5, R5, R3" "12" ]

let p2_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day1.part2 input) )

let day1_part2 = [ p2_case "R8, R4, R4, R8" "4" ]

let d2p1_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day2.part1 input) )

let day2_part1 = [ d2p1_case "ULL\nRRDDD\nLURDL\nUUUUD" "1985" ]

let () =
  Alcotest.run "aoc2016"
    [ ("day1 part1", day1_part1); ("day1 part2", day1_part2); ("day2 part1", day2_part1) ]
