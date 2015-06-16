#lang racket

(require mzlib/etc)

;(for ([n (in-range 1 101)])
;  (evcase 0
;          ((+ (modulo n 5)
;              (modulo n 3)) (displayln "FizzBuzz"))
;          ((modulo n 5) (displayln "Buzz"))
;          ((modulo n 3) (displayln "Fizz"))
;          (else (displayln n))))

(for ([n (in-range 1 101)])
  (let([% modulo])(displayln (evcase 0
               ((+ (% n 5)
                   (% n 3)) "FizzBuzz")
               ((% n 5) "Buzz")
               ((% n 3) "Fizz")
               (0 n)))))

; (require mzlib/etc)(for([n(in-range 1 101)])(let([% modulo])(displayln(evcase 0((% n 15)"FizzBuzz")((% n 5)"Buzz")((% n 3)"Fizz")(0 n)))))