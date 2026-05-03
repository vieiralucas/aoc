# aoc 2016 — ocaml

## Setup

Need OCaml + dune via opam.

```sh
brew install opam
opam init
opam install dune alcotest
```

## Layout

```
2016/
  dune-project
  bin/
    dune
    main.ml                    # dispatch + IO
  lib/
    dune                       # library `aoc2016`
    dayN.ml                    # one module per day
  inputs/
    dayNN_sample.txt           # puzzle example
    dayNN_actual.txt           # real input
  test/
    dune
    test_aoc2016.ml            # alcotest entry point
```

Each day module exposes:

```ocaml
val part1 : string -> string
val part2 : string -> string
```

## Add a day

1. Create `lib/dayN.ml` with `part1` + `part2` stubs.
2. Append to `days` list in `bin/main.ml`:
   ```ocaml
   { number = N; part1 = Aoc2016.DayN.part1; part2 = Aoc2016.DayN.part2 };
   ```
3. Drop inputs at `inputs/dayNN_sample.txt` + `inputs/dayNN_actual.txt` (zero-padded).

## Build

```sh
dune build
```

Watch mode:

```sh
dune build -w
```

## Run

Sample input:

```sh
dune exec bin/main.exe -- 1 --sample
```

Actual input:

```sh
dune exec bin/main.exe -- 1
```

All days:

```sh
dune exec bin/main.exe
```

Output format: `Day N Part P[ (sample)]: <result>`.

## Test

All tests:

```sh
dune test
```

Watch:

```sh
dune test -w
```

Add tests in `test/test_aoc2016.ml`. One Alcotest group per day. Append to top-level list:

```ocaml
let () =
  Alcotest.run "aoc2016" [
    "day1", day1_tests;
    "day2", day2_tests;
  ]
```

Each test: `name, `Quick, (fun () -> Alcotest.(check string) "msg" expected actual)`.

## REPL

```sh
dune utop lib
```

Then:

```ocaml
Aoc2016.Day1.part1 "input string";;
```

Edit + `#use "lib/day1.ml";;` to reload.

## Tips

- `part1`/`part2` pure `string -> string`. Easy to unit test or call from utop.
- `String.split_on_char`, `Str` (regex), `Hashtbl`, `Seq` for parsing.
- Stdlib only by default. Add libs via `lib/dune` `(libraries ...)` field + `opam install`.
