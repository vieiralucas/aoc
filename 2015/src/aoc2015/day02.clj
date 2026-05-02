(ns aoc2015.day02
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(defn faces [[l w h]]
  (concat
   [[l w] [w h] [h l]]
   [[l w] [w h] [h l]]))

(defn perimeters [dimensions]
  (map (fn [[w h]] (+ (* w 2) (* h 2))) (faces dimensions)))

(defn areas [dimensions]
  (map (partial reduce *) (faces dimensions)))

(defn total-area [dimensions]
  (reduce + (areas dimensions)))

(defn volume [dimensions]
  (apply * dimensions))

(defn slack [dimensions]
  (reduce min (areas dimensions)))

(defn paper [dimensions]
  (+ (total-area dimensions) (slack dimensions)))

(defn ribbon [dimensions]
  (let [to-wrap (reduce min (perimeters dimensions))
        bow (volume dimensions)]
    (+ to-wrap bow)))

(defn parse-line [line]
  (map #(Integer/parseInt %) (str/split line #"x")))

(defn parse-input [input]
  (map parse-line (str/split-lines input)))

(defn part1 [input]
  (reduce + (map paper (parse-input input))))

(defn part2 [input]
  (reduce + (map ribbon (parse-input input))))

(defn -main [& _]
  (let [input (str/trim (slurp (io/file "inputs/day02.txt")))]
    (println "Part 1:" (part1 input))
    (println "Part 2:" (part2 input))))
