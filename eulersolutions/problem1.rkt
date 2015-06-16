#lang racket

(let ([sum 0])
  (for ([i (in-range 1000)])
    (when (or (= (modulo i 3) 0) (= (modulo i 5) 0))
      (set! sum (+ sum i))))
  sum)