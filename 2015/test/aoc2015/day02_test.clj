(ns aoc2015.day02-test
  (:require [clojure.test :refer [deftest is]]
            [aoc2015.day02 :as d]))

(deftest part1-test
  (is (= 58 (d/part1 "2x3x4")))
  (is (= 43 (d/part1 "1x1x10")))
  )

(deftest part2-test
  (is (= 34 (d/part2 "2x3x4")))
  (is (= 14 (d/part2 "1x1x10")))
  )
