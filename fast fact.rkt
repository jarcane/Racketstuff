#lang racket

(require math/number-theory)

; adapted from http://www.cs.berkeley.edu/~fateman/papers/factorial.pdf

(define (k n (m 1))
  (if (<= n m)
      n
      (* (k n (* 2 m))
         (k (- n m) (* 2 m)))))

(time (void (k 1000000)))

(time (void (factorial 1000000)))