#lang lazy
;; An infinite list:
(define fibs
  (list* 1 1 (map + fibs (cdr fibs))))
 
(define (add-evens [sum 0] [index 0])
  (let ([val (list-ref fibs index)])
    (if (< val 4000000) (add-evens (if (even? val) (+ sum val) sum) (add1 index))
    sum)))