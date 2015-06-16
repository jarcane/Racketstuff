#lang racket
(require 2htdp/image 2htdp/universe)

(struct pit (snake goos))
(struct snake (dir segs))
(struct posn (x y))
(struct goo (loc expire))

(define (start-snake)
  (big-bang (pit (snake "right" (list (posn 1 1)))
                 (list (fresh-goo)
                       (fresh-goo)
                       (fresh-goo)
                       (fresh-goo)
                       (fresh-goo)
                       (fresh-goo)))
            (on-tick next-pit TICK-RATE)
            (on-key direct-snake)
            (to-draw render-pit)
            (stop-when dead? render-end)))

(define (next-pit w)
  (define snake (pit-snake w))
  (define goos (pit-goos w))
  (define goo-to-eat (can-eat snake goos))
  (if goo-to-eat
      (pit (grow snake) (age-goo (eat goos goo-to-eat)))
      (pit (slither snake) (age-goo goos))))

(define (can-eat snake goos)
  (cond ((empty? goos) #f)
        (else (if (close? (snake-head snake) (first goos))
                  (first goos)
                  (can-eat snake (rest goos))))))

(define (close? s g)
  (posn=? s (goo-loc g)))

(define (eat goos goo-to-eat)
  (cons (fresh-goo) (remove goo-to-eat goos)))

(define (grow sn)
  (snake (snake-dir sn)
         (cons (next-head sn) (snake-segs sn))))

(define (slither sn)
  (snake (snake-dir sn)
         (cons (next-head sn) (all-but-last (snake-segs sn)))))

(define (all-but-last segs)
  (cond ((empty? (rest segs)) empty)
        (else (cons (first segs) (all-but-last (rest segs))))))

(define (next-head sn)
  (define head (snake-head sn))
  (sefine dir (snake-dir sn))
  (cond ((string=? dir "up") (posn-move head 0 -1))
        ((string=? dir "down") (posn-move head 0 1))
        ((string=? dir "left") (posn-move head -1 0))
        ((string=? dir "right") (posn-move head 1 0))))

(define (posn-move p dx dy)
  (posn (+ (posn-x p) dx)
        (+ (posn-y p) dy)))

(define (age-goo goos)
  (rot (renew goos)))

(define (rot goos)
  (cond ((empty? goos) empty)
        (else (cons (decay (first goos)) (rot (rest goos))))))

(define (renew goos)
  (cond ((empty? goos) empty)
        ((rotten? (first goos))
         (cons (fresh-goo) (renew (rest goos))))
        ((else
          (cons (first goos) (renew (rest goos)))))))

(define (rotten? g)
  (zero? (goo-expire g)))

(define (fresh-goo)
  (goo (posn (add1 (random (sub1 SIZE)))
             (add1 (random (sub1 SIZE))))
       (add1 (random EXPIRATION-TIME))))

(define (direct-snake w ke)
  (cond ((dir? ke) (world-change-dir w ke))
        (else w)))

(define (dir? x)
  (or (key=? x "up")
      (key=? x "down")
      (key=? x "left")
      (key=? x "right")))

(define (world-change-dir w d)
  (define the-snake (pit-snake w))
  (cond ((and (opposite-dir? (snake-dir the-snake) d)
              ;; consists of the head and at least one segment
              (cons? (rest (snake-segs the-snake))))
         (stop-with w))
        (else
         (pit (snake-change-dir the-snake d) (pit-goos w)))))

(define (opposite-dir? d1 d2)
  (cond [(string=? d1 "up") (string=? d2 "down")]
        [(string=? d1 "down") (string=? d2 "up")]
        [(string=? d1 "left") (string=? d2 "right")]
        [(string=? d1 "right") (string=? d2 "left")]))