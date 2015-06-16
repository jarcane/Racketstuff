#lang racket

(let loop ([num 2519])
  (if (for/and ([i (in-range 1 20)])
        (= (modulo num i) 0))
      num
      (loop (add1 num))))

(apply lcm (for/list ([i (in-range 1 20)]) i))