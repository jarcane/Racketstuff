#lang racket
(require math/number-theory)

(let loop ([i 2000000]
           [sum 0])
  (let ([p (prev-prime i)])
    (if (< p 2)
        sum
        (loop p (+ p sum)))))