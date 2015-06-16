#lang racket

(let fib-loop ([x 0]
               [y 1]
               [sum 0])
  (let ([tmp (+ x y)]) 
    (if (< tmp 4000000)
        (fib-loop y tmp (if (even? tmp) (+ sum tmp) sum))
        sum)))