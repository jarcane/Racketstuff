#lang lazy

(define Y (λ(f)((λ(x)(f (x x)))(λ(x)(f (x x))))))

(define (fix f) (letrec ((g (f g))) g)) 

(define Fib
  (λ (fib) 
    (λ (n) 
      (if (< n 2)
          1
          (+ (fib (- n 2)) (fib (- n 1)))))))