#lang racket

(define (push x a-list)
  (set-box! a-list (cons x (unbox a-list))))

(define (pop a-list)
  (let ((result (first (unbox a-list))))
    (set-box! a-list (rest (unbox a-list)))
    result))

(define elements unbox)

(define stack (box '()))
(push 1 stack)
(push 5 stack)
(push + stack)
((pop stack) (pop stack) (pop stack))