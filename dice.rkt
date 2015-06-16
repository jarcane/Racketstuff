#lang racket

;; dice.rkt - A simple die roller library for Racket
;; 
(provide (all-defined-out))

;; (d n s) takes two arguments, each of which must be whole numbers greater than 1.
;; n indicates the number of dice to be rolled
;; s indicates the number of sides on each die
;; Returns the sum of the roll made
(define (d n s)
  (for/sum ([i n])
    (add1 (random s))))

;; (d-list n s) uses similar arguments to (d n s), but instead produces a list of each die result
(define (d-list n s)
  (for/list ([i n])
    (add1 (random s))))

;; (d-list+sum) again uses the same arguments, but returns a tuple
;; The first entry will be a list of the individual die results
;; The second entry will be a sum of that list
(define (d-list+sum n s)
  (define l (d-list n s))
  (define sum (for/sum ([i l])
    i))
  `(,l ,sum))

;; (d-high n s h) allows for 'roll and keep highest' type rolls
;; The n and s parameters are as (d) but the function will only sum the highest h values
(define (d-high n s h)
  (define l (d-list n s))
  (for/sum ([i (sort l >)]
            [j (in-range h)])
    i))

;; (d-low n s l) follows a similar pattern to d-high, only keeping and summing the lowest l values
(define (d-low n s lo)
  (define l (d-list n s))
  (for/sum ([i (sort l <)]
            [j (in-range lo)])
    i))

;; (d-success n s test target) allows for die mechanics which count successes
;; n and s arguments are as before, and it uses these to generate a d-list internally
;; test is any function which can take two arguments and and returns #t or #f
;; The target is the value that each application of test to a d-list entry will be compared to.
;; The result returns a number indicating the number of dice in the list rolled that pass test
(define (d-success n s test target)
  (length (filter (lambda (x) (test x target)) (d-list n s))))

;; d-list+success follows the same arguments as d-success, but outputs a tuple
;; The first tuple item will be a list of dice rolled.
;; The second item will be the total number of those dice that returned #t against test & target
(define (d-list+success n s test target)
  (define l (d-list n s))
  `(,l ,(length (filter (lambda (x) (test x target)) l))))

;; d-test and d-list+test are simpler versions of the d-success family
;; Rather than test and target, they take only a simple predicate as the third argument
;; d-test returns the number of rolls that pass the test
(define (d-test n s test)
  (length (filter test (d-list n s))))

;; d-list+test returns a tuple with list and number of passes
(define (d-list+test n s test)
  (define l (d-list n s))
  `(,l ,(length (filter test l))))

;; dF takes a single argument, n, and returns the total of that many "Fudge Dice"
;; Fudge dice are unique dice which bear three faces, for +, -, and blank, each with equal odds
;; Note that this means the function can return negative numbers
(define (dF n)
  (for/sum ([i n])
    (- (add1 (random 3)) 2)))

;; dF-list takes a single argument as dF, but returns instead a list of pretty printed results
;; ie. +, 0, -
(define (dF-list n)
  (for/list ([i n])
    (case (dF 1)
      [(-1) '-]
      [(0) '0]
      [(1) '+])))

;; dF-list+sum takes one argument, n, as before, but returns a tuple of the result list and sum
(define (dF-list+sum n)
  (define l (dF-list n))
  (define sum (for/sum ([i l])
                (cond 
                  [(eq? i '+) 1]
                  [(eq? i '0) 0]
                  [(eq? i '-) -1])))
  `(,l ,sum))

;; d-arbitrary allows for arbitrary dice creation. Rather than taking a whole number for sides
;; d-arbitrary takes a list, and returns a list of n random choices from that list. 
;; This is useful for odd die assortments or even dice that employ symbols
(define (d-arbitrary n sides)
  (for/list ([i n])
    (list-ref sides (random (length sides)))))
