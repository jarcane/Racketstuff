#lang racket

;(define-syntax my-and
;  (syntax-rules ()
;    ((my-and) #t)
;    ((my-and a b ...) (if a
;                          (my-and b ...)
;                          #f))))

(define-syntax my-and.v2
  (syntax-rules ()
    [(_) #t]
    [(_ a) a]
    [(_ a b ...) (if a
                     (my-and.v2 b ...)
                     #f)]))

;(my-and #t #t #f (/ 5 0))
;(my-and (zero? 0) (displayln "Dave") #t)

(my-and.v2 #t #t #f (/ 5 0))
(my-and.v2 (zero? 0) (displayln "Dave") 4)

(define (broken-and . rest)
  (cond
    [(null? rest) #t]
    [(car rest) (apply broken-and (cdr rest))]
    [else #f]))
