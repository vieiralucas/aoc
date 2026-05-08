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

let d2p2_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day2.part2 input) )

let day2_part2 = [ d2p2_case "ULL\nRRDDD\nLURDL\nUUUUD" "5DB3" ]

let d3p1_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day3.part1 input) )

let day3_part1 =
  [ d3p1_case "5 10 25" "0"; d3p1_case "3 4 5" "1"; d3p1_case "5 10 25\n3 4 5" "1" ]

let d3p2_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day3.part2 input) )

let day3_part2 =
  [
    d3p2_case
      "101 301 501\n102 302 502\n103 303 503\n201 401 601\n202 402 602\n203 403 603" "6";
  ]

let d4p1_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day4.part1 input) )

let day4_part1 =
  [
    d4p1_case
      "aaaaa-bbb-z-y-x-123[abxyz]\n\
       a-b-c-d-e-f-g-h-987[abcde]\n\
       not-a-real-room-404[oarel]\n\
       totally-real-room-200[decoy]"
      "1514";
  ]

let _d4p2_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day4.part2 input) )

let day4_part2_decrypt =
  let key = 343 in
  let input = String.split_on_char '-' "qzmt-zixmtkozy-ivhz" in
  let output = "very encrypted name" in
  [
    ( Printf.sprintf "%s + %d -> %s" (String.concat "-" input) key output,
      `Quick,
      fun () -> Alcotest.(check string) "" output (Aoc2016.Day4.decrypt_parts key input)
    );
  ]

let day4_part2_shift =
  [
    ( Printf.sprintf "%c + %d -> %c" 'a' 1 'b',
      `Quick,
      fun () -> Alcotest.(check char) "" 'b' (Aoc2016.Day4.shift 1 'a') );
    ( Printf.sprintf "%c + %d -> %c" 'z' 1 'a',
      `Quick,
      fun () -> Alcotest.(check char) "" 'a' (Aoc2016.Day4.shift 1 'z') );
    ( Printf.sprintf "%c + %d -> %c" 'y' 3 'b',
      `Quick,
      fun () -> Alcotest.(check char) "" 'b' (Aoc2016.Day4.shift 3 'y') );
  ]

let d5p1_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day5.part1 input) )

let day5_part1 = [ d5p1_case "abc" "18f47a30" ]

let d5p2_case input expected =
  ( Printf.sprintf "%S -> %s" input expected,
    `Quick,
    fun () -> Alcotest.(check string) "" expected (Aoc2016.Day5.part2 input) )

let day5_part2 = [ d5p2_case "abc" "05ace8e3" ]

let () =
  Alcotest.run "aoc2016"
    [
      ("day1 part1", day1_part1);
      ("day1 part2", day1_part2);
      ("day2 part1", day2_part1);
      ("day2 part2", day2_part2);
      ("day3 part1", day3_part1);
      ("day3 part2", day3_part2);
      ("day4 part1", day4_part1);
      ("day4 part2 decrypt", day4_part2_decrypt);
      ("day4 part2 shift", day4_part2_shift);
      ("day5 part1", day5_part1);
      ("day5 part2", day5_part2);
    ]
