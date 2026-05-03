let p1_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day1.part1 input) )

let day1_part1 =
  [ p1_case "R2, L3" "5"; p1_case "R2, R2, R2" "2"; p1_case "R5, L5, R5, R3" "12" ]

let day1_part2 =
  [
    ( "stub",
      `Quick,
      fun () -> Alcotest.(check string) "" "not implemented" (Aoc2016.Day1.part2 "") );
  ]

let () = Alcotest.run "aoc2016" [ ("day1 part1", day1_part1); ("day1 part2", day1_part2) ]
