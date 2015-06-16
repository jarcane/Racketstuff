#lang racket

;(define (q f l)
;  (if (null? l)
;      l
;      (append (q f (filter (curry (negate f) (car l)) (cdr l)))
;              `(,(car l)) 
;              (q f (filter (curry f (car l)) (cdr l))))))

(define (quicksort < l)
  (match l
    ['() '()]
    [(cons x xs) (append (quicksort < (filter (curry (negate <) x) xs))
                         (list x)
                         (quicksort < (filter (curry < x) xs)))]))

;(define (s f l)
;  (match l
;    ['() '()]
;    [(cons h t) (append (s f (filter (curry (negate f) h) t))
;                        `(,h) 
;                        (s f (filter (curry f h) t)))]))

(define (s f l)(match l['() '()][(cons h t)(append(s f(filter(curry(negate f)h)t))`(,h)(s f(filter(curry f h)t)))]))