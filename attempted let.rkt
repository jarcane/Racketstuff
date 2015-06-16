#lang racket

(define dave '((is 5) (fat 6)))
 
(define-syntax letexpand
  (syntax-rules ()
    [(_ alst body ...)
     #`(let #,alst body ...)]))
 
(letexpand dave is fat)