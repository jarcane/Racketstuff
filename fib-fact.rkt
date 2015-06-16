#lang s-exp heresy

(def fn fact (n)
  (apply * (range 1 to n)))

(def fn fib (n)
  (select
   ((zero? n) 0)
   ((one? n) 1)
   (else (+ (fib (- n 2))
            (fib (dec n))))))