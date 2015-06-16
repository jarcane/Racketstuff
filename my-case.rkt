#lang racket

(define-syntax my-case
  (syntax-rules (else)
    [(_ val ((mtch ...) expr) rest ... (else expr2)) 
     (if (my-comp val (mtch ...))
         expr
         (my-case val rest ... (else expr2)))]
    [(_ val ((mtch ...) expr) (else expr2))
     (if (my-comp val (mtch ...))
         expr
         expr2)]
    [(_ val (else expr)) expr]
    [(_ val ((mtch ...) expr) rest ...)
     (my-case val ((mtch ...) expr) rest ... (else #f))]))

(define-syntax my-comp
  (syntax-rules ()
    [(_ v ()) #f]
    [(_ v (k)) (equal? v k)]
    [(_ v (k ks ...)) (if (equal? v k)
                          #t
                          (my-comp v (ks ...)))]))

(my-case (modulo 5 2) ((1) 'foo) ((0) 'bar))
;
(my-case 1 (((modulo 5 2)) 'foo) ((modulo 2 2) 'bar))

;(case 1 [(1) (print "foo")])

(let fizzbuzz ([n 1])
  (unless (> n 100)
    (my-case 0
             (((+ (modulo n 5)
                  (modulo n 3))) (begin (displayln "FizzBuzz")
                                        (fizzbuzz (add1 n))))
             (((modulo n 5)) (begin (displayln "Buzz")
                                    (fizzbuzz (add1 n))))
             (((modulo n 3)) (begin (displayln "Fizz")
                                    (fizzbuzz (add1 n))))
             (else (begin (displayln n)
                          (fizzbuzz (add1 n)))))))