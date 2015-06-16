#lang racket
(require math/number-theory)

(let loop ([i 0])
  (let ([f (fibonacci i)])
    (if (= 1000 (string-length (number->string f)))
        i
        (loop (add1 i)))))