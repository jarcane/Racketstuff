#lang racket

(define (palindromic? num)
  (let ([numstr (number->string num)])
    (if (string=? numstr (list->string (reverse (string->list numstr))))
        #t
        #f)))

(first (sort (filter palindromic? (flatten (for/list ([x (in-range 100 999)])
                                             (for/list ([y (in-range 100 999)])
                                               (* x y))))) >))