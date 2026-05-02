(ns aoc2015.day01-test
  (:require [clojure.test :refer [deftest is]]
            [aoc2015.day01 :as d]))

(deftest part1-test
  (is (= 0 (d/part1 "(())")))
  (is (= 0 (d/part1 "()()")))
  (is (= 3 (d/part1 "(((")))
  (is (= 3 (d/part1 "))(((((")))
  (is (= -1 (d/part1 "())")))
  (is (= -1 (d/part1 "))(")))
  (is (= -3 (d/part1 ")))")))
  (is (= -3 (d/part1 ")())())")))
  )

(deftest part2-test
  (is (= 1 (d/part2 ")")))
  (is (= 5 (d/part2 "()())")))
  )
