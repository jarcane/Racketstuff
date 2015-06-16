#lang racket

(define (collatz lst)
  (cond [(= (first lst) 1) lst]
        [(even? (first lst)) (collatz (cons (/ (first lst) 2) lst))]
        [(odd? (first lst)) (collatz (cons (+ (* 3 (first lst)) 1) lst))]))

(let chain-hunt ([i 999999]
                 [biggest 0])
  (if (<= i 1)
      biggest
      (chain-hunt (sub1 i) (if (= 525 (length (collatz `(,i)))) i biggest))))