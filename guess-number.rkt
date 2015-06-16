#lang racket

(define (start n m)
  (set! lower (min n m))
  (set! upper (max n m))
  (set! count (add1 count))
  (guess))

(define lower 1)

(define upper 100)

(define count 0)

(define (guess)
  (quotient (+ lower upper) 2))

(define (smaller)
  (set! upper (max lower (sub1 (guess))))
  (set! count (add1 count))
  (guess))

(define (bigger)
  (set! lower (min upper (add1 (guess))))
  (set! count (add1 count))
  (guess))

(define (correct)
  count)