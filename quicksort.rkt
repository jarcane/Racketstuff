#lang racket

(define (qs lst)
  (if (empty? lst)
      lst
      (let* ((hd (car lst))
             (tl (cdr lst))
             (smaller (qs (for/list ((i tl) #:when (<= i hd)) i)))
             (larger (qs (for/list ((i tl) #:when (> i hd)) i))))
        (flatten (cons smaller (cons hd larger))))))

(define (qs-2 fun lst)
  (if (empty? lst)
      lst
      (let* ((hd (car lst))
             (tl (cdr lst))
             (smaller (qs-2 fun (for/list ((i tl) #:when (fun i hd)) i)))
             (larger (qs-2 fun (for/list ((i tl) #:when ((negate fun) i hd)) i))))
        (flatten (cons smaller (cons hd larger))))))

(define (qs-3 fun lst)
  (if (empty? lst)
      lst
      (let ((smaller (qs-3 fun (filter (curryr fun          (car lst)) (cdr lst))))
            (larger  (qs-3 fun (filter (curryr (negate fun) (car lst)) (cdr lst)))))
        (flatten (cons smaller (cons (car lst) larger))))))

(define (qs-4 f l)
  (if (empty? l)
      l
      (flatten (cons (qs-4 f (filter (curryr f (car l)) (cdr l))) 
                     (cons (car l) (qs-4 f (filter (curryr (negate f) (car l)) (cdr l))))))))