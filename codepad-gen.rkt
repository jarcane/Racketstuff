#lang heresy

(import rkt racket)

(def fn rnd-in-range (n)
  (int (* (rnd) n)))

(def fn gen-code () (append (for (x in (range 1 to 4))
                              (carry (join (rnd-in-range 10) cry)))
                            (select case (rnd-in-range 2)
                                    ((0) '(A))
                                    ((1) '(B)))))

(def code '(7 2 6 2 A))

(def fn check-code? (try)
  (->> try
       (zipwith equal? code)
       (foldl (fn (a b) (and a b)) True)))

(rkt:time
 (do loop
   (def try (gen-code))
   (if (check-code? try) then
       (break try)
       else Null)))