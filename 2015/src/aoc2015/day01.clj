(ns aoc2015.day01
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(defn to-n [c]
  (case c \( 1 \) -1 :else 0))

(defn part1 [input]
  (reduce + (map to-n input)))

(defn part2 [input]
  (loop [chars input
         floor 0
         pos 1
        ]
    (cond
      (neg? floor) (dec pos)
      (empty? chars) nil
      :else (recur (rest chars)
                   (+ floor (to-n (first chars)))
                   (inc pos)))))

(defn -main [& _]
  (let [input (str/trim (slurp (io/file "inputs/day01.txt")))]
    (println "Part 1:" (part1 input))
    (println "Part 2:" (part2 input))))
