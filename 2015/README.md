# aoc 2015 — clojure

## Setup

Need Clojure CLI + Java 17+.

```sh
brew install clojure/tools/clojure
```

First run downloads deps automatically.

## Layout

```
2015/
  deps.edn                       # project + aliases
  src/aoc2015/dayNN.clj          # one ns per day
  test/aoc2015/dayNN_test.clj    # tests per day
  inputs/dayNN.txt               # gitignored, your input
```

## Add a day

1. Copy `src/aoc2015/day01.clj` → `src/aoc2015/day02.clj`. Rename ns to `aoc2015.day02`.
2. Copy test file the same way.
3. Drop puzzle input at `inputs/day02.txt`.

## Run a day

```sh
clojure -M -m aoc2015.day01
```

Prints part1 + part2. Reads `inputs/day01.txt`.

## Run tests

All:

```sh
clojure -M:test
```

One ns:

```sh
clojure -M:test -n aoc2015.day01-test
```

One var:

```sh
clojure -M:test -v aoc2015.day01-test/part1-test
```

## REPL

```sh
clojure
```

Then:

```clojure
(require '[aoc2015.day01 :as d] :reload)
(d/part1 "(())")
```

`:reload` picks up file edits without restart.

### Editor REPL

Most Clojure flow is editor-driven, not CLI:

- VSCode → Calva extension. `Ctrl+Alt+C Ctrl+Alt+J` → "jack-in" → pick `deps.edn`.
- Emacs → CIDER. `cider-jack-in-clj`.
- IntelliJ → Cursive.
- Neovim → Conjure.

Eval form under cursor, see result inline. Faster than restarting CLI.

## deps.edn aliases

- `:test` — Cognitect test-runner.

## Tips

- Each day = pure functions `part1`/`part2` taking input string. Keeps tests easy.
- Use sample inputs from puzzle description as test cases before running on real input.
- `clojure.string` for parsing. `re-seq` / `re-find` for regex. `clojure.set` for set ops.
