#lang racket
(require math/number-theory)

(let loop ([iter 1])
  (if (> (length (divisors (triangle-number iter))) 500)
      (triangle-number iter)
      (loop (add1 iter))))