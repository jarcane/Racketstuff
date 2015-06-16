#lang racket

(require math/number-theory)

(define Y (λ(b)((λ(f)(b(λ(x)((f f) x))))
                (λ(f)(b(λ(x)((f f) x)))))))

(define Fact
  (Y (λ(fact) (λ(n) (if (zero? n) 1 (* n (fact (- n 1))))))))

(define (classicfact n)
  (if (zero? n)
      1
      (* n (classicfact (sub1 n)))))

(define (k n (m 1))
  (if (<= n m)
      n
      (* (k n (* 2 m))
         (k (- n m) (* 2 m)))))


(time (void (Fact 10000)))

(time (void (classicfact 10000)))

(time (void (k 10000)))

(time (void (factorial 10000)))    
