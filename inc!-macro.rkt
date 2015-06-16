#lang racket

(define-syntax inc!
  (syntax-rules ()
    ((_ a)
     (set! a (add1 a)))))

(define-syntax add!
  (syntax-rules ()
    ((_ a b ...)
     (set! a (+ a b ...)))))

(define-syntax inc!*
  (syntax-rules ()
    ((_ a ...)
     (begin (set! a (add1 a)) ...))))

(define-syntax sync!
  (syntax-rules ()
    ((_ a ...)
     (let ([x (+ a ...)])
       (begin (set! a x) ...)))))

(define-syntax set!*
  (syntax-rules ()
    ((_ a b ...)
     (begin (set! b a) ...))))

(define x 5)
(define y 6)
(define z 7)
(inc!* x y z)
(list x y z)